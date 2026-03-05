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
            $sql= "SELECT * FROM prenotazione";
            include("inc/startConn.php");
            echo "<div class =\"veicoli\">";
            for($x = 0; $x<3; $x++){
                $results = $conn->query($sql);
                if($results->rowCount() <1){
                    echo "<h1>Error!!</h1> ";
                }else{
                    $prenotazioni = $results->fetchAll(PDO::FETCH_ASSOC);
                    $p1 = $prenotazioni[0];//elemento maggiore
                    $occe=0;//occorrenze maggiori
                    $pe = $p1;//elemento momentaneo

                    

                    foreach($prenotazioni as $k){
                        $occ1 = 0;//occorrenze momentanee
                        $sql2 = "SELECT marca, modello FROM veicolo WHERE targa = '".$k["targa"]."'";
                        $result = $conn->query($sql2);
                        $r1 = $results->fetchAll(PDO::FETCH_ASSOC);
                        foreach($prenotazioni as $p){
                            $sql2 = "SELECT marca, modello FROM veicolo WHERE targa = '".$p["targa"]."'";
                            $result = $conn->query($sql2);
                            $r2 = $results->fetchAll(PDO::FETCH_ASSOC);
                            
                            if($r2["marca"] == $r1["marca"] && $r2["modello"] == $r1["modello"]){
                                $occ1 ++;
                                $pe = $p;
                            }
                        }
                        if($occ1 > $occe){
                            $p1 = $pe;
                            $occe = $occ1;
                        }
                    }
                    echo "<p>" .$r1["marca"]. " " . $r1["modello"] ."<br/>";
                    echo "Posti omologati: " . $r1["postiOmologati"]."<br/>";
                    echo "<p class = \"prezzoCard\">A partire da soli ". $p1["prezzoAlGiorno"]." euro al giorno!!</p> <br/>";
                    echo "<a href=\"login_utente.php\" id=\"Accesso\">Scopri ora !!</a>";
                    echo "</p>";
                }
                if($x == 0){
                    $sql = $sql . " WHERE NOT (marca = '" .$r1["marca"]. "') AND NOT (modello = '".$r1["modello"]."')";
                }elseif($x == 1){
                     $sql = $sql . " AND NOT (marca = '" .$r1["marca"]. "') AND NOT (modello = '".$r1["modello"]."')";
                }
            }
            echo" </div>";

            
        }catch(PDOException $e){
            echo"<h2 style='color:red'>".$e->getMessage()."</h2>";
        }
    ?>
    </body>
</html>