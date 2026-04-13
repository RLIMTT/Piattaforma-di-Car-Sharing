<html>
    <head> 
        <link rel ="stylesheet" href="login.css">   
    </head>
    <body>
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
        controlla("nome", "E necessario inserire un nome", $errors);
        controlla("cognome", "E necessario inserire un cognome", $errors);
        controlla("username", "E necessario inserire uno username", $errors);
        controlla("codiceFiscale", "E necessario inserire il codice fiscale", $errors);
        controlla("datan", "E necessario inserire la data di nascita", $errors);
        controlla("comune", "E necessario inserire un comune di residenza", $errors);
        controlla("telefono", "E necessario inserire un numero di telefono", $errors);
        controlla("email", "E necessario inserire un'email", $errors);
        controlla("password", "E necessario inserire una password", $errors);

        if(count($errors) > 0){
            die(var_dump($errors));
        }

        $stmt = $conn->prepare("SELECT codiceFiscale FROM utente WHERE codiceFiscale = ?");
        $stmt->execute([$_POST['codiceFiscale']]);
        if($stmt->rowCount() == 0){
            $stmt = $conn->prepare("SELECT * FROM utente WHERE username = ?");
            $stmt->execute([$_POST['username']]);
            if($stmt->rowCount() == 0){
                $row =$stmt->fetch();
                function generaSalt() {
                    $chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
                    return substr(str_shuffle($chars), 0, 32);
                }
                $salt = generaSalt();
                $salt1 = substr($salt, 0, 32);
                $salt2 = substr($salt, 32, 32);
                $pass_salt = hash('sha256', $salt1.$_POST['password'].$salt2);
                
                $nome = $_POST['nome'];
                $cognome = $_POST['cognome'];
                $username = $_POST['username'];
                $codiceFiscale = $_POST['codiceFiscale'];
                $datan = $_POST['datan'];
                $comune = $_POST['comune'];
                $telefono = $_POST['telefono'];
                $email = $_POST['email'];

                

                $sql = "INSERT INTO utente 
                        (username, codiceFiscale, nome, cognome, dataDiNascita, comuneDiNascita, email, telefono, `pass`, salt)
                        VALUES 
                        (:username, :codiceFiscale, :nome, :cognome, :datan, :comune, :email, :telefono, :pass_salt, :salt)";

                $stmt = $conn->prepare($sql);
                $stmt->bindParam(':username', $username);
                $stmt->bindParam(':codiceFiscale', $codiceFiscale);
                $stmt->bindParam(':nome', $nome);
                $stmt->bindParam(':cognome', $cognome);
                $stmt->bindParam(':datan', $datan);
                $stmt->bindParam(':comune', $comune);
                $stmt->bindParam(':email', $email);
                $stmt->bindParam(':telefono', $telefono);
                $stmt->bindParam(':pass_salt', $pass_salt);
                $stmt->bindParam(':salt', $salt);
                $stmt->execute();
                echo"<div class='container'>";
                echo"<div class='login'>";
                echo"<p class='accedi'>Sei stato registrato correttamente!!</p>";
                echo"<img src = 'logo.png' alt='logo'>";
                echo"<button type='submit'><a href='login_utente.php'>Vai all'accesso</a></button>";
                echo"</form>";
                echo"</div>";
                echo"</div>";

            }else{
                echo"<div class= 'userusato'>";
                echo"<p>Lo usermname inserito è già esistente!!!</p>";
                echo"<a href = 'registra_utente.php'/>";
                echo"</div>";
                echo"<div class='container'>";
            echo"<div class='login'>";
            echo"<p class='accedi'>Lo usermname inserito è già esistente!!!</p>";
            echo"<img src = 'logo.png' alt='logo'>";
            echo"<button type='submit'><a href='login_utente.php'>Vai all'accesso</a></button>";
            echo"<button type='submit'><a href='registra_utente.php'>Torna alla registrazione</a></button>";
            echo"</form>";
            echo"</div>";
            echo"</div>";
            }     
        }else{
            echo"<div class='container'>";
            echo"<div class='login'>";
            echo"<p class='accedi'>Sei già registrato!!</p>";
            echo"<img src = 'logo.png' alt='logo'>";
            echo"<button type='submit'><a href='login_utente.php'>Vai all'accesso</a></button>";
            echo"</form>";
            echo"</div>";
            echo"</div>";
        }
    }catch(PDOException $e) {
    echo "<h2 style='color:red; font-weight:bold'>".$e->getMessage()."</h2>";
}
?>
    </body>
</html>
    
    