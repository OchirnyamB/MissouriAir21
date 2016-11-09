<!DOCTYPE html>
<html>
<body>
 <form name="login" action="login.php" method="POST">
   <table>
    <tr>
       <td><b>Username:</b></td>
       <td>
          <input type="text" placeholder="Enter Username" name="username" size="20">
       </td>
    </tr>
    <tr>
       <td><b>Password:</b></td>
       <td>  
          <input type="password" placeholder="Enter Password" name="password" size="20">
       </td>
    </tr>
    <tr>
      <td></td>
      <td>
          <input type="submit" name="register" value="Login"> 
          <a href="main.php">Back to Register</a>
      </td> 
    </tr>
   </table>
</form>

<?php
   session_start();

   if(isset($_POST['register'])){
        $conn = mysqli_connect("localhost","ob44f","Miniidun22","ob44f");

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

</html>
