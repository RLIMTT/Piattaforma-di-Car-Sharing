<?php
include("inc/datiConnessione.php");

include("inc/startConn.php");

$query = "SELECT username FROM utente WHERE pass IS NULL";
$result = $conn->query($query);
$row = $result->fetchAll(PDO::FETCH_ASSOC);
foreach($row as $r){
    $username = $r['username'];

    // password in chiaro = username
    $plainPassword = $username;

    
    // hash della password
    $hash1 = hash('sha256',$plainPassword);

    // genera salt casuale 64 caratteri
    $salt = bin2hex(random_bytes(64));

    // divide salt
    $salt1 = substr($salt,0,32);
    $salt2 = substr($salt,32,32);

    // hash finale
    $finalHash = hash('sha256',$salt1.$hash1.$salt2);
    /*
    $stmt = $conn->prepare("UPDATE utente SET pass=?, salt=? WHERE username=?");
    $stmt->execute($finalHash,$salt,$username);*/
    $sql= "UPDATE utente SET pass='$finalHash', salt='$salt' WHERE username = '$username'";
    $result = $conn->query($sql);
}

echo "Password generate correttamente";


?>