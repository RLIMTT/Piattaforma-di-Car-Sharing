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
        
        if($stmt->rowCount() == 1){
            $row =$stmt->fetch();
            $salt1 = substr($row["salt"],0,32);
            $salt2 = substr($row["salt"],32,32);
            $pass_salt = hash('sha256', $salt1.$_POST['password'].$salt2);
            if($pass_salt === $row["pass"]){
                $_SESSION["username"] = $row["username"];
                $_SESSION["nome"] = $row["nome"];
                $_SESSION["cognome"] = $row["cognome"];

            }else{
                die("Password errata!!!!");
            }
            if($row["admin"]==true){
                header("Location: dashboard_admin.php");
                exit();
            }else{
                echo "Accesso consentito ";
            }
        }else{
            die("Username non valido!!");
        }

    }catch(PDOException $e) {
    // stampando il messaggio di errore
    echo "<h2 style='color:red; font-weight:bold'>".$e->getMessage()."</h2>";
}


?>