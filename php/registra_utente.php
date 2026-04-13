<html>
    <head> 
        <link rel ="stylesheet" href="registra.css">   
    </head>
    <body>
      <div class='container'>
            <div class="registra">
                <p class='registrati'>Registrati</p>
                <img src = 'logo.png' alt='logo'>
                <form method='post' id = "registerForm" action='registra_back.php'>
                    <label for ='nome'>Nome</label>
                    <br/>
                    <input type="text" name="nome" required/>
                    <br/>
                    <label for ='cognome'>Cognome</label>
                    <br/>
                    <input type="text" name="cognome" required/>
                    <br/>
                    <label for ='username'>Username</label>
                    <br/>
                    <input type="text" name="username" required/>
                    <br/>
                    <label for ='codiceFiscale'>Codice fiscale</label>
                    <br/>
                    <input type="text" name="codiceFiscale" maxlength="16" minlength="16" required/>
                    <br/>
                    <label for ='datan'>Data di nascita</label>
                    <br/>
                    <input type="date" name="datan" required/>
                    <br/><label for ='comune'>Comune di nascita</label>
                    <br/>
                    <input type="text" name="comune" required/>
                    <br/>
                    <br/><label for ='telefono'>Numero di telefono</label>
                    <br/>
                    <input type="tel" name="telefono" required/>
                    <br/>
                    <br/><label for ='email'>Email</label>
                    <br/>
                    <input type="email" name="email" required/>
                    <br/>
                    <label for ='password'>Password</label>
                    <br/>
                    <input id='password' type='password' name='password' />
                    <br/>
                    <label for ='conferma'>Conferma la password</label>
                    <br/>
                    <input id='conferma' type='password'name='conferma'  />
                    <br/>
                    <p id="errore" style="color:red;"></p>                     
                    <button type='submit'>Registrati</button>
                </form>
                <script>
                  document.addEventListener("DOMContentLoaded", function() {
                      document.getElementById("registerForm").addEventListener("submit", function(event) {
                          const password = document.getElementById("password").value;
                          const conferma = document.getElementById("conferma").value;

                          if (password !== conferma) {
                              event.preventDefault();
                              alert("Le password non coincidono!");
                          }
                      });
                  });
                </script>
            </div> 
        </div>
      <script>
        // Function to hash string with SHA-256
        async function sha256(message) {
          const msgBuffer = new TextEncoder().encode(message); // encode as UTF-8
          const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer); // hash
          const hashArray = Array.from(new Uint8Array(hashBuffer)); // convert buffer to byte array
          const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join(''); // convert bytes to hex string
          return hashHex;
        }

        document.getElementById('registerForm').addEventListener('submit', async (e) => {
          e.preventDefault(); // Stop form from submitting immediately
          
          const passwordInput = document.getElementById('password');
          const passwordValue = passwordInput.value;
          
          // Hash the password
          const hashed = await sha256(passwordValue);
          
          // Replace with hash
          passwordInput.value = hashed;
          
          console.log('Original hashed before submission:', hashed);
          
          // Submit form
          e.target.submit();      
                  e.target.reset();
        });
      </script>
    </body>
</html>