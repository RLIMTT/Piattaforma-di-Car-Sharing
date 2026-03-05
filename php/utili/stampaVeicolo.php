<html>
    <head>
    </head>
    <body>
        <?php
        include_once "inc/datiConnessione.php";
        try{
            include_once "inc/startConn.php";
            $sql="SELECT * FROM veicolo WHERE targa = '".$_GET['targa']."'";
            //echo "quey 1: ".$sql;
            $results = $conn->query($sql);
            //echo "ok1";
            if($results->rowCount()==0){
                echo"<h2 style= 'color:red'>Veicolo non presente in lista</h2>";
            }else if($results->rowCount() == 1){
                $veicolo = $results->fetch(PDO::FETCH_ASSOC);
                echo "<h1>$veicolo[categoria]: $veicolo[targa]</h1>";
                echo "<p>Marca veicolo: $veicolo[marca]</p>";
                echo "<p>Modello veicolo: $veicolo[modello]</p>";
                echo "<p>Motore: $veicolo[cc] cc, $veicolo[cv] cavalli</p>";
                echo "<p>Posti omologati: $veicolo[postiOmologati]</p>";
                echo "<p>Disponibile: ";
                $sql = "SELECT * FROM prenotazione WHERE targa = '$veicolo[targa]' AND idPrenotazione NOT IN (SELECT idPrenotazione from noleggio)";
                //echo "query 2: ".$sql;
                $results = $conn->query($sql);
                //echo "ok2";
                if($results->rowCount()<1){
                    echo "Il veicolo è dispinibile</p>";
                }else{
                    $prenotazioniVeicolo = $results->fetch(PDO::FETCH_ASSOC);
                    $sql= "SELECT * FROM prenotazione WHERE targa= '$veicolo[targa]' AND 'DATEDIFF(day, dataInizioPrenotazione, CURRENT_DATE())'<0";
                    $results = $conn->query($sql);
                    if($results->rowcount()<1){
                        echo "Il veicolo è disponibile</p>";
                    }elseif($results->rowcount()==1){
                        echo "Il veicolo sarà disponibile dal giorno ";
                        $prenotazione= $results->fetch(PDO::FETCH_ASSOC);
                        $giornoDisp = date_add($prenotazione[dataPrevistaFineNoleggio], 1);
                        echo"$giornoDisp</p>";
                    }

                }

            }

        }catch(PDOException $e){
            echo"<h2 style='color:red'>".$e->getMessage()."</h2>";
        }
        ?>
    </body>
</html>