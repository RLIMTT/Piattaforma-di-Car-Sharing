
# Piattaforma di Car Sharing

## Introduzone al progetto

Si vuole creare un software per la gestione di un servizio di Car Sharing. Si deve realizzare uno schema ER dell’applicazione con il relativo schema logico con annessa spiegazione delle scelte progettuali. Una volta che la progettazione è completata è richiesta la creazione di uno Script SQL in cui si includono le seguenti parti:

* Creazione del DataBase
* Creazione di tutte le tabelle con relativi vincoli
* Popolazione del DataBase con dati di esempio (almeno 5 record per tabella)

Inoltre è anche richiesto di creare un dizionario dei dati al fine di descrivere le tabelle e i campi.
Infine sono richieste delle considerazioni finali sul progetto.

## Progettazione

### Analisi dei requisiti

La piattaforma deve gestire tutto il processo di un noleggio, che è costituito dai seguenti passaggi:

* Memorizzare i dati degli utenti e delle loro patenti.
* Registrare i dati dei veicoli.
* Registrare i luoghi in cui è possibile ritirare o restituire i veicoli, che possono essere stazioni o parcheggi.
* Si devono registrare le prenotazioni con data e ora di inizio del noleggio e datata e ora della riconsegna del veicolo.
* Si deve tenere traccia delle manutenzioni che vengono eseguite su un veicolo.
* In un noleggio possono essere effettuati dei danni sul veicolo o possono essere prese delle multe.
* Si deve anche gestire il sistema tariffario dei noleggi
* Inoltre si devono poter scrivere delle recensioni in merito ad un noleggio.
* Infine vanno inseriti dei vincoli: Un veicolo può essere noleggiato da un solo utente alla volta, calcolo automatico tariffe, stato veicolo (disponibile, in uso, in manutenzione).

### Diagramma Entità-Relazione (ER)

```mermaid
    erDiagram
    OFFICINA ||--o{ MANUTENZIONE : "Eseguita da"
    MANUTENZIONE o{ -- || VEICOLO : "Viene eseguita"
    VEICOLO || -- o| PRENOTAZIONE :"è asseganto"
    PRENOTAZIONE ||--O| PAGAMENTO:"Viene effettuato"
    PAGAMENTO O{ -- ||mETODOdIpAGAMENTO:Accetta
    PRENOTAZIONE ||--||NOLEGGIO: Crea
    NOLEGGIO || -- O| RECENZIONE:"Viene scritta"
    UTENTE ||--O{ PRENOTAZIONE : Effettua
    PATENTE || -- || UTENTE:Possiede
    STAZIONE || --O{ PRENOTAZIONE :Presso
    NOLEGGIO O{ --|| PAGAMENTO :"Extra saldati con"
    OFFICINA {
        string ragioneSociale pk
        string Indirizzo_Comune
        string Indirizzo_Via
        string Indirizzo_Civico
        int  Indirizzo_Cap
        int partitaIva
        int telefono
        string email
        set tipologia
    }
    VEICOLO {
        string targa pk
        string marca
        string modello
        string posizioneGPS
        enum categoria
        int cc
        int cv
        int posti
        set optionals
    }
    MANUTENZIONE {
        string idManutenzione pk
        string fkVeicolo fk
        string fkOfficina fk
        date data
        string descrizione
    }
    mETODOdIpAGAMENTO {
        int idMetodo pk
        string nomeTitolare
        string cognomeTitolare
        enum tipologia
        int numeroCarta*
        date scadenzaCarta*
        string codiceConto*
        string ibanDestinatario
    }
    STAZIONE{
        string idStazione pk
        string Indirizzo_Comune
        string Indirizzo_Via
        string Indirizzo_Civico
        int  Indirizzo_Cap
        bool coperto
    }
    UTENTE{
        string codiceFiscale pk
        sttring nome
        string cognome
        date dataDiNascita
        string statoNascita
        string comuneNascita
    }
    PAGAMENTO{
        int idPagamento pk
        string fkUtente fk
        int fkMetodoDiPagamento fk
        float importo
        date dataPagamento
        time oraPagamento
        string causale
    }
    PATENTE{
        string numeroPatente pk
        string enteRilasciatore
        date dataRilascio
        date dataScadenza
        set tipologia
    }
    NOLEGGIO{
       string fkPrenotazione PK, FK
       date dataRestituzione pk 
       int kmPercorsi
       float prezzoAlChilometro
       set extra
       float importo*
       string descrizione*
       int tempoExtra*
       int puntiPatenteTolti*
    }
    RECENZIONE{
        string idRecensione pk 
        string fkNoleggio pk
        date dataPubblicazione
        int punteggio
        string descrizione
    }
    PRENOTAZIONE{
        string idPrenotazione pk 
        string fkVeicolo fk
        string fkUtente fk
        string fkMetodoDiPagamento fk
        string fkStazione fk
        date dataPrenotazione
        date dataInizioNoleggio
        time oraInizioNoleggio
        date dataFineNoleggio
        time oraFineNoleggio
    }

```

### Schema logico

Veicolo(<u>Targa</u>, marca, modello, posizioneGPS, categoria, cc, cv, posti,optionals*)<br>

Manutenzione(<u>idManutenzione</u>, fkVeicolo, fkOfficina kmVeicolo, data, descrizione,)<br>

Officina(<u>ragioneSociale</u>, indirizzo_Comune, indirizzo_Via, indirizzo_Civico, indirizzo_Cap,partitaIva, Telefono, email, tipologia)<br>

metodoDiPagamento(<u>idMetodo</u>, nomeTitolare, cognomeTitolare, Tipogia, numeroCarta*, scadenzaCarta*,numeroConto*,ibanDestinatario)<br>

Stazione(<u>idStazione</u>, indirizzo_Comune, indirizzo_Via, indirizzo_Civico, indirizzo_Cap, coperto )<br>

Utente(<u>codiceFiscale</u>, nome, cognome, dataDiNascita, luogoDiNacita)<br>

Pagamento(<u>idPagamento</u>, fkUtente, fkMetodoDiPagamento, importo, causale*,dataPagamento, oraPagamento)<br>

Patente(<u>numeroPatente</u>, enteRilasciatore, dataRilascio, dataScadenza, tipologia )<br>

Noleggio(<u>fkPrenotazione</u>,<u>dataRestituzione</u>, kmPercorsi, prezzoAlChilometro, extra)<br>

Recensione(<u>idRecensione</u>, <u>fkNoleggio</u>, dataPubblicazione, punteggio, descrizione)<br>

Prenotazione(<u>idPrenotazione</u>, fkVeicolo, fkUtente, fkMetodoDIPagamento, fkStazione,dataPrenotazione, dataInizioNoleggio, oraInizioNoleggio, dataFineNoleggio, oraFineNoleggio)<br>

### Dizionario dei dati
