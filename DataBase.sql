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
    optionals set ("Aria condizionata", "Vetri oscurati","Tettuccioio panoramico") null,
    CONSTRAINT posti
    CHECK (categoria = "Motociclo" and postiOmologati <=2 and optionals is null),
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
    idMetodo int (2) unsigned zerofill not null AUTO_INCREMENT primary key,
    nomeTitolare varchar(15) not null,
    cognomeTitolare varchar(15) not null,
    tipologia enum ("Bonifico","Carta di Credito", "Paypal") not null,
    numeroCarta int(16) unsigned null unique,
    scadenzaCarta date null,
    numeroConto int (12) null,
    email varchar(254) null,

    CONSTRAINT Bonifico
    CHECK(tipologia = "Bonifico" and numeroCarta is not null and scadenzaCarta is not null and numeroConto is null and email is null ),

    CONSTRAINT Carta
    CHECK(tipologia = "Carta di Credito" and numeroCarta is null and scadenzaCarta is null and numeroConto is not null and email is null ),

    CONSTRAINT Paypal
    CHECK(tipologia = "Paypal" and numeroCarta is null and scadenzaCarta is null and numeroConto is  null and email is not null )
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