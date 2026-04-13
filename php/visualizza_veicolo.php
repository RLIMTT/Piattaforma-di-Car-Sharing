<html>
    <head>
        <link rel ="stylesheet" href="login.css"> 
        <link rel ="stylesheet" href="dashboard.css"> 
        <link rel ="stylesheet" href="visualizza_veicolo.css"> 
    </head>
    <body>
        <header class="header">
            <!-- Logo e scritta -->
            <a href="dashboard_admin.php" class="logo">
                <img src="logo.png" alt="logo">
            </a>
            <!-- Menu -->
            <label for="menu-btn" class="menu-icon">
                <span class="nav-icon"></span>
            </label>
            <ul class="menu">  
                <!-- Link di navigazione -->
                <li><a href="utenti.php" id="navUtenti">Gestione utenti</a></li>
                <li><a href="veicoli.php" id="navVeicoli">Gestione veicoli</a></li>
                <li><a href="Recensioni.php" id="navRecensioni">Visualizza recensioni</a></li>
            </ul>
        </header>
        <?php
            echo"<div class='area'>";
            if(!isset($_GET["targa"])){
                echo "<h2 style='color:red;'>ATTENZIONE! TARGA NON SETTATA</h2>";
            } else{
                if(empty($_GET["targa"])){
                    echo "<h2 style='color:red;'>ATTENZIONE! TARGA MANCANTE</h2>";
                    die;
                } else{
                    include("inc/datiConnessione.php");
                    try {
                        include("inc/startConn.php");
                        $sql = "SELECT * FROM veicolo WHERE targa='".$_GET['targa']."'";
                        $results = $conn->query($sql);
                        if($results->rowCount() == 0){
                            echo "<h2 style='color:red;'>Veicolo non presente in elenco</h2>";
                        } else if($results->rowCount() == 1){
                            $veicolo = $results->fetch(PDO::FETCH_ASSOC);//fetch--> trasforma il dataset in array associativo
                            echo "<div class ='veicolo'>";
                            echo "<img src='img/$veicolo[marca]$veicolo[modello].jpg' alt='imgAuto'>";
                            echo "<p class = 'mm'>" .$veicolo["marca"]. " " . $veicolo["modello"] ."</p>";
                            echo "<p class = 'posti'>Posti omologati: " . $veicolo["postiOmologati"]."</p>";
                            echo "<p class = 'prezzo'>A partire da soli ". $veicolo["prezzoAlGiorno"]." euro al giorno!!</p> ";
                            
                            echo" </div>";

                        } else{
                            echo "<h2 style='color:red;'>ATTENZIONE! SONO STATI TROVATI PIU' VEICOLI CON LA STESSA TARGA</h2>";
                        }
                        // se saltano fuori exception legate alla connessione dal database le gestisco qui
                    
                    } catch(PDOException $e) {
                    // stampando il messaggio di errore
                         echo "<h2 style='color:red; font-weight:bold'>".$e->getMessage()."</h2>";
                     }
                   
                }  
            }
            
        ?>
    </body>
</html>