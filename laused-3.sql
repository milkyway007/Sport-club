/*Domain laused*/
CREATE DOMAIN d_nimetus AS VARCHAR(70) NOT NULL
CONSTRAINT chk_nimetus_ei_koosne_tuhikutest CHECK(VALUE !~ '^[[:space:]]+$')
CONSTRAINT chk_nimetus_ei_ole_tuhi_string CHECK(VALUE!='');

CREATE DOMAIN d_kirjeldus AS VARCHAR(255)
CONSTRAINT chk_kirjeldus_ei_koosne_tuhikutest CHECK(VALUE !~ '^[[:space:]]+$')
CONSTRAINT chk_kirjeldus_ei_ole_tuhi_string CHECK(VALUE!='');



/*Create laused*/
CREATE TABLE Treeningu_seisundi_liik (
treeningu_seisundi_liik_kood CHAR(5) NOT NULL,
nimetus d_nimetus,
kirjeldus d_kirjeldus,
CONSTRAINT PK_Treeningu_seisundi_liik_kood PRIMARY KEY (treeningu_seisundi_liik_kood),
CONSTRAINT AK_Treeningu_seisundi_liik_nimetus UNIQUE (nimetus)
)WITH (fillfactor=80);

CREATE TABLE Spordiala (
spordiala_kood CHAR(5) NOT NULL,
nimetus d_nimetus,
kirjeldus d_kirjeldus,
CONSTRAINT AK_Spordiala_nimetus UNIQUE (nimetus),
CONSTRAINT PK_Spordiala_kood PRIMARY KEY (spordiala_kood)
)WITH (fillfactor=80);

CREATE TABLE Tootaja_seisundi_liik (
tootaja_seisundi_liik_kood CHAR(5) NOT NULL,
nimetus d_nimetus,
kirjeldus d_kirjeldus,
CONSTRAINT PK_Tootaja_seisundi_liik_kood PRIMARY KEY (tootaja_seisundi_liik_kood),
CONSTRAINT AK_Tootaja_seisundi_liik_kood_nimetus UNIQUE (nimetus)
)WITH (fillfactor=80);


CREATE TABLE Klient_seisundi_liik (
kliendi_seisundi_liik_kood CHAR(5) NOT NULL,
nimetus d_nimetus,
kirjeldus d_kirjeldus,
CONSTRAINT PK_Klient_seisundi_liik_kood PRIMARY KEY (kliendi_seisundi_liik_kood),
CONSTRAINT AK_Klient_seisundi_liik_nimetus UNIQUE (nimetus)
)WITH (fillfactor=80);	

CREATE TABLE Amet (
amet_kood CHAR(5) NOT NULL,
nimetus d_nimetus,
kirjeldus d_kirjeldus,
CONSTRAINT AK_Amet_nimetus UNIQUE (nimetus),
CONSTRAINT PK_Amet_kood PRIMARY KEY (amet_kood)
)WITH (fillfactor=80);

CREATE TABLE Tootaja (
tootaja_id SMALLSERIAL NOT NULL,
isikukood CHAR ( 11 ) NOT NULL,
amet_kood CHAR(5) NOT NULL,
tootaja_seisundi_liik_kood CHAR(5) DEFAULT 'AKTII' NOT NULL,
CONSTRAINT AK_Tootaja_isikukood UNIQUE (isikukood),
CONSTRAINT PK_Tootaja_kood PRIMARY KEY (tootaja_id));

CREATE TABLE Treening (
treening_id SMALLSERIAL NOT NULL,
spordiala_kood CHAR(5) NOT NULL,
treeningu_seisundi_liik_kood CHAR(5) DEFAULT 'AKTII' NOT NULL,
tootaja_id SMALLINT NOT NULL,
nimetus d_nimetus,
kirjeldus d_kirjeldus,
CONSTRAINT AK_Treening_nimetus UNIQUE (nimetus),
CONSTRAINT PK_Treening_id PRIMARY KEY (treening_id)
)WITH (fillfactor=70);

CREATE TABLE Klient (
klient_id SERIAL NOT NULL,
kliendi_seisundi_liik_kood CHAR(5) DEFAULT 'AKTII' NOT NULL,
isikukood CHAR ( 11 ) NOT NULL,
CONSTRAINT PK_Klient_kood PRIMARY KEY (klient_id),
CONSTRAINT AK_Klient_isikukood UNIQUE (isikukood));

CREATE TABLE Voimalik_labiviija (
voimalik_labiviija_id SERIAL NOT NULL,
treening_id SMALLINT NOT NULL,
tootaja_id SMALLINT NOT NULL,
alguse_aeg DATE NOT NULL,
lopu_aeg DATE NOT NULL,
CONSTRAINT AK_Voimalik_labiviija_treening_id_tootaja_id_alguse_aeg UNIQUE (alguse_aeg, tootaja_id, treening_id),
CONSTRAINT PK_Voimalik_labiviija_id PRIMARY KEY (voimalik_labiviija_id),
CONSTRAINT chk_Voimalik_labiviija_alguse_aeg_vahemikus_2000_2100 CHECK (alguse_aeg BETWEEN '2000-01-01' AND '2100-01-01'),
CONSTRAINT chk_Voimalik_labiviija_lopu_aeg_vahemikus_2000_2100 CHECK (lopu_aeg BETWEEN '2000-01-01' AND '2100-01-01'),
CONSTRAINT chk_Voimalik_labiviija_lopu_aeg_suurem_kui_alguse_aeg CHECK (lopu_aeg>=alguse_aeg));

CREATE TABLE Isik (
isikukood CHAR ( 11 ) NOT NULL,
kasutajanimi VARCHAR ( 10 ) NOT NULL,
email VARCHAR ( 70 ) NOT NULL,
eesnimi VARCHAR ( 60 ) NOT NULL,
perenimi VARCHAR ( 60 ) NOT NULL,
parool VARCHAR ( 60 ) NOT NULL,
registreerimise_aeg TIMESTAMP DEFAULT LOCALTIMESTAMP(0) NOT NULL,
elukoht VARCHAR ( 255 ),
CONSTRAINT PK_Isik_isikukood PRIMARY KEY (isikukood),
CONSTRAINT AK_Isik_kasutajanimi UNIQUE (kasutajanimi),
CONSTRAINT AK_Isik_email UNIQUE (email),
CONSTRAINT chk_Isik_elukoht_ei_koosne_tuhikutest CHECK (elukoht!~'^[[:space:]]+$'),
CONSTRAINT chk_Isik_kasutajanimi_ei_tohi_sisaldada_tuhikuid CHECK (kasutajanimi!~'^.*[[:space:]].*$'),
CONSTRAINT chk_Isik_eesnimi_ainult_esimene_taht_igal_eesnimel_suur CHECK (eesnimi~'^([[:upper:]]{1}[[:lower:]]+)(([[:space:]]|-)[[:upper:]]{1}[[:lower:]]+)*$'),
CONSTRAINT chk_Isik_registreerimise_aeg_vahemikus_2000_2100 CHECK (registreerimise_aeg BETWEEN '2000-01-01' AND '2100-01-01'),
CONSTRAINT chk_Isik_isikukood_koik_reeglid CHECK (isikukood~'^([3-6]{1}[[:digit:]]{2}[0-1]{1}[[:digit:]]{1}[0-3]{1}[[:digit:]]{5})$'),
CONSTRAINT chk_Isik_kasutajanimi_ei_tohi_olla_luhem_kui_4_marki CHECK (char_length(kasutajanimi)>3),
CONSTRAINT chk_Isik_perenimi_ainult_esimene_taht_igal_perenimel_suur CHECK (perenimi~'^([[:upper:]]{1}[[:lower:]]+)(([[:space:]]|-)[[:upper:]]{1}[[:lower:]]+)*$'),
CONSTRAINT chk_Isik_elukoht_ei_koosne_numbritest CHECK (elukoht!~'^[[:digit:]]+$'),
CONSTRAINT chk_Isik_email_peab_sisaldama_at_marki CHECK (email LIKE '%@%'),
CONSTRAINT chk_Isik_elukoht_ei_ole_tyhi_string CHECK (elukoht <> ''))WITH (fillfactor=70);

ALTER TABLE Voimalik_labiviija ADD CONSTRAINT FK_Tootaja_tootaja_id FOREIGN KEY (tootaja_id) REFERENCES Tootaja (tootaja_id)  ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Voimalik_labiviija ADD CONSTRAINT FK_Treening_treening_id FOREIGN KEY (treening_id) REFERENCES Treening (treening_id)  ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Treening ADD CONSTRAINT FK_Treeningu_seisundi_liik_treeningu_seisundi_liik_kood FOREIGN KEY (treeningu_seisundi_liik_kood) REFERENCES Treeningu_seisundi_liik (treeningu_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Treening ADD CONSTRAINT FK_Spordiala_spordiala_kood FOREIGN KEY (spordiala_kood) REFERENCES Spordiala (spordiala_kood)  ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Treening ADD CONSTRAINT FK_Tootaja_tootaja_id FOREIGN KEY (tootaja_id) REFERENCES Tootaja (tootaja_id)  ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE Klient ADD CONSTRAINT FK_Klient_seisundi_liik_kliendi_seisundi_liik_kood FOREIGN KEY (kliendi_seisundi_liik_kood) REFERENCES Klient_seisundi_liik (kliendi_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Klient ADD CONSTRAINT FK_Isik_isikukood FOREIGN KEY (isikukood) REFERENCES Isik (isikukood) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Tootaja ADD CONSTRAINT FK_Tootaja_seisundi_liik_tootaja_seisundi_liik_kood FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES Tootaja_seisundi_liik (tootaja_seisundi_liik_kood) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Tootaja ADD CONSTRAINT FK_Amet_amet_kood FOREIGN KEY (amet_kood) REFERENCES Amet (amet_kood)  ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Tootaja ADD CONSTRAINT FK_Isik_isikukood FOREIGN KEY (isikukood) REFERENCES Isik (isikukood)  ON DELETE CASCADE ON UPDATE CASCADE;





/*Index laused*/
CREATE INDEX idx_tootaja_tootaja_seisundi_liik_kood ON Tootaja (tootaja_seisundi_liik_kood );
CREATE INDEX idx_tootaja_amet_kood ON Tootaja (amet_kood );

CREATE INDEX idx_treening_tootaja_id ON Treening (tootaja_id );
CREATE INDEX idx_treening_treeningu_seisundi_liik_kood ON Treening (treeningu_seisundi_liik_kood);
CREATE INDEX idx_treening_spordiala_kood ON Treening (spordiala_kood );

CREATE INDEX idx_klient_kliendi_seisundi_liik_kood ON Klient (kliendi_seisundi_liik_kood );

CREATE INDEX idx_voimalik_labiviija_tootaja_id ON Voimalik_labiviija (tootaja_id);
CREATE INDEX idx_voimalik_labiviija_treening_id ON Voimalik_labiviija (treening_id);




CREATE INDEX idx_isik_perenimi ON Isik (perenimi );
CREATE INDEX idx_isik_eesnimi ON Isik (eesnimi );


/*Insert laused*/
INSERT INTO amet(amet_kood, nimetus, kirjeldus) VALUES ('JUHAT', 'Juhataja', 'See amet korraldab kogu spordiklubi tood. Samuti otsib juhataja uusi kliente, uusi treenereid ja korraldab reklaami.');
INSERT INTO amet(amet_kood, nimetus, kirjeldus) VALUES ('TREEN', 'Treener', 'See amet viib treeninguid labi ja postitab veebisaitidele uudiseid treeningutega seoses.');
INSERT INTO amet(amet_kood, nimetus, kirjeldus) VALUES ('ADMIN', 'Administraator', 'See amet vastab telefonile, aitab klientidel registreerida treeningutele, kontrollib et spordiklubisse sisenevad ainult kliendid ja muub spordijooke.');

INSERT INTO klient_seisundi_liik(kliendi_seisundi_liik_kood, nimetus, kirjeldus) VALUES ('AKTII', 'Aktiivne', 'Seda liiki klient kaib regulaarselt trennis ja maksab kuumaksu.');
INSERT INTO klient_seisundi_liik(kliendi_seisundi_liik_kood, nimetus, kirjeldus) VALUES ('PUHKU', 'Puhkusel', 'Seda liiki klient on treeningpuhkusel, selle jaoks on loa kinnitanud juhataja.');
INSERT INTO klient_seisundi_liik(kliendi_seisundi_liik_kood, nimetus, kirjeldus)  VALUES ('LOPET', 'Lopetatud', 'Seda liiki klient on varasemalt olnud spordiklubi klient ja enam ei ole.');

INSERT INTO spordiala(spordiala_kood, nimetus, kirjeldus) VALUES ('AJOOG', 'Jooga algajatele', 'Jooga trenn algajatele.');
INSERT INTO spordiala(spordiala_kood, nimetus, kirjeldus) VALUES ('EJOOG', 'Jooga edasijoudnutele', 'Jooga trenn edasijoudnutele.');
INSERT INTO spordiala(spordiala_kood, nimetus, kirjeldus)  VALUES ('BODYP', 'Bodypump', 'Bodypump trenn mis jargib rahvusvaheliselt regulaarselt muudetavat kava.');

INSERT INTO tootaja_seisundi_liik(tootaja_seisundi_liik_kood, nimetus, kirjeldus)  VALUES ('AKTII', 'Aktiivselt tool kaiv tootaja', 'Tootaja kes kaib regulaarselt tool.');
INSERT INTO tootaja_seisundi_liik(tootaja_seisundi_liik_kood, nimetus, kirjeldus)   VALUES ('PUHKU', 'Puhkusel olev tootaja', 'Tootaja kes on puhkusel.');
INSERT INTO tootaja_seisundi_liik(tootaja_seisundi_liik_kood, nimetus, kirjeldus)   VALUES ('LOPET', 'Lopetatud', 'See tootaja on varasemalt olnud spordiklubi tootaja ja enam ei ole.');

INSERT INTO treeningu_seisundi_liik(treeningu_seisundi_liik_kood, nimetus, kirjeldus)   VALUES ('AKTII', 'Aktiivne', 'Treening toimub regulaarselt.');
INSERT INTO treeningu_seisundi_liik(treeningu_seisundi_liik_kood, nimetus, kirjeldus) VALUES ('LOPLI', 'Loplikult peatatud', 'Treening on juhatuse soovil loplikult peatatud.');
INSERT INTO treeningu_seisundi_liik(treeningu_seisundi_liik_kood, nimetus, kirjeldus) VALUES ('AJUTI', 'Ajutiselt peatatud', 'Treening on juhatuse soovil ajutisel peatatud.');



INSERT INTO isik(isikukood, kasutajanimi, email, eesnimi, perenimi, parool, registreerimise_aeg, elukoht) VALUES ('31212121212', 'Sass123', 'sander@sander.ee', 'Sander', 'Saarsen', 'Parool123', '2015-10-28 11:22:07', 'Akadeemia tee 99-99, 61616, Tallinn');
INSERT INTO isik(isikukood, kasutajanimi, email, eesnimi, perenimi, parool, registreerimise_aeg, elukoht) VALUES ('49012122711', 'Maasikas8', 'mari.maasikas@mail.ee', 'Mari', 'Maasikas', 'Maasu156', '2015-10-28 11:31:23', 'Tamme 15, 61617, Viimsi');
INSERT INTO isik(isikukood, kasutajanimi, email, eesnimi, perenimi, parool, registreerimise_aeg, elukoht) VALUES ('38512252222', 'bonbon', 'jtamm@gmail.com', 'Juhan', 'Tamm', 'kovapahkel', '2015-10-29 14:47:09', 'Pihlaka tn 3-4,Tallinn');
INSERT INTO isik(isikukood, kasutajanimi, email, eesnimi, perenimi, parool, registreerimise_aeg, elukoht) VALUES ('60206021111', 'torm007', 'mailiis@mail.ee', 'Anna-Mai-Liis', 'Kask-Toomingas', 'vagaturvaline123', '2015-10-29 14:51:20', 'Kibuvitsa tn 13-14, Tallinn');
INSERT INTO isik(isikukood, kasutajanimi, email, eesnimi, perenimi, parool, registreerimise_aeg, elukoht) VALUES ('46512122711', 'juhataja1', 'boss@treening.ee', 'Uku', 'Labidas', 'parool1', '2015-11-04 10:32:36', 'Mustamae tee 36-63, 61265, Tallinn');

INSERT INTO klient(klient_id, kliendi_seisundi_liik_kood, isikukood) VALUES (1, 'AKTII', '49012122711');
INSERT INTO klient(klient_id, kliendi_seisundi_liik_kood, isikukood)  VALUES (2, 'LOPET', '60206021111');
INSERT INTO klient(klient_id, kliendi_seisundi_liik_kood, isikukood)  VALUES (4, 'PUHKU', '38512252222');

INSERT INTO tootaja(tootaja_id, isikukood,amet_kood, tootaja_seisundi_liik_kood) VALUES (1, '31212121212', 'ADMIN', 'AKTII');
INSERT INTO tootaja(tootaja_id, isikukood,amet_kood, tootaja_seisundi_liik_kood) VALUES (2, '38512252222', 'TREEN', 'PUHKU');
INSERT INTO tootaja(tootaja_id, isikukood,amet_kood, tootaja_seisundi_liik_kood) VALUES (3, '46512122711', 'JUHAT', 'AKTII');

INSERT INTO treening(treening_id, spordiala_kood, treeningu_seisundi_liik_kood, tootaja_id, nimetus,kirjeldus) VALUES (1, 'AJOOG', 'AKTII', 1, 'Jooga algajatele', 'Tulge trenni');
INSERT INTO treening(treening_id, spordiala_kood, treeningu_seisundi_liik_kood, tootaja_id, nimetus, kirjeldus)  VALUES (2, 'BODYP', 'AJUTI', 1, 'Extremely effective bodypump', 'erakordselt kovade inimeste jaoks');
INSERT INTO treening(treening_id, spordiala_kood, treeningu_seisundi_liik_kood, tootaja_id, nimetus, kirjeldus)  VALUES (5, 'EJOOG', 'AKTII', 1, 'Jooga edasijoudnutele', 'veenita oma vasinud lihaseid');

INSERT INTO voimalik_labiviija(voimalik_labiviija_id, treening_id, tootaja_id, alguse_aeg, lopu_aeg) VALUES (1, 1, 1, '2016-01-01', '2016-12-31');
INSERT INTO voimalik_labiviija (voimalik_labiviija_id, treening_id, tootaja_id, alguse_aeg, lopu_aeg) VALUES (2, 2, 2, '2015-06-01', '2015-12-31');
INSERT INTO voimalik_labiviija (voimalik_labiviija_id, treening_id, tootaja_id, alguse_aeg, lopu_aeg)  VALUES (4, 5, 2, '2015-08-15', '2016-02-15');



/*View laused*/
CREATE OR REPLACE VIEW koik_kliendid_seisundiga WITH (security_barrier) AS SELECT 
Klient.isikukood AS klient_isikukood,
Isik.eesnimi AS klient_eesnimi, 
Isik.perenimi AS klient_perenimi,
Klient_seisundi_liik.nimetus AS klient_seisund
FROM 
(Klient INNER JOIN Klient_seisundi_liik ON Klient.kliendi_seisundi_liik_kood =     Klient_seisundi_liik.kliendi_seisundi_liik_kood) INNER JOIN Isik ON Klient.isikukood = Isik.isikukood
ORDER BY Isik.perenimi, Isik.eesnimi;

COMMENT ON VIEW koik_kliendid_seisundiga IS 'Vaade naitab koigi susteemis registreeritud klientide isikukoode, ees-, perekonnanimesid ja hetkeseisundeid.';

CREATE OR REPLACE VIEW koik_treeningud WITH (security_barrier)
AS SELECT
Treening.nimetus AS treening_nimetus,
Treening.kirjeldus AS treening_kirjeldus,
Isik.eesnimi || ' ' || Isik.perenimi AS registreerija_nimi,
Isik.isikukood AS registreerija_isikukood,
Treeningu_seisundi_liik.nimetus AS treening_seisund
FROM Treeningu_seisundi_liik INNER JOIN ((Isik INNER JOIN Tootaja ON Isik.isikukood = Tootaja.isikukood) INNER JOIN Treening ON Tootaja.tootaja_id = Treening.tootaja_id) ON Treeningu_seisundi_liik.treeningu_seisundi_liik_kood = Treening.treeningu_seisundi_liik_kood
ORDER BY Treening.nimetus;

COMMENT ON VIEW koik_treeningud IS 'Vaade annab ulevaate koigist spordiklubis pakutavatest treeningutest
ning naitab iga treeningu kohta selle nimetust, kirjeldust, treeningut registreerunud tootaja nime ja isikukoodi ning treeningu hetkeseisundi.';

CREATE OR REPLACE VIEW treeningute_labiviijad WITH (security_barrier)
AS SELECT
treening.nimetus AS treening_nimetus,
voimalik_labiviija.alguse_aeg AS perioodi_algus,
voimalik_labiviija.lopu_aeg AS perioodi_lopp,
isik.eesnimi || ' ' || isik.perenimi AS labiviija_nimi,
tootaja.isikukood AS labiviija_isikukood
FROM
public.voimalik_labiviija,
public.treening,
public.tootaja,
public.isik
WHERE
voimalik_labiviija.tootaja_id = tootaja.tootaja_id AND
treening.treening_id = voimalik_labiviija.treening_id AND
tootaja.isikukood = isik.isikukood
ORDER BY treening.nimetus, voimalik_labiviija.alguse_aeg;

COMMENT ON VIEW treeningute_labiviijad IS 'Vaade naitab, kes tegeleb konkreetse treeningu labiviimisega konkreetsel ajaperioodil.';

CREATE OR REPLACE VIEW koik_tootajad_seisundiga WITH (security_barrier)
AS SELECT
tootaja.isikukood AS tootaja_isikukood,
isik.eesnimi AS tootaja_eesnimi,
isik.perenimi AS tootaja_perenimi,
isik.email AS tootaja_epost,
amet.nimetus AS tootaja_amet,
tootaja_seisundi_liik.nimetus AS tootaja_seisund
FROM
public.tootaja,
public.isik,
public.tootaja_seisundi_liik,
public.amet
WHERE
isik.isikukood = tootaja.isikukood AND
tootaja.amet_kood = amet.amet_kood AND
tootaja.tootaja_seisundi_liik_kood = tootaja_seisundi_liik.tootaja_seisundi_liik_kood
ORDER BY isik.perenimi, isik.eesnimi;

COMMENT ON VIEW koik_tootajad_seisundiga IS 'Vaade naitab koigi susteemis registreeritud tootajate isikukoode, ees- ja perekonnanimesid, e-posti aadresseid, ameteid ja hetkeseisundeid.';




/*Funtsioonid*/

CREATE OR REPLACE FUNCTION f_treeningu_registreerimine
(Tootaja.tootaja_id%TYPE, Spordiala.spordiala_kood%TYPE, Treening.nimetus%TYPE, Treening.kirjeldus%TYPE)
RETURNS Treening.treening_id%TYPE AS
$$ INSERT INTO Treening( tootaja_id, spordiala_kood, nimetus, kirjeldus)
VALUES ($1, $2, $3, $4)
RETURNING treening_id;
$$ LANGUAGE sql SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_treeningu_registreerimine
(Tootaja.tootaja_id%TYPE, Spordiala.spordiala_kood%TYPE, Treening.nimetus%TYPE, Treening.kirjeldus%TYPE)
 IS 'Selle funktsiooni abil lisatakse uus treening. Funktsioon realiseerib andmebaasioperatsiooni OP5.1.
 Funktsiooni esimene argument votab vastu registreeriva tootaja id, teine
 argument spordiala koodi, kolmas argument treeningu nimetuse ja viimane neljas argument treeningu kirjelduse.';
 
 
CREATE OR REPLACE FUNCTION f_treeningu_mitteaktiivseks_muutmine(Treening.nimetus%TYPE)
RETURNS VOID AS $$
UPDATE Treening SET treeningu_seisundi_liik_kood = 'AJUTI'
WHERE nimetus = $1 AND treeningu_seisundi_liik_kood = 'AKTII';
$$ LANGUAGE sql SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_treeningu_mitteaktiivseks_muutmine(Treening.nimetus%TYPE)
IS 'Selle funktsiooni abil muudetakse treening ajutiselt peatatuks. Funktsioon realiseerib andmebaasioperatsiooni OP5.2.
Funktsiooni argument votab vastu treeningu id.';


CREATE OR REPLACE FUNCTION f_treeningu_aktiivseks_muutmine(Treening.treening_id%TYPE)
RETURNS VOID AS $$
UPDATE Treening SET treeningu_seisundi_liik_kood = 'AKTII'
WHERE treening_id = $1 AND treeningu_seisundi_liik_kood = 'AJUTI';
$$ LANGUAGE sql SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_treeningu_aktiivseks_muutmine(Treening.treening_id%TYPE)
IS 'Selle funktsiooni abil muudetakse treening aktiivseks. Funktsioon realiseerib andmebaasioperatsiooni OP5.3.
Funktsiooni argument votab vastu treeningu id.';


CREATE OR REPLACE FUNCTION f_treeningu_kustutamine (Treening.treening_id%TYPE)
RETURNS VOID AS $$
UPDATE Treening SET treeningu_seisundi_liik_kood='LOPLI'
WHERE treening_id = $1 AND treeningu_seisundi_liik_kood<>'LOPLI';
$$ LANGUAGE sql SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_treeningu_kustutamine (Treening.treening_id%TYPE) IS 'Selle
funktsiooni abil tuhistatakse treening. Funktsioon realiseerib andmebaasioperatsioon
OP5.4. Funktsiooni valjakutsel on argumendiks tuhistatava treeningu identifikaator.';


CREATE OR REPLACE FUNCTION f_uue_labiviija_lisamine (Treening.treening_id%TYPE,
Tootaja.tootaja_id%TYPE, Voimalik_labiviija.alguse_aeg%TYPE, Voimalik_labiviija.lopu_aeg%TYPE)
RETURNS VOID AS $$
INSERT INTO Voimalik_labiviija(treening_id, tootaja_id, alguse_aeg, lopu_aeg)
VALUES ($1, $2, $3, $4);
$$ LANGUAGE sql SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_uue_labiviija_lisamine (Treening.treening_id%TYPE,
Tootaja.tootaja_id%TYPE, Voimalik_labiviija.alguse_aeg%TYPE, Voimalik_labiviija.lopu_aeg%TYPE) IS
'Selle funktsiooni abil lisatakse uus labiviija. See funktsioon realiseerib
andmebaasioperatsiooni OP5.6. Funktsiooni valjakutses on esimene argument treeningu id, mida uus labiviija hakkab andma ,
teine argument - tootaja, kes treeningut andma hakab, kolmas - antud tootaja poolt antud treeningu labiviimise perioodi esimene kuupaev ning neljas - antud tootaja poolt antud treeningu labiviimise perioodi viimane kuupaev.';


CREATE OR REPLACE FUNCTION f_labiviija_muutmine (Voimalik_labiviija.voimalik_labiviija_id%TYPE,
Tootaja.tootaja_id%TYPE, Voimalik_labiviija.alguse_aeg%TYPE, Voimalik_labiviija.lopu_aeg%TYPE)
RETURNS VOID AS $$
UPDATE Voimalik_labiviija SET tootaja_id = $2, alguse_aeg = $3, lopu_aeg = $4
WHERE voimalik_labiviija_id = $1;
$$ LANGUAGE sql SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_labiviija_muutmine (Voimalik_labiviija.voimalik_labiviija_id%TYPE,
Tootaja.tootaja_id%TYPE, Voimalik_labiviija.alguse_aeg%TYPE, Voimalik_labiviija.lopu_aeg%TYPE) IS 'Selle
funktsiooni abil muudetakse treeningu labiviijat konkreetsel perioodil. Funktsioon realiseerib andmebaasioperatsiooni
OP5.7. Esimene argument: tabeli Voimalik_labiviija rea identifikaator tabelis, kus asuvad muudetavad andmed, teine argument - tootaja id, kes on uueks treeningu labiviijaks, kolmas argument - treeningu labiviimise perioodi esimene kuupaev, neljas argument - treeningu labiviimise perioodi viimane kuupaev.';


CREATE OR REPLACE FUNCTION f_sisselogimine_juhataja(text, text)
RETURNS boolean AS $$
DECLARE
rslt boolean;
BEGIN
select INTO rslt (parool = public.crypt($2, parool)) from isik inner join tootaja ON isik.isikukood = tootaja.isikukood where tootaja.amet_kood='JUHAT' and NOT tootaja_seisundi_liik_kood='LOPET';
RETURN coalesce(rslt, FALSE);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE
SET search_path = public, pg_temp;

COMMENT ON FUNCTION
f_sisselogimine_juhataja(text, text)
IS 'Selle funktsiooni abil autenditakse juhatajat. Funktsiooni valjakutsel on esimene argument kasutajanimi ja teine argument parool.
Juhatajal on oigus susteemi siseneda, vaid siis kui tema seisundiks pole "LOPET"';


/*Triggerite funktsioonide laused*/
CREATE OR REPLACE FUNCTION f_trigger_treeningu_kustutamine() RETURNS trigger AS $$
BEGIN
RAISE EXCEPTION 'Uhtegi juba registreeritud treeningut ei tohi andmebaasist ara kustutada.'; 
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION f_trigger_treeningu_kustutamine() IS 'See trigeri funktsioon aitab joustada arireegli: uhtegi juba registreeritud treeningut ei tohi andmebaasist ara kustutada.';


CREATE OR REPLACE FUNCTION f_trigger_treeningu_muutmine_treeningu_seisund() RETURNS trigger AS $$
BEGIN
RAISE EXCEPTION 'Andmeid ei saa muuta treeningutel, mille seisund on "Loplikult peatatud"!';
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION f_trigger_treeningu_muutmine_treeningu_seisund() IS 'See trigeri funktsioon aitab joustada arireegli: Andmeid ei saa muuta treeningutel, mille seisund on "Loplikult peatatud"';


CREATE OR REPLACE FUNCTION f_trigger_uus_treening_tootaja_seisund() RETURNS trigger AS $$
DECLARE
	m_tootaja_ID SMALLINT;
BEGIN
    SELECT tootaja_id INTO m_tootaja_ID FROM Tootaja WHERE tootaja_seisundi_liik_kood <> 'AKTII' AND tootaja_id=new.tootaja_id FOR UPDATE;
IF (new.tootaja_id = m_tootaja_ID) THEN
RAISE EXCEPTION 'Uusi treeninguid saab registreerida ainult aktiivses seisundis tootaja!';
ELSE
RETURN NEW;
END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_trigger_uus_treening_tootaja_seisund() IS 'See trigeri funktsioon aitab joustada arireegli: uusi treeninguid saab registreerida ainult aktiivses seisundis tootaja!';

CREATE OR REPLACE FUNCTION f_trigger_uus_treening_amet() RETURNS trigger AS $$
DECLARE
	m_tootaja_ID SMALLINT;
BEGIN
    SELECT tootaja_id INTO m_tootaja_ID FROM Tootaja WHERE amet_kood <> 'ADMIN' AND tootaja_id=new.tootaja_id FOR UPDATE;
IF (new.tootaja_id = m_tootaja_ID) THEN
RAISE EXCEPTION 'Ainult administraator saab registreerida uusi treeninguid!';
ELSE
RETURN NEW;
END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_trigger_uus_treening_amet() IS 'See trigeri funktsioon aitab joustada arireegli: ainult administraator saab registreerida uusi treeninguid.';



/*Triggerite laused*/
CREATE TRIGGER trigger_treeningu_kustutamine BEFORE DELETE OR TRUNCATE ON
Treening FOR EACH STATEMENT EXECUTE PROCEDURE f_trigger_treeningu_kustutamine();

CREATE TRIGGER trigger_treeningu_muutmine_treeningu_seisund BEFORE UPDATE ON
Treening FOR EACH ROW WHEN (OLD.treeningu_seisundi_liik_kood = 'LOPLI') EXECUTE PROCEDURE
f_trigger_treeningu_muutmine_treeningu_seisund();

CREATE TRIGGER trigger_uus_treening_tootaja_seisund BEFORE INSERT ON
Treening FOR EACH ROW EXECUTE PROCEDURE
f_trigger_uus_treening_tootaja_seisund();

CREATE TRIGGER trigger_uus_treening_amet BEFORE INSERT ON
Treening FOR EACH ROW EXECUTE PROCEDURE
f_trigger_uus_treening_amet();


/*Drop trigger funktsioonide laused*/
DROP FUNCTION IF EXISTS f_trigger_treeningu_kustutamine() CASCADE;

DROP FUNCTION IF EXISTS f_trigger_treeningu_muutmine_treeningu_seisund() CASCADE;

DROP FUNCTION IF EXISTS f_trigger_uus_treening_tootaja_seisund() CASCADE;

DROP FUNCTION IF EXISTS f_trigger_uus_treening_amet() CASCADE;



/*Drop trigger laused*/

DROP TRIGGER IF EXISTS trigger_treeningu_kustutamine ON Treening CASCADE;

DROP TRIGGER IF EXISTS trigger_treeningu_muutmine_treeningu_seisund ON Treening CASCADE;

DROP TRIGGER IF EXISTS trigger_uus_treening_tootaja_seisund ON Treening CASCADE;

DROP TRIGGER IF EXISTS trigger_uus_treening_amet ON Treening CASCADE;


/*Drop table laused*/

ALTER TABLE  IF EXISTS Tootaja DROP CONSTRAINT  IF EXISTS FK_Amet_amet_kood;
ALTER TABLE  IF EXISTS Tootaja DROP CONSTRAINT  IF EXISTS FK_Isik_isikukood;
ALTER TABLE  IF EXISTS Tootaja DROP CONSTRAINT  IF EXISTS FK_Tootaja_seisundi_liik_kood;


ALTER TABLE  IF EXISTS Voimalik_labiviija DROP CONSTRAINT  IF EXISTS FK_Tootaja_tootaja_id;
ALTER TABLE  IF EXISTS Voimalik_labiviija DROP CONSTRAINT  IF EXISTS FK_Treening_treening_id;

ALTER TABLE  IF EXISTS Treening DROP CONSTRAINT  IF EXISTS FK_Treeningu_seisundi_liik_treeningu_seisundi_liik_kood;
ALTER TABLE  IF EXISTS Treening DROP CONSTRAINT  IF EXISTS FK_Spordiala_spordiala_kood;
ALTER TABLE  IF EXISTS Treening DROP CONSTRAINT  IF EXISTS FK_Tootaja_tootaja_kood;

ALTER TABLE  IF EXISTS Klient DROP CONSTRAINT  IF EXISTS FK_Klient_seisundi_liik_kliendi_seisundi_liik_kood;
ALTER TABLE  IF EXISTS Klient DROP CONSTRAINT  IF EXISTS FK_Isik_isikukood;
DROP TABLE IF EXISTS Tootaja CASCADE;
DROP TABLE IF EXISTS Voimalik_labiviija CASCADE;
DROP TABLE IF EXISTS Treening CASCADE;
DROP TABLE IF EXISTS Amet CASCADE;
DROP TABLE IF EXISTS Tootaja_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Isik CASCADE;
DROP TABLE IF EXISTS Treeningu_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Spordiala CASCADE;
DROP TABLE IF EXISTS Klient_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Klient CASCADE;


/*Drop domain laused*/
DROP DOMAIN IF EXISTS d_nimetus CASCADE;
DROP DOMAIN IF EXISTS d_kirjeldus CASCADE;

/*Drop view laused*/
DROP VIEW IF EXISTS koik_tootajad_seisundiga CASCADE;
DROP VIEW IF EXISTS treeningute_labiviijad CASCADE;
DROP VIEW IF EXISTS koik_kliendid_seisundiga CASCADE;
DROP VIEW IF EXISTS koik_treeningud CASCADE;

/*Drop funktsion laused*/
DROP FUNCTION IF EXISTS f_treeningu_registreerimine
(Tootaja.tootaja_id%TYPE, Spordiala.spordiala_kood%TYPE, Treening.nimetus%TYPE, Treening.kirjeldus%TYPE) CASCADE;

DROP FUNCTION IF EXISTS f_treeningu_mitteaktiivseks_muutmine(Treening.treening_id%TYPE) CASCADE;

DROP FUNCTION IF EXISTS f_treeningu_aktiivseks_muutmine(Treening.treening_id%TYPE) CASCADE;

DROP FUNCTION IF EXISTS f_treeningu_kustutamine (Treening.treening_id%TYPE) CASCADE;

DROP FUNCTION IF EXISTS f_uue_labiviija_lisamine (Treening.treening_id%TYPE,
Tootaja.tootaja_id%TYPE, Voimalik_labiviija.alguse_aeg%TYPE, Voimalik_labiviija.lopu_aeg%TYPE) CASCADE;

DROP FUNCTION IF EXISTS f_labiviija_muutmine (Voimalik_labiviija.voimalik_labiviija_id%TYPE,
Tootaja.tootaja_id%TYPE, Voimalik_labiviija.alguse_aeg%TYPE, Voimalik_labiviija.lopu_aeg%TYPE) CASCADE;

DROP FUNCTION IF EXISTS f_sisselogimine_juhataja(text,text) CASCADE;

/*Drop index laused*/
DROP INDEX IF EXISTS idx_tootaja_tootaja_seisundi_liik_kood;
DROP INDEX IF EXISTS idx_tootaja_amet_kood;
DROP INDEX IF EXISTS idx_treening_tootaja_id;
DROP INDEX IF EXISTS idx_treening_treeningu_seisundi_liik_kood;
DROP INDEX IF EXISTS idx_treening_spordiala_kood;
DROP INDEX IF EXISTS idx_klient_kliendi_seisundi_liik_kood;
DROP INDEX IF EXISTS idx_voimalik_labiviija_tootaja_id;
DROP INDEX IF EXISTS idx_voimalik_labiviija_treening_id;
DROP INDEX IF EXISTS idx_isik_perenimi;
DROP INDEX IF EXISTS idx_isik_eesnimi;





/*Select from view laused*/
SELECT treeningu_nimetus, alguse_aeg, lopu_aeg, labiviija_eesnimi, labiviija_perenimi, labiviija_isikukood FROM treeningute_labiviijad;
SELECT tootaja_isikukood, tootaja_eesnimi, tootaja_perenimi, tootaja_epost, nimetus,seisund FROM koik_tootajad_seisundiga;

/*funktsioonide kaivitamise laused*/
SELECT f_sisselogimine_juhataja ('juhataja1','parool1'); --TRUE
SELECT f_sisselogimine_juhataja ('Maasikas8','Maasu156'); --FALSE

SELECT f_treeningu_registreerimine
(3::smallint,'BODYP', 'hea treening BP', 'vaga hea treening');
SELECT f_treeningu_registreerimine
(3::smallint,'EJOOG', 'suurepärane treening EJ', 'noh lihtsalt vaga hea treening');

SELECT f_treeningu_mitteaktiivseks_muutmine(1::smallint)
SELECT f_treeningu_mitteaktiivseks_muutmine(6::smallint)

SELECT f_treeningu_aktiivseks_muutmine(1::smallint)
SELECT f_treeningu_aktiivseks_muutmine(6::smallint)

SELECT f_treeningu_kustutamine (1::smallint);
SELECT f_treeningu_kustutamine(6::smallint);

SELECT f_uue_labiviija_lisamine (5::smallint, 1::smallint, '2017-01-01', '2017-12-31');
SELECT f_uue_labiviija_lisamine (7::smallint, 2::smallint, '2017-01-01', '2017-12-31');

SELECT f_labiviija_muutmine (2, 1::smallint, '2016-01-01','2016-12-31');
SELECT f_labiviija_muutmine (7, 2::smallint, '2016-01-01','2016-12-31');

CREATE USER juhataja_t142463 WITH PASSWORD 'parool1';