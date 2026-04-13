<html>
    <head> 
        <link rel ="stylesheet" href="dashboard.css"> 
        <link rel ="stylesheet" href="elenchi.css"> 
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
        <div class = "intro">Gestione veicoli</div>
        <?php
                    include("inc/datiConnessione.php");
                    try{
                        session_start();
                        include("inc/startConn.php"); 

                        $sql= "SELECT targa, marca, modello, postiOmologati FROM veicolo";
                        $results = $conn->query($sql);
                        $veicoli = $results->fetchAll(PDO::FETCH_ASSOC);
                        $cont = 0;
                        echo"<ul class='elements'>";
                        foreach($veicoli as $v){
                            $cont++;
                            echo"<li>";
                            echo"<a href='visualizza_veicolo.php?targa=".$v['targa']."' id='navElement'/>";
                            echo"<ul class='records'>";
                            if($cont%2 == 0){
                                echo"<div class = 'rigaPari'>";
                            }else{
                                echo"<div class = 'rigaDispari'>";
                            }
                            echo"<li class = 'small'>".$cont."</li>";
                            echo"<li>Targa: ".$v["targa"]."</li>";
                            echo"<li>Marca: ".$v["marca"]."</li>";
                            echo"<li>Modello: ".$v["modello"]."</li>";
                            echo"<li>Posti omologati: ".$v["postiOmologati"]."</li>";
                            echo"</div>";
                            echo"</ul>";
                            echo"</li>";
                           
                        }
                        echo"</ul>";
                        
                    }catch(PDOException $e) {
                        echo "<h2 style='color:red; font-weight:bold'>".$e->getMessage()."</h2>";
                    }
                ?>  
    </body>
</html>
