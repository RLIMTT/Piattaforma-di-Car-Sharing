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
        <div class="container">
            <a href="utenti.php" class="card">
                <div class="card-top">
                <?php
                    include("inc/datiConnessione.php");
                    try{
                        session_start();
                        include("inc/startConn.php"); 

                        $sql= "SELECT * FROM utente";
                        $results = $conn->query($sql);
                        $n = $results->rowCount();
                        echo $n;
                ?>  
                </div>
                <div class="card-bottom">Utenti registrati</div>
            </a>

            <a href="veicoli.php" class="card">
                <div class="card-top">
                <?php
                    $sql= "SELECT * FROM veicolo";
                        $results = $conn->query($sql);
                        $n = $results->rowCount();
                        echo $n;
                ?>
                </div>
                <div class="card-bottom">Veicoli in gestione</div>
            </a>

            <a href="recensioni.php" class="card">
                <div class="card-top">
                <?php

                        $sql= "SELECT * FROM recensione";
                        $results = $conn->query($sql);
                        $n = $results->rowCount();
                        echo $n;
                    }catch(PDOException $e) {
                        echo "<h2 style='color:red; font-weight:bold'>".$e->getMessage()."</h2>";
                    }

                ?>


                </div>
                <div class="card-bottom">Recensioni scritte</div>
            </a>

        </div>
        
    </body>
</html>