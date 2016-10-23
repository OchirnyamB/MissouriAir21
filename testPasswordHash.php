<?php
   # hashing with distint salt
   # distinct string of salt is expanded on top of the password
   # in our case we are using the employee_id as a slt
   $employee_id = "gulliams21";
   $password = "testpassword";
   $passwordToHash = $employee_id + $password;
   echo $passwordToHash;
   echo md5($passwordToHash);
?>

