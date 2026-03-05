<html>
    <head> 
        <style>
            table, tr, th, td {
                border: 1px solid black collapse;
            }
            .rigaIntestazione{
                background-color: blue;
            }
            .rigaAlternata{
                background-color: lightblue;
            }
            </style>
 
    </head>
    <body>

    <h1>Tabella veicoli</h1>
    <?php
        include("inc/datiConnessione.php");
        try{
            include("inc/startConn.php");
            include("inc/stampaTabella.php");
            
        }catch(PDOException $e){
            echo"<h2 style='color:red'>".$e->getMessage()."</h2>";
        }
    ?>
    </body>
</html>
