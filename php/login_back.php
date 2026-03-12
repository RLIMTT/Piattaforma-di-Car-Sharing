<?php
    include("inc/datiConnessione.php");
    try{
        session_start();
        include("inc/startConn.php");
        $errors = array();
        function controlla($campo, $messaggio_errore, & $errors){

            if(isset($_POST[$campo]) && trim($_POST[$campo]) != "") {
                return true;
            }
            else {
                $errors[] = $messaggio_errore;
                return false;
            }
        }
        controlla("username", "E necessario inserire uno username", $errors);
        controlla("password", "E necessario inserire una password", $errors);

        if(count($errors) > 0){
            die(var_dump($errors));
        }

        $stmt = $conn->prepare("SELECT * FROM utente WHERE username = ?");
        $stmt->execute([$_POST['username']]);
        $debug = $stmt->rowCount();
        echo $debug;
        if($stmt->rowCount() == 1){
            $row =$stmt->fetch();
            $salt_div = str_split($row["salt"], (strlen($row["salt"])/2));
            $pass_salt = hash('sha256', $salt_div[0].$_POST['password'].$salt_div[1]);
            echo "db: ".$row["pass"];
            echo "<br/>";
            echo "ca: ".$pass_salt;
            if($pass_salt === $row["pass"]){
                echo "Accesso consentito";
                $_SESSION["username"] = $row["username"];
                $_SESSION["nome"] = $row["nome"];
                $_SESSION["cognome"] = $row["cognome"];

            }else{
                die("Password errata!!!!");
            }
            echo "Accesso consentito";
        }else{
            die("Username non valido!!");
        }

    }catch(PDOException $e) {
    // stampando il messaggio di errore
    echo "<h2 style='color:red; font-weight:bold'>".$e->getMessage()."</h2>";
}


?>