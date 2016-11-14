<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Search Flights</title>
        <!-- CSS -->
        <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:400,100,300,500">
        <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="assets/css/form-elements.css">
        <link rel="stylesheet" href="assets/css/style.css">
</head>

<body>

<!-- Top content -->
        <div class="top-content">
            <div class="inner-bg">
                <div class="container">
                    <div class="row">
                        <div class="col-sm-8 col-sm-offset-2 text">
                            <h1><strong>Search</strong> Flights</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6 col-sm-offset-3 form-box">
                        	<div class="form-top">
                        		<div class="form-top-left">
                                    <h3> One way </h3>
                            		<p>Flight details</p>
                        		</div>
                        		<div class="form-top-right">
                        			<i class="fa fa-plane"></i>
                        		</div>
                                </div>
                                <div class="form-bottom">
			                        <form role="form" action="show_flights.php" method="post" class="">
										<div class="form-group row">
											<div class="col-xs-6 col-xs-offset-3">
											    <label>Flying from:</label>
												<input type="text" name= "" placeholder="City or airport.." class="form-control" id="">
											</div>
										</div>
										<div class="form-group row">
											<div class="col-xs-6 col-xs-offset-3">
											    <label>Flying to:</label>
												<input type="text" name= "" placeholder="City or airport.." class="form-control" id="">
											</div>
										</div>
										<div class="form-group row">
											<div class="col-xs-6 col-xs-offset-3">
											    <label>Departing:</label>
												<input type="date" name= "" class="form-control" id="">
											</div>
										</div>
										<div class="form-group row">
											<div class="col-xs-6 col-xs-offset-3">
											    <label>Price range:</label>
												<select class="form-control" name = "">
												    <option value="1"><$200</option>
												    <option value="2"><$400</option>
												    <option value="3"><$600</option>
												    <option value="4"><$800</option>
													<option value="5"><$1000</option>
												</select>
											</div>
										</div>
										<div class="form-group row">
											<div class="col-xs-6 col-xs-offset-3">
												<button type="submit" class="btn btn-success btn-sm">Search</button>
											</div>
										</div>
                                    </form>
                               </div>
                       </div>
                  </div>
             </div>
         </div>
      </div>

<?php

?>

</body>
<!-- Javascript -->
        <script src="assets/js/jquery-1.11.1.min.js"></script>
        <script src="assets/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.backstretch.min.js"></script>
        <script src="assets/js/scripts2.js"></script>
</html>
