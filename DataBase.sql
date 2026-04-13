DROP DATABASE IF EXISTS `Rial_carSharing`;

CREATE DATABASE `Rial_carSharing`;

USE `Rial_carSharing`;

CREATE TABLE veicolo(
    targa varchar(7) not null primary key,
    marca varchar (20) not null,
    modello varchar (20) not null,
    posizioneGPSLat float(6,4) not null,
    posizioneGPSLon float(6,4) not null,
    prezzoAlGiorno float(6,2) not null,
    categoria enum("Autovettura","Motociclo") default "Autovettura",
    cc int(4) unsigned not null,
    cv int (4) unsigned not null,
    postiOmologati int (1)  unsigned not NULL,

   CONSTRAINT posti
CHECK((categoria = "Motociclo" AND postiOmologati <= 2)OR(categoria = "Autovettura" AND postiOmologati <= 9)),
    
    CONSTRAINT postimaggiori
    CHECK (cc>0 and cv>0 and postiOmologati>0)
);

CREATE TABLE `optional`(
    nomeOptional varchar(255) not null primary key
);

CREATE TABLE officina(
    ragioneSociale varchar(255) not null primary key,
    indirizzo_comune varchar (34) not null,
    indirizzo_cap int(5) unsigned not null,
    indirizzo_via varchar(30) not null,
    indirizzo_civico varchar (7) not null,
    partitaIva int (11) unsigned zerofill not null,
    telefono int (15) unsigned zerofill not null,
    email varchar (30) not null,
    tipologia set ("Carrozzeria", "Officina", "Elettrauto")
);

CREATE TABLE manutenzione(
    idManutenzione int(6) unsigned zerofill not null AUTO_INCREMENT primary key,
    targa varchar(7) not null,
    ragioneSociale varchar(255) not null,
    kmVeicolo int (6) unsigned not null,
    dataEsecuzione date not null,
    descrizione varchar (255) not null,
    INDEX (targa),
    INDEX (ragioneSociale),

    CONSTRAINT fkVeicolo
    FOREIGN KEY (targa) REFERENCES veicolo(targa)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT fkOfficina
    FOREIGN KEY (ragioneSociale) REFERENCES officina(ragioneSociale)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE metodoDiPagamento(
    idMetodo int (6) unsigned zerofill not null AUTO_INCREMENT primary key,
    nomeTitolare varchar(15) not null,
    cognomeTitolare varchar(15) not null,
    tipologia enum ("Bonifico","Carta di Credito", "Paypal") not null,
    numeroCarta bigint(16) unsigned null unique,
    scadenzaCarta date null,
    numeroConto int (12) null,
    email varchar(254) null,

    CHECK (
        (tipologia="Bonifico" AND numeroCarta IS NULL AND scadenzaCarta IS NULL AND numeroConto IS NOT NULL AND email IS NULL)
        OR
        (tipologia="Carta di Credito" AND numeroCarta IS NOT NULL AND scadenzaCarta IS NOT NULL AND numeroConto IS NULL AND email IS NULL)
        OR
        (tipologia="Paypal" AND numeroCarta IS NULL AND scadenzaCarta IS NULL AND numeroConto IS NULL AND email IS NOT NULL)
    )
);

CREATE TABLE stazione(
    idStazione varchar(5) not null primary key,
    indirizzo_comune varchar (34) not null,
    indirizzo_cap int(5) unsigned not null,
    indirizzo_via varchar(30) not null,
    indirizzo_civico varchar (7) not null,
    coperto BOOLEAN not null
);
CREATE TABLE utente(
    username varchar(256) not null primary key, 
    codiceFiscale varchar(16) not null ,
    nome varchar(15) not null, 
    cognome varchar(15) not null, 
    dataDiNascita date not null, 
    comuneDiNascita varchar(34) not null, 
    email varchar(256) not null, 
    telefono varchar(20) not null, 
    pass varchar(256) null, 
    salt varchar(64) null,
    `admin` BOOLEAN not null default false
);

CREATE TABLE pagamento(
    idPagamento int(9) unsigned zerofill not null AUTO_INCREMENT primary key,
    username varchar(256) not null,
    idMetodo int (2) unsigned zerofill not null,
    importo float (8,2) unsigned not null,
    causale varchar (255) null,
    dataPagamento date not null,
    oraPagamento time not null,
    index (username),
    index (idMetodo),

    CONSTRAINT fkUtente
    FOREIGN KEY (username) REFERENCES utente(username)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,

    CONSTRAINT fkMedodo
    FOREIGN KEY (idMetodo) REFERENCES metodoDiPagamento(idMetodo)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE patente(
    numeroPatente varchar(10) not null primary key,
    username varchar(256) not null,
    enteRilasciatore varchar(5) not null,
    dataRilacio date not null,
    dataScadenza date not null,
    tipologia set("AM","A1","A2","A","B1","B","C1","C","D1","D","BE","C1E","CE","D1E","DE") not null,
    index( username),

    CONSTRAINT fkUtentePatente
    FOREIGN KEY (username) REFERENCES utente(username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE prenotazione(
    idPrenotazione varchar (7) not null primary key,
    targa varchar (7) not null,
    username varchar(256) not null,
    idMetodo int (2) unsigned zerofill not null,
    idStazione varchar(5) not null,
    dataPrenotazione date not null,
    dataInizioNoleggio date not null,
    oraInizioNoleggio time not null,
    dataPrevistaFineNoleggio date not null,
    oraPrevistaFineNoleggio time not null,
    MaxkmPrevisti int(6) unsigned zerofill not null,
    index(targa),
    index(username),
    index(idMetodo),
    index(idStazione),

    CONSTRAINT fkVeicoloPrenotazione
    FOREIGN KEY (targa) REFERENCES veicolo(targa)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,

    CONSTRAINT usernamePrenotazione
    FOREIGN KEY (username) REFERENCES utente(username)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT idMetodoPrenotazione
    FOREIGN KEY (idMetodo) REFERENCES metodoDiPagamento(idMetodo)
    ON DELETE CASCADE
    ON UPDATE CASCADE, 

    CONSTRAINT idStazionePrenotazione
    FOREIGN KEY (idStazione) REFERENCES stazione(idStazione)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE noleggio(
    idPrenotazione varchar (7) not null,
    dataRestituzioneEffettiva date not null,
    kmPercorsi int(5) unsigned zerofill not null,
    extra set ("Multa","Danni","Sforamento data","Sforamento chilometri") null,
    importoExtra float (5,3) null,
    tempoExtra int(2) unsigned zerofill null,
    puntiPatenteTolti int(2) unsigned zerofill null,
    PRIMARY KEY(idPrenotazione, dataRestituzioneEffettiva),
    index (idPrenotazione),

    CONSTRAINT fkPrenotazione
    FOREIGN KEY (idPrenotazione) REFERENCES prenotazione(idPrenotazione)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,

    CHECK (
    (extra IS NULL AND importoExtra IS NULL AND tempoExtra IS NULL AND puntiPatenteTolti IS NULL)

    OR (extra = "Sforamento data" AND tempoExtra IS NOT NULL AND importoExtra IS NOT NULL)

    OR (extra = "Multa" AND puntiPatenteTolti IS NOT NULL AND importoExtra IS NOT NULL)

    OR (extra = "Danni" AND importoExtra IS NOT NULL)

    OR (extra = "Sforamento chilometri" AND importoExtra IS NOT NULL))

);

CREATE TABLE recensione(
    idRecensione int (6) unsigned zerofill not null AUTO_INCREMENT primary key,
    idPrenotazione varchar (7) not null,
    dataRestituzioneEffettiva date not null,
    dataPubblicazione date not null,
    punteggio int(1) not null,
    descrizione varchar(255) not null,
    index (idPrenotazione,dataRestituzioneEffettiva),

    CONSTRAINT fkPrenotazioneRecensione
    FOREIGN KEY (idPrenotazione,dataRestituzioneEffettiva) REFERENCES noleggio(idPrenotazione, dataRestituzioneEffettiva)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    /*Ho fatto una referenza doppia perchè all'interno dell'entità noleggio c'è una chiave primaria doppia e 
    facendo due constraint diversi mi dava errore*/
);


/* Popolazione database*/


INSERT INTO optional VALUES
('Aria condizionata'),
('Navigatore'),
('Bluetooth'),
('Cruise control'),
('Sensori parcheggio'),
('Telecamera posteriore'),
('Sedili riscaldati'),
('Tetto panoramico'),
('Cambio automatico'),
('Vetri oscurati'),
('ABS'),
('ESP'),
('Android Auto'),
('Apple CarPlay'),
('Park assist');


INSERT INTO veicolo VALUES
('AA100AA','Fiat','Panda',45.4642,9.1900,35.00,'Autovettura',1000,70,5),
('AA100AB','Volkswagen','Golf',45.4620,9.1950,55.00,'Autovettura',1600,110,5),
('AA100AC','Toyota','Yaris',45.4600,9.1800,40.00,'Autovettura',1200,90,5),
('AA100AD','Ford','Focus',45.4700,9.2000,50.00,'Autovettura',1500,120,5),
('AA100AE','Renault','Clio',45.4680,9.2100,38.00,'Autovettura',1000,75,5),
('AA100AF','BMW','Serie 1',45.4500,9.1700,75.00,'Autovettura',2000,150,5),
('AA100AG','Audi','A3',45.4550,9.1750,80.00,'Autovettura',2000,160,5),
('AA100AH','Mercedes','Classe A',45.4580,9.1650,85.00,'Autovettura',1800,140,5),
('AA100AI','Hyundai','i20',45.4590,9.1680,36.00,'Autovettura',1100,84,5),
('AA100AJ','Kia','Rio',45.4610,9.1690,37.00,'Autovettura',1100,80,5),
('BB100AA','Yamaha','MT-07',45.4400,9.1600,30.00,'Motociclo',689,74,2),
('BB100AB','Honda','CB500',45.4410,9.1610,28.00,'Motociclo',500,47,2),
('BB100AC','Kawasaki','Z650',45.4420,9.1620,32.00,'Motociclo',650,68,2),
('BB100AD','Ducati','Monster',45.4430,9.1630,60.00,'Motociclo',937,111,2),
('BB100AE','Suzuki','SV650',45.4440,9.1640,29.00,'Motociclo',645,76,2),
('BB100AF','Piaggio','Beverly',45.4450,9.1650,20.00,'Motociclo',300,25,2),
('BB100AG','Honda','SH125',45.4460,9.1660,18.00,'Motociclo',125,13,2),
('BB100AH','KTM','390 Duke',45.4470,9.1670,27.00,'Motociclo',373,44,2);


INSERT INTO stazione VALUES
('S001','Milano',20100,'Via Roma','1',1),
('S002','Milano',20121,'Via Torino','15',0),
('S003','Monza',20900,'Via Italia','10',1),
('S004','Bergamo',24100,'Via XX Settembre','20',0),
('S005','Brescia',25100,'Via Mazzini','8',1),
('S006','Como',22100,'Via Milano','3',0),
('S007','Varese',21100,'Via Verdi','12',1),
('S008','Pavia',27100,'Via Manzoni','9',0),
('S009','Lodi',26900,'Via Garibaldi','5',1),
('S010','Lecco',23900,'Via Cavour','13',1),
('S011','Sondrio',23100,'Via Stelvio','4',0),
('S012','Cremona',26100,'Via Po','17',1),
('S013','Mantova',46100,'Via Gonzaga','6',0),
('S014','Rho',20017,'Via Matteotti','14',1),
('S015','Legnano',20025,'Via Milano','19',0);

INSERT INTO utente 
(username, codiceFiscale, nome, cognome, dataDiNascita, comuneDiNascita, email, telefono, pass, salt)
VALUES
('mrossi','RSSMRA80A01F205X','Mario','Rossi','1980-01-01','Milano','mario.rossi@email.it','3331111111',NULL,NULL),
('lverdi','VRDLGI85B12F205Y','Luigi','Verdi','1985-02-12','Milano','luigi.verdi@email.it','3331111112',NULL,NULL),
('lbianchi','BNCLRA90C23F205Z','Laura','Bianchi','1990-03-23','Monza','laura.bianchi@email.it','3331111113',NULL,NULL),
('gneri','NRAGPP88D10F205K','Giuseppe','Neri','1988-04-10','Como','giuseppe.neri@email.it','3331111114',NULL,NULL),
('pferrari','FRNPLA92E15F205L','Paola','Ferrari','1992-05-15','Bergamo','paola.ferrari@email.it','3331111115',NULL,NULL),
('mgalli','GLLMRC87F20F205M','Marco','Galli','1987-06-20','Varese','marco.galli@email.it','3331111116',NULL,NULL),
('aconti','CNTNDR95G30F205N','Andrea','Conti','1995-07-30','Brescia','andrea.conti@email.it','3331111117',NULL,NULL),
('fricci','RCCFNC91H11F205P','Francesca','Ricci','1991-08-11','Pavia','francesca.ricci@email.it','3331111118',NULL,NULL),
('dmartini','MRTDNL89I09F205Q','Daniele','Martini','1989-09-09','Lodi','daniele.martini@email.it','3331111119',NULL,NULL),
('clombardi','LMBCRL93L18F205R','Carla','Lombardi','1993-10-18','Lecco','carla.lombardi@email.it','3331111120',NULL,NULL),
('lporta','PRTLCU86M22F205S','Luca','Porta','1986-08-22','Milano','luca.porta@email.it','3331111121',NULL,NULL),
('sbelli','BLSSMN94N13F205T','Simone','Belli','1994-07-13','Como','simone.belli@email.it','3331111122',NULL,NULL),
('vcaruso','CRSVLR88P30F205U','Valeria','Caruso','1988-09-30','Monza','valeria.caruso@email.it','3331111123',NULL,NULL),
('ftesta','TSTFBA91R15F205V','Fabio','Testa','1991-10-15','Brescia','fabio.testa@email.it','3331111124',NULL,NULL),
('gmarini','MRNGNN90S01F205W','Gianna','Marini','1990-11-01','Pavia','gianna.marini@email.it','3331111125',NULL,NULL);

INSERT INTO metodoDiPagamento (nomeTitolare,cognomeTitolare,tipologia,numeroCarta,scadenzaCarta,numeroConto,email) VALUES
('Mario','Rossi','Carta di Credito',1234567812345678,'2028-12-31',NULL,NULL),
('Luigi','Verdi','Bonifico',NULL,NULL,123456789012,NULL),
('Laura','Bianchi','Paypal',NULL,NULL,NULL,'laura@email.it'),
('Giuseppe','Neri','Carta di Credito',1111222233334444,'2027-06-30',NULL,NULL),
('Paola','Ferrari','Bonifico',NULL,NULL,987654321000,NULL),
('Marco','Galli','Paypal',NULL,NULL,NULL,'marco@email.it'),
('Andrea','Conti','Carta di Credito',2222333344445555,'2029-01-01',NULL,NULL),
('Francesca','Ricci','Bonifico',NULL,NULL,111111111111,NULL),
('Daniele','Martini','Paypal',NULL,NULL,NULL,'daniele@email.it'),
('Carla','Lombardi','Carta di Credito',3333444455556666,'2026-03-31',NULL,NULL),
('Luca','Porta','Bonifico',NULL,NULL,222222222222,NULL),
('Simone','Belli','Paypal',NULL,NULL,NULL,'simone@email.it'),
('Valeria','Caruso','Carta di Credito',4444555566667777,'2027-09-30',NULL,NULL),
('Fabio','Testa','Bonifico',NULL,NULL,333333333333,NULL),
('Gianna','Marini','Paypal',NULL,NULL,NULL,'gianna@email.it');


INSERT INTO prenotazione VALUES
('P000001','AA100AA','mrossi',1,'S001','2024-01-01','2024-01-10','09:00:00','2024-01-15','18:00:00',500),
('P000002','AA100AB','lverdi',2,'S002','2024-02-01','2024-02-10','08:00:00','2024-02-12','18:00:00',300),
('P000003','BB100AA','lbianchi',3,'S003','2024-03-01','2024-03-10','10:00:00','2024-03-12','17:00:00',200),
('P000004','AA100AC','gneri',4,'S004','2024-03-05','2024-03-15','09:00:00','2024-03-20','18:00:00',600),
('P000005','AA100AD','pferrari',5,'S005','2024-04-01','2024-04-10','09:00:00','2024-04-15','18:00:00',500),
('P000006','BB100AB','mgalli',6,'S006','2024-04-10','2024-04-20','09:00:00','2024-04-22','18:00:00',250),
('P000007','AA100AE','aconti',7,'S007','2024-05-01','2024-05-10','09:00:00','2024-05-12','18:00:00',450),
('P000008','AA100AF','fricci',8,'S008','2024-06-01','2024-06-10','09:00:00','2024-06-15','18:00:00',700),
('P000009','BB100AC','dmartini',9,'S009','2024-06-05','2024-06-15','09:00:00','2024-06-17','18:00:00',300),
('P000010','AA100AG','clombardi',10,'S010','2024-07-01','2024-07-10','09:00:00','2024-07-15','18:00:00',600),
('P000011','AA100AH','lporta',11,'S011','2026-04-10','2026-04-20','09:00:00','2026-04-25','18:00:00',500),
('P000012','AA100AI','sbelli',12,'S012','2026-05-05','2026-05-15','09:00:00','2026-05-20','18:00:00',500),
('P000013','AA100AJ','vcaruso',13,'S013','2026-06-01','2026-06-10','09:00:00','2026-06-18','18:00:00',500),
('P000014','BB100AD','ftesta',14,'S014','2026-07-01','2026-07-12','09:00:00','2026-07-18','18:00:00',300),
('P000015','BB100AE','gmarini',15,'S015','2026-08-01','2026-08-10','09:00:00','2026-08-20','18:00:00',300);


INSERT INTO noleggio VALUES
('P000001','2024-01-15',450,NULL,NULL,NULL,NULL),
('P000002','2024-02-12',280,'Sforamento data',20.00,2,NULL),
('P000003','2024-03-12',190,NULL,NULL,NULL,NULL),
('P000004','2024-03-20',610,'Sforamento chilometri',50.000,NULL,NULL),
('P000005','2024-04-15',480,NULL,NULL,NULL,NULL),
('P000006','2024-04-22',260,'Multa',80.00,NULL,5),
('P000007','2024-05-12',430,NULL,NULL,NULL,NULL),
('P000008','2024-06-15',690,NULL,NULL,NULL,NULL),
('P000009','2024-06-17',310,'Sforamento chilometri',30.000,NULL,NULL),
('P000010','2024-07-15',580,NULL,NULL,NULL,NULL);


INSERT INTO recensione (idPrenotazione,dataRestituzioneEffettiva,dataPubblicazione,punteggio,descrizione) VALUES
('P000001','2024-01-15','2024-01-16',5,'Ottimo servizio'),
('P000002','2024-02-12','2024-02-13',4,'Tutto bene'),
('P000003','2024-03-12','2024-03-13',5,'Moto perfetta'),
('P000004','2024-03-20','2024-03-21',3,'Auto buona'),
('P000005','2024-04-15','2024-04-16',5,'Consigliato'),
('P000006','2024-04-22','2024-04-23',4,'Servizio rapido'),
('P000007','2024-05-12','2024-05-13',5,'Ottima esperienza'),
('P000008','2024-06-15','2024-06-16',5,'Auto pulita'),
('P000009','2024-06-17','2024-06-18',4,'Buona moto'),
('P000010','2024-07-15','2024-07-16',5,'Perfetto');


INSERT INTO officina VALUES
('AutoService Milano','Milano',20100,'Via Roma','10',00000000001,000000000000001,'autoservice1@mail.it','Officina'),
('Carrozzeria Centrale','Milano',20121,'Via Torino','20',00000000002,000000000000002,'carrozzeria@mail.it','Carrozzeria'),
('Elettrauto Brianza','Monza',20900,'Via Italia','5',00000000003,000000000000003,'elettrauto@mail.it','Elettrauto'),
('Officina Bergamo','Bergamo',24100,'Via Verdi','8',00000000004,000000000000004,'offbg@mail.it','Officina'),
('Auto Como','Como',22100,'Via Milano','12',00000000005,000000000000005,'autocomo@mail.it','Officina'),
('Moto Service','Brescia',25100,'Via Dante','3',00000000006,000000000000006,'motoservice@mail.it','Officina'),
('Speed Car','Varese',21100,'Via Manzoni','14',00000000007,000000000000007,'speedcar@mail.it','Carrozzeria'),
('Top Repair','Pavia',27100,'Via Garibaldi','6',00000000008,000000000000008,'toprepair@mail.it','Officina'),
('Garage Lodi','Lodi',26900,'Via Cavour','9',00000000009,000000000000009,'garagelodi@mail.it','Officina'),
('Motor Point','Lecco',23900,'Via Mazzini','7',00000000010,000000000000010,'motorpoint@mail.it','Elettrauto'),
('Car Clinic','Sondrio',23100,'Via Stelvio','4',00000000011,000000000000011,'carclinic@mail.it','Officina'),
('Auto Cremona','Cremona',26100,'Via Po','11',00000000012,000000000000012,'autocr@mail.it','Carrozzeria'),
('Mantova Repair','Mantova',46100,'Via Gonzaga','2',00000000013,000000000000013,'mantovarep@mail.it','Officina'),
('Rho Motors','Rho',20017,'Via Matteotti','15',00000000014,000000000000014,'rhomotors@mail.it','Officina'),
('Legnano Car','Legnano',20025,'Via Milano','21',00000000015,000000000000015,'legnanocar@mail.it','Elettrauto');


INSERT INTO manutenzione (targa,ragioneSociale,kmVeicolo,dataEsecuzione,descrizione) VALUES
('AA100AA','AutoService Milano',15000,'2024-02-01','Tagliando completo'),
('AA100AB','Carrozzeria Centrale',30000,'2024-03-10','Riparazione paraurti'),
('AA100AC','Officina Bergamo',20000,'2024-04-15','Cambio olio'),
('AA100AD','Auto Como',25000,'2024-05-10','Sostituzione freni'),
('AA100AE','Speed Car',18000,'2024-06-01','Lucidatura carrozzeria'),
('AA100AF','Top Repair',40000,'2024-06-20','Revisione generale'),
('AA100AG','Garage Lodi',35000,'2024-07-10','Cambio batteria'),
('AA100AH','Motor Point',22000,'2024-08-05','Controllo elettronico'),
('AA100AI','Car Clinic',12000,'2024-09-01','Tagliando base'),
('AA100AJ','Auto Cremona',17000,'2024-09-15','Sostituzione pneumatici'),
('BB100AA','Moto Service',10000,'2024-03-12','Tagliando moto'),
('BB100AB','Moto Service',8000,'2024-04-22','Cambio olio moto'),
('BB100AC','Mantova Repair',9000,'2024-06-17','Sostituzione catena'),
('BB100AD','Rho Motors',15000,'2024-07-01','Revisione forcelle'),
('BB100AE','Legnano Car',11000,'2024-08-01','Controllo generale');


INSERT INTO patente VALUES
('PAT0000001','mrossi','MIT01','2010-01-01','2030-01-01','B'),
('PAT0000002','lverdi','MIT02','2012-02-01','2032-02-01','B'),
('PAT0000003','lbianchi','MIT03','2015-03-01','2035-03-01','B'),
('PAT0000004','gneri','MIT04','2008-04-01','2028-04-01','B'),
('PAT0000005','pferrari','MIT05','2014-05-01','2034-05-01','B'),
('PAT0000006','mgalli','MIT06','2007-06-01','2027-06-01','A,B'),
('PAT0000007','aconti','MIT07','2016-07-01','2036-07-01','B'),
('PAT0000008','fricci','MIT08','2013-08-01','2033-08-01','B'),
('PAT0000009','dmartini','MIT09','2011-09-01','2031-09-01','A,B'),
('PAT0000010','clombardi','MIT10','2014-10-01','2034-10-01','B'),
('PAT0000011','lporta','MIT11','2006-11-01','2026-11-01','B'),
('PAT0000012','sbelli','MIT12','2017-12-01','2037-12-01','B'),
('PAT0000013','vcaruso','MIT13','2009-01-01','2029-01-01','B'),
('PAT0000014','ftesta','MIT14','2012-02-02','2032-02-02','A,B'),
('PAT0000015','gmarini','MIT15','2010-03-03','2030-03-03','B');


INSERT INTO pagamento (username,idMetodo,importo,causale,dataPagamento,oraPagamento) VALUES
('mrossi',1,175.00,'Noleggio P000001','2024-01-10','08:30:00'),
('lverdi',2,110.00,'Noleggio P000002','2024-02-10','08:00:00'),
('lbianchi',3,90.00,'Noleggio P000003','2024-03-10','09:00:00'),
('gneri',4,250.00,'Noleggio P000004','2024-03-15','08:30:00'),
('pferrari',5,190.00,'Noleggio P000005','2024-04-10','08:30:00'),
('mgalli',6,84.00,'Noleggio P000006','2024-04-20','08:30:00'),
('aconti',7,190.00,'Noleggio P000007','2024-05-10','08:30:00'),
('fricci',8,375.00,'Noleggio P000008','2024-06-10','08:30:00'),
('dmartini',9,96.00,'Noleggio P000009','2024-06-15','08:30:00'),
('clombardi',10,350.00,'Noleggio P000010','2024-07-10','08:30:00'),
('lporta',11,200.00,'Prenotazione futura P000011','2026-04-10','08:30:00'),
('sbelli',12,180.00,'Prenotazione futura P000012','2026-05-05','08:30:00'),
('vcaruso',13,210.00,'Prenotazione futura P000013','2026-06-01','08:30:00'),
('ftesta',14,300.00,'Prenotazione futura P000014','2026-07-01','08:30:00'),
('gmarini',15,150.00,'Prenotazione futura P000015','2026-08-01','08:30:00');