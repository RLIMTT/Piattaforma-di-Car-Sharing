<html>
    <head> 
        <link rel ="stylesheet" href="login.css"> 
        
    </head>
    <body>
        <div class='container'>
            <div class="login">
                <p class='accedi'>Accedi</p>
                <img src = 'logo.png' alt='logo'>
                <form method='post' action='login_back.php'>
                    <label for ='username'>Username</label>
                    <br/>
                    <input type="text" name="username" required/>
                    <br/>
                    <label for ='password'>Password</label>
                    <br/>
                    <input id='pwd' type='password'name='password' value = 'a' />
                    <br/>
                    <button type='submit'>Accedi</button>
                    
                </form>
            </div> 
            <div class= "noAccount">
                <p class='register'>Non hai un account?
                    <a href="registra_utenti.php" id="Registro">Registrati</a>
                </p>  
            </div>
        </div>
        
        <noscript>
            <p>Il tuo browser non supporta Javascript, è necessario abilitarlo per proseguire</p>
        </noscript>

        <script>
			// Function to hash string with SHA-256
			async function sha256(message) {
				const msgBuffer = new TextEncoder().encode(message); // encode as UTF-8
				const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer); // hash
				const hashArray = Array.from(new Uint8Array(hashBuffer)); // convert buffer to byte array
				const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join(''); // convert bytes to hex string
				return hashHex;
			}

			document.getElementById('loginForm').addEventListener('submit', async (e) => {
				e.preventDefault(); // Stop form from submitting immediately
				
				const passwordInput = document.getElementById('pwd');
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