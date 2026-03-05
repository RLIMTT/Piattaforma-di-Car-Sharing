<html>
  <head>
    <link rel ="stylesheet" href = "styles.css">
    <title>Inserisci libro</title>
    <style>
      table {
        border-collapse: collapse;
        margin: auto;
      }
      tr, th, td {
        border: 1px solid black;
        padding: 2px;
      }
      .rigaIntestazione{
        background-color: blue;
        color: white;
        font-size: 16px;
      }
      .rigaAlternata{
        background-color: lightblue;
      }
    </style>
  </head>
  <body>
    <h1>Inserisci libro</h1>
  <?php
      include("inc/datiConnessione.php");
     
      try {
        include("inc/startConn.php");
    ?>
   
    <form method="POST" action="#">
        <label for ='isbn'>Codice iSBN:</label>
        <input type="text" name="isbn" required/>
        <br/>
        <label for ='titolo'>Titolo libro:</label>
        <input type="text" name="titolo" required/>
        <br/>
        <label for ='anno'>Anno di pubblicazione:</label>
        <input type="number" name="anno" min="1900" max="2099" step="1" required/>
        <br/>
        <label for ='copie'>Numero copie disponibili:</label>
        <input type="number" name="copie" min="0" step="1" required/>
        <br/>
        <label for="genere">Genere: </label>
        <select name="genere">
            <!-- &lt; corrisponde a '<' mentre &gt; corrisponde a '>' -->
            <option value="all">&lt; Tutti &gt;</option>
            <?php
            $sqlGeneri = "SELECT DISTINCT IDGenere, Nomegenere  FROM genere";
            $resultsGeneri = $conn->query($sqlGeneri);
            $generi = $resultsGeneri->fetchAll(PDO::FETCH_ASSOC);
            foreach($generi as $g) {
                echo "<option value= '$g[IDGenere]'>$g[NomeGenere]</option>";
            }
            $orderBy = false;
            ?>
        </select>
        <label for ='telefono'>Numero di telefono:</label>
        <input type="tel" name="telefono"  pattern="+[0-9]{2} [0-9]{4}-[0-9]{3,4,5,6}"placeholder="+39" />
        <br/>
        <input type="submit" value="Invia"/>
    </form>
    <?php  
        // scrivo la query SQL in formato stringa
        $sql = "SELECT * FROM libro";
       
        // il metodo GET del form è quello che ci permette di
        // reperire le informazioni nell'array $_GET["informazione"];
        // cerco la variabile 'genere' perché il tag select aveva name='genere'
        if(isset($_GET["genere"]))
          // se è stato selezionato qualcosa di diverso da "< Tutti >" allora
          // inserirò la clausola WHERE nella query per il filtro
          if($_GET["genere"] != "all")
            $sql = $sql." WHERE genere='".$_GET["genere"]."'";
            // $sql .= " WHERE genere='$_GET[genere]'";
       
    if($orderBy)
      $sql .= " ORDER BY $_GET[ordinaPer]";
     
   
   
        //include("inc/stampaTabella.inc");
       
       
        // il metodo query() esegue il codice SQL, il metodo restituisce un DataSet
        $results = $conn->query($sql);
        // della classe DataSet esiste il metodo rowCount()
        echo "<h2>Sono presenti ".$results->rowCount()." libri</h2>";
        // stampo i tag per la Tabella
       
        //tag utili:
        //  table -> Tabella (che racchiude righe)
        //  tr    -> table row (riga che racchiude i dati)
        //  th    -> table header (intestazione)
        //  td    -> table data (dato normale)
       
        echo "<table>";
        echo "  <tr class='rigaIntestazione'>
                  <th>ISBN</th>
                  <th>Titolo</th>
                  <th>Anno Pubblicazione</th>
                  <th>Numero Copie</th>
                  <th>Genere</th>
                </tr>";
        // il metodo fetchAll() restituisce un array indicizzato di record. Ogni record è rappresentato da un array del tipo definito nel parametro (es: PDO::FETCH_ASSOC)
        // le chiavi dell'array associativo sono i nomi dei campi della tabella risultante dalla query
        $tab = $results->fetchAll(PDO::FETCH_ASSOC);
       
        // alternativa con il for classico
    //  for($i=0; $i<count($tab); $i++) {
    //    $riga = $tab[$i];
   
        $i = 0;
        // con un foreach scorro tutti i record della Tabella
        foreach($tab as $riga) {
          // stampo la riga con i dati
          echo "<tr ";
          // se è pari cambio lo sfondo in grigio chiaro
          if($i%2==0)
            echo "class='rigaAlternata'";
          // stampo i dati nella riga
          // all'ISBN metto un link ad una pagina "visualizzaLibro" a cui passo il parametro isbn del libro cliccato
          echo ">
                  <td>                  
                    <a href='visualizzaLibro.php?isbn=".$riga["ISBN"]."'>
                      ".$riga["ISBN"]."
                    </a>
                  </td>
                  <td>".$riga["Titolo"]."</td>
                  <td>".$riga["AnnoPubblicazione"]."</td>
                  <td>".$riga["NumeroCopie"]."</td>
                  <td>".$riga["Genere"]."</td>
                </tr>";
          // aggiorno il contatore
          $i++;
        }
        echo "</table>";
       
       
      // se saltano fuori exception legate alla connessione dal database le gestisco qui
      } catch(PDOException $e) {
          // stampando il messaggio di errore
          echo "<h2 style='color:red; font-weight:bold'>".$e->getMessage()."</h2>";
      }
    ?>
  </body>
</html>