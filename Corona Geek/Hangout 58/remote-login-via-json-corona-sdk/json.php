
<?php

	// This script accepts incoming login parameters, performs a database lookup, and returns user data in JSON format.
	// http://omnigeek.robmiracle.com/2012/04/15/using-corona-sdk-with-rest-api-services

	// define our database connection details
	define("DB_DSN",'db_json');
	define("DB_HOST",'localhost');
	define("DB_USER",'dbuser_json');
	define("DB_PASS",'42letmein$$');

	// Connecting, selecting database
	$link = mysql_connect(DB_HOST, DB_USER, DB_PASS) or die('Could not connect: ' . mysql_error());
	mysql_select_db(DB_DSN) or die('Could not select database');

	// are there incoming parameters
	if(isset($_GET)) {

	    $userid = base64_decode($_GET["userid"]);
	    $password = base64_decode($_GET["password"]);

	    $query = 'SELECT * FROM players WHERE userid="' . mysql_real_escape_string($userid) . '"';
	    $dbresult = mysql_query($query, $link);

	    // handle database return errors
	    if (!$dbresult) {

	        //echo "query failed";
	        $result = array();
	        $result["result"] = 403;
	        $result["message"] = mysql_error();

	        echo json_encode($result);
	        mysql_free_result($dbresult);

	        exit;
	    }

		// DEBUG
		// echo "URL UserID: ".$_GET["userid"]."<br/>";
		// echo "base64 UserID: ".$userid."<br/>";
		// echo "DB UserID: ".$player["userid"]."<br/>";
		
		// echo "URL Password: ".$_GET["password"]."<br/>";
		// echo "base64 Password: ".$password."<br/>";
		// echo "DB Password: ".$player["password"]."<br/>";
		// echo "MD5 Password: ".md5($password)."<br/>";

	    // specify that an associative array be returned, instead of a numeric index
	    $player = mysql_fetch_array($dbresult, MYSQL_ASSOC);

	    // authenticate user
	    if (strcmp($player["password"], md5($password)) == 0) {

	    	// password match. 
	        $result = array();
	        $result["result"] = 200;
	        $result["message"] = "Success";
	        $result["userid"] = $player["userid"];
	        $result["firstname"] = $player["firstname"];
	        $result["lastname"] = $player["lastname"]; 
	        $query = sprintf("UPDATE players SET lastlogin=NOW() WHERE id=%s;", $player["id"]);
	        $uresult = mysql_query($query, $link);
	        
	        // handle failed user updates
	        if ($uresult) {
	            // code if your update failed.  
	            // Doesn't really impact what we are doing. so do nothing.
	        }

	        // return JSON formatted response
	        echo json_encode($result);

	    } else {
	        //echo "password mismatch";
	        $result = array();
	        $result["result"] = 403;
	        $result["message"] = "Forbidden - Bad Password";
	        echo json_encode($result);
	    }
	
	} else {
		// 400 bad request occurred
	    $result = array();
	    $result["result"] = 400;
	    $result["message"] = "Bad Request";
	    echo json_encode($result);
	}
	exit;

?>