<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Employee Portal Login Website</title>
        <!-- CSS -->
        <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:400,100,300,500">
        <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="assets/css/form-elements.css">
        <link rel="stylesheet" href="assets/css/style.css">
</head>

<body>
<div class="top-content">
 <div class="inner-bg">
             <div class="container">
                    <div class="row">
                        <div class="col-sm-8 col-sm-offset-2 text">
                            <h1><strong>Employee</strong> Portal Login</h1>
                            <div class="description">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6 col-sm-offset-3 form-box">
                        	<div class="form-top">
                        		<div class="form-top-left">
                            		<h3> Only Employees or Admins</h3>
                                        <p>Enter your username and password to log in:</p>
                        		</div>
                        		<div class="form-top-right">
                        			<i class="fa fa-suitcase"></i>
                        		</div>
                               </div>
                               <div class="form-bottom">
			                    <form role="form" action="login.php" method="post" class="login-form">
			                    	<div class="form-group">
			                    		<label class="sr-only" for="form-username">Username</label>
			                        	<input type="text" name="form-username" placeholder="Username..." class="form-username form-control" id="form-username">
			                        </div>
			                        <div class="form-group">
			                        	<label class="sr-only" for="form-password">Password</label>
			                        	<input type="password" name="form-password" placeholder="Password..." class="form-password form-control" id="form-password">
			                        </div>
			                        <button type="submit" name="login" class="btn btn-success">Login!</button>
			                    </form>
								<!--<form role="form" action="register.php" method="post" class="register-form">
									<button type="submit" name="register" class="btn btn-info">Register!</button>
								</form> -->
		              </div>
                        </div>
                   </div>
            </div> 
  </div>
</div>

<?php
   session_start();

   if(isset($_POST['register'])){
        $conn = mysqli_connect("localhost","ob44f","","ob44f");

        if(!$conn){
            die("Failed to connect to MySQL: ".mysqli_connect_error());
        } 
        $username = $_POST['username'];
        $password = $_POST['password'];
        if($username and $password){
           $res = mysqli_query($conn,"SELECT userName, userPassword FROM users WHERE userName = '$username'");
           $row = mysqli_fetch_array($res);
           if(mysqli_num_rows($res) == 1 && $row['userPassword'] == $password){
             $_SESSION['user'] = $username; 	
             header("Location: success.php");
           }
           else{
             echo "Login failed please login again!";
           }
        }else{
           echo "Both forms have to be filled!";
        }
        mysqli_close($conn);
  }
?>
</body>
<!-- Javascript -->
        <script src="assets/js/jquery-1.11.1.min.js"></script>
        <script src="assets/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.backstretch.min.js"></script>
        <script src="assets/js/scripts.js"></script>
</html>
