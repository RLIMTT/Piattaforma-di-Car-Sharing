 <form method="GET" action="#">
    <!-- filtro per categoria -->
    <label for="categoria">Categoria: </label>
    <select name="categoria">
        <option value="all">&ltTutte le categorie&gt</option>
        <option value="Motociclo"
        <?php 
            if(isset($_GET["categoria"]) && $_GET["categoria"]=="Motociclo")
                echo "selected";
        ?>
        >Motociclo</option>
        <option value ="Autovettura"
        <?php 
            if(isset($_GET["categoria"]) && $_GET["categoria"]=="Autovettura")
                echo "selected";
        ?>
        >Autovettura</option>

    </select>
    <input type= 'submit' value='invia'/>
<?php

    $sql="SELECT targa, marca, modello from veicolo";
    if(isset($_GET["categoria"])&&$_GET["categoria"]!="all"){
        $sql.= " WHERE categoria = '$_GET[categoria]'";
    }
    if(!isset($sql))
        die("<h2 style='color:red>Errore!! QueryMancante!!</h2>");
    $results = $conn->query($sql);
    if($results->rowcount()<1)
        echo"La query non ha prodotto risultati";
    else{
        $tabella =$results->fetchAll(PDO::FETCH_ASSOC);
        $chiavi = array_keys ($tabella[0]);
        echo"<table>";
        echo"<tr>";
        foreach($chiavi as $k)
            echo"<th class='rigaIntestazione'>$k</th>";
        echo"</tr>";
        $i=0;
        foreach($tabella as $riga){
            echo"<tr";
            if($i%2 ==0)
                echo " class='rigaAlternata'";
            echo">";
            
            echo"<td>
            <a href='stampaVeicolo.php?targa=".$riga["targa"]."'>
            ".$riga["targa"]."
            </a>
            </td>
            <td>".$riga["marca"]."</td>
            <td>".$riga["modello"]."</td>";
            echo"</tr>";
            $i++;
        }
        echo"</table>";
    }
?>