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
    cc int(4) unsigned zerofill not null, 
    cv int (4) unsigned zerofill not null,
    postiOmologati int (1)  unsigned not null,
    optionals set ("Aria condizionata", "Vetri oscurati","Tettuccioio panoramico","Autoradio","Bluetooth", "navigatore","Cruise control", "Telecamera posteriore") null,
    
    CONSTRAINT posti
    CHECK((categoria = "Motociclo" and postiOmologati <=2 and optionals is null)
    or (categoria = "Autovettura" and optionals is not null)),
    
    CONSTRAINT postimaggiori
    CHECK (cc>0 and cv>0 and postiOmologati>0)
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
    codiceFiscale varchar(16) not null primary key,
    nome varchar(15) not null,
    cognome varchar(15) not null,
    dataDiNascita date not null,
    comuneDiNascita varchar(34) not null
);

CREATE TABLE pagamento(
    idPagamento int(9) unsigned zerofill not null AUTO_INCREMENT primary key,
    codiceFiscale varchar(16) not null,
    idMetodo int (2) unsigned zerofill not null,
    importo float (8,2) unsigned not null,
    causale varchar (255) null,
    dataPagamento date not null,
    oraPagamento time not null,
    index (codiceFiscale),
    index (idMetodo),

    CONSTRAINT fkUtente
    FOREIGN KEY (codiceFiscale) REFERENCES utente(codiceFiscale)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,

    CONSTRAINT fkMedodo
    FOREIGN KEY (idMetodo) REFERENCES metodoDiPagamento(idMetodo)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE patente(
    numeroPatente varchar(10) not null primary key,
    codiceFiscale varchar(16) not null,
    enteRilasciatore varchar(5) not null,
    dataRilacio date not null,
    dataScadenza date not null,
    tipologia set("AM","A1","A2","A","B1","B","C1","C","D1","D","BE","C1E","CE","D1E","DE") not null,
    index (codiceFiscale),

    CONSTRAINT fkUtentePatente
    FOREIGN KEY (codiceFiscale) REFERENCES utente(codiceFiscale)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE prenotazione(
    idPrenotazione varchar (7) not null primary key,
    targa varchar (7) not null,
    codiceFiscale varchar(16) not null,
    idMetodo int (2) unsigned zerofill not null,
    idStazione varchar(5) not null,
    dataPrenotazione date not null,
    dataInizioNoleggio date not null,
    oraInizioNoleggio time not null,
    dataPrevistaFineNoleggio date not null,
    oraPrevistaFineNoleggio time not null,
    MaxkmPrevisti int(6) unsigned zerofill not null,
    index(targa),
    index( codiceFiscale),
    index( idMetodo),
    index(idStazione),

    CONSTRAINT fkVeicoloPrenotazione
    FOREIGN KEY (targa) REFERENCES veicolo(targa)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,

    CONSTRAINT codiceFiscalePrenotazione
    FOREIGN KEY (codiceFiscale) REFERENCES utente(codiceFiscale)
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
        OR
        (extra="Sforamento data" AND tempoExtra IS NOT NULL)
        OR
        (extra="Multa" AND puntiPatenteTolti IS NOT NULL)
    )

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

INSERT INTO veicolo
(targa, marca, modello, posizioneGPSLat, posizioneGPSLon, prezzoAlGiorno, categoria, cc, cv, postiOmologati, optionals)
VALUES
('AA111AA','Fiat','Panda',45.4642,9.1900,35.00,'Autovettura',0999,0069,5,'Aria condizionata,Bluetooth'),
('BB222BB','Volkswagen','Golf',45.0703,7.6869,55.00,'Autovettura',1600,0110,5,'Navigatore,Cruise control'),
('CC333CC','Toyota','Yaris',43.7696,11.2558,45.00,'Autovettura',1000,0072,5,'Autoradio'),
('DD444DD','Yamaha','MT07',44.4949,11.3426,30.00,'Motociclo',0689,0074,2,NULL),
('EE555EE','Honda','SH150',41.9028,12.4964,25.00,'Motociclo',0153,0016,2,NULL);

INSERT INTO officina
(ragioneSociale, indirizzo_comune, indirizzo_cap, indirizzo_via, indirizzo_civico, partitaIva, telefono, email, tipologia)
VALUES
('AutoFix SRL','Milano',20100,'Via Roma','10',01234567890,000000000001,'info@autofix.it','Officina'),
('Car Service','Torino',10100,'Via Po','22',02345678901,000000000002,'info@carservice.it','Carrozzeria'),
('MotoLab','Bologna',40100,'Via Emilia','88',03456789012,000000000003,'info@motolab.it','Officina'),
('Speed Repair','Roma',00100,'Via Appia','55',04567890123,000000000004,'speed@repair.it','Elettrauto'),
('Garage Nord','Verona',37100,'Via Venezia','5',05678901234,000000000005,'info@garagenord.it','Officina,Elettrauto');

INSERT INTO manutenzione
(targa, ragioneSociale, kmVeicolo, dataEsecuzione, descrizione)
VALUES
('AA111AA','AutoFix SRL',35000,'2024-01-10','Tagliando completo'),
('BB222BB','Car Service',60000,'2024-02-15','Sostituzione frizione'),
('CC333CC','Speed Repair',42000,'2024-03-20','Cambio olio'),
('DD444DD','MotoLab',15000,'2024-04-10','Controllo freni'),
('EE555EE','Garage Nord',9000,'2024-05-05','Revisione elettrica');

INSERT INTO metodoDiPagamento (nomeTitolare, cognomeTitolare, tipologia, numeroCarta, scadenzaCarta, numeroConto, email)
VALUES
('Mario', 'Rossi', 'Carta di Credito', 1234567812345678, '2024-04-10', NULL, NULL),
('Lucia', 'Bianchi', 'Bonifico', NULL, NULL, 3456789012, NULL),
('Giovanni', 'Verdi', 'Paypal', NULL, NULL, NULL, 'giovanni.verdi@email.com'),
('Sara', 'Neri', 'Carta di Credito', 8765432187654321, '2024-04-10', NULL, NULL),
('Paolo', 'Gialli', 'Bonifico', NULL, NULL, 7654321098, NULL);

INSERT INTO stazione
(idStazione, indirizzo_comune, indirizzo_cap, indirizzo_via, indirizzo_civico, coperto)
VALUES
('MI001','Milano',20100,'Via Dante','3',TRUE),
('TO001','Torino',10100,'Via Po','15',FALSE),
('BO001','Bologna',40100,'Via Indipendenza','40',TRUE),
('RM001','Roma',00100,'Via Nazionale','20',FALSE),
('VR001','Verona',37100,'Corso Porta Nuova','8',TRUE);

INSERT INTO utente
(codiceFiscale, nome, cognome, dataDiNascita, comuneDiNascita)
VALUES
('RSSMRA90A01F205X','Mario','Rossi','1990-01-01','Milano'),
('VRDLGU85C12L219Y','Luigi','Verdi','1985-03-12','Torino'),
('BNCHAN92D45H501Z','Anna','Bianchi','1992-04-05','Roma'),
('NRIPAO88E22F839K','Paolo','Neri','1988-05-22','Napoli'),
('CNTGLI95F10L736J','Giulia','Conti','1995-06-10','Verona');

INSERT INTO pagamento
(codiceFiscale, idMetodo, importo, causale, dataPagamento, oraPagamento)
VALUES
('RSSMRA90A01F205X',000001,120.00,'Noleggio Panda','2024-06-01','10:30'),
('VRDLGU85C12L219Y',000002,200.00,'Noleggio Golf','2024-06-03','12:00'),
('BNCHAN92D45H501Z',000003,90.00,'Noleggio Yaris','2024-06-05','09:45'),
('NRIPAO88E22F839K',000004,70.00,'Noleggio MT07','2024-06-07','15:20'),
('CNTGLI95F10L736J',000005,60.00,'Noleggio SH150','2024-06-09','11:10');

INSERT INTO patente
(numeroPatente, codiceFiscale, enteRilasciatore, dataRilacio, dataScadenza, tipologia)
VALUES
('PAT0000001','RSSMRA90A01F205X','MIT','2010-06-01','2030-06-01','B'),
('PAT0000002','VRDLGU85C12L219Y','MIT','2005-05-10','2025-05-10','B'),
('PAT0000003','BNCHAN92D45H501Z','MIT','2012-07-20','2032-07-20','A,B'),
('PAT0000004','NRIPAO88E22F839K','MIT','2008-03-15','2028-03-15','B'),
('PAT0000005','CNTGLI95F10L736J','MIT','2014-09-01','2034-09-01','A1,B');

INSERT INTO prenotazione
(idPrenotazione, targa, codiceFiscale, idMetodo, idStazione, dataPrenotazione, dataInizioNoleggio, oraInizioNoleggio, dataPrevistaFineNoleggio, oraPrevistaFineNoleggio, MaxkmPrevisti)
VALUES
('PR001AA','AA111AA','RSSMRA90A01F205X',000001,'MI001','2024-05-20','2024-06-01','09:00','2024-06-03','09:00',0300),
('PR002BB','BB222BB','VRDLGU85C12L219Y',000002,'TO001','2024-05-22','2024-06-03','10:00','2024-06-06','10:00',0500),
('PR003CC','CC333CC','BNCHAN92D45H501Z',000003,'BO001','2024-05-25','2024-06-05','08:00','2024-06-07','08:00',0400),
('PR004DD','DD444DD','NRIPAO88E22F839K',000004,'RM001','2024-05-28','2024-06-07','14:00','2024-06-08','14:00',0200),
('PR005EE','EE555EE','CNTGLI95F10L736J',000005,'VR001','2024-05-30','2024-06-09','10:00','2024-06-10','10:00',0150);

INSERT INTO noleggio
(idPrenotazione, dataRestituzioneEffettiva, kmPercorsi, extra, importoExtra, tempoExtra, puntiPatenteTolti)
VALUES
('PR001AA','2024-06-03',0320,'Sforamento data',25.000,02,NULL),
('PR002BB','2024-06-06',0480,NULL,NULL,NULL,NULL),
('PR003CC','2024-06-07',0390,NULL,NULL,NULL,NULL),
('PR004DD','2024-06-08',0210,'Multa',50.000,NULL,02),
('PR005EE','2024-06-10',0140,NULL,NULL,NULL,NULL);

INSERT INTO recensione
(idPrenotazione, dataRestituzioneEffettiva, dataPubblicazione, punteggio, descrizione)
VALUES
('PR001AA','2024-06-03','2024-06-04',7,'Auto comoda ma restituita in ritardo'),
('PR002BB','2024-06-06','2024-06-07',9,'Servizio eccellente'),
('PR003CC','2024-06-07','2024-06-08',8,'Veicolo pulito'),
('PR004DD','2024-06-08','2024-06-09',6,'Buona moto ma multa'),
('PR005EE','2024-06-10','2024-06-11',9,'Esperienza perfetta');