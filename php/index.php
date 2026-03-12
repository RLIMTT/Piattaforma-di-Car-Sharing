<html>
    <head> 
        <link rel ="stylesheet" href="style.css"> 
        
    </head>
    <body>

    <header class="header">
        <!-- Logo e scritta -->
        <a href="index.php" class="logo">
            <img src="logo.png" alt="logo">
        </a>
        
        <ul class="menu">  
            <!-- Link di navigazione -->
            <li><a href="login_utente.php" id="Accesso">Login</a></li>
        </ul>
    </header>
    <p class= "titolopag">Scopri i veicoli preferiti dai nostri clienti!!</p>
    <?php
        include("inc/datiConnessione.php");
        try{
            $sql= "SELECT  targa, marca, modello, postiOmologati, prezzoAlGiorno, idPrenotazione FROM veicolo INNER JOIN prenotazione USING (targa)";
            include("inc/startConn.php");
            echo "<div class =\"veicoli\">";
            for($x = 0; $x<3; $x++){
                $results = $conn->query($sql);
                if($results->rowCount() <1){
                    echo "<h1>Error!!</h1> ";
                }else{
                    $prenotazioni = $results->fetchAll(PDO::FETCH_ASSOC);
                    $v1 = $prenotazioni[0];//elemento maggiore
                    $occv1=0;//occorrenze maggiori
                    $occvm=0;//occorrenze momentanee
                    foreach($prenotazioni as $v){
                        $occvm=0;//occorrenze momentanee
                        foreach($prenotazioni as $p){
                            if($v["marca"] == $p["marca"] && $v["modello"] == $p["modello"]){
                                $occvm++;
                            }
                        }
                        if($occvm > $occv1){
                            $v1 = $v;
                            $occv1 = $occvm;
                        }
                    }
                    echo "<div class ='veicolo'>";
                    echo "<img src='img/$v1[marca]$v1[modello].jpg' alt='imgAuto'>";
                    echo "<p class = 'mm'>" .$v1["marca"]. " " . $v1["modello"] ."</p>";
                    echo "<p class = 'posti'>Posti omologati: " . $v1["postiOmologati"]."</p>";
                    echo "<p class = 'prezzo'>A partire da soli ". $v1["prezzoAlGiorno"]." euro al giorno!!</p> ";
                    echo "<a href=\"login_utente.php\" id=\"Accesso\">Scopri ora !!</a>";
                    echo" </div>";
                }
                if($x == 0){
                    $sql = $sql . " WHERE NOT (marca = '" .$v1["marca"]. "') AND NOT (modello = '".$v1["modello"]."')";
                }elseif($x == 1){
                     $sql = $sql . " AND NOT (marca = '" .$v1["marca"]. "') AND NOT (modello = '".$v1["modello"]."')";
                }
                 
            }
            echo" </div>";
           
        }catch(PDOException $e){
            echo"<h2 style='color:red'>".$e->getMessage()."</h2>";
        }
    ?>
    </body>
</html>