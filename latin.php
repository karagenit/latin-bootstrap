<!DOCTYPE html>
<html>
<body>
<?php 
	//echo "Posted: ";
	//echo $_POST['input']; 
	//echo "\n";

	$input = $_POST['input'];

	if(!strcmp($input, "")) { //why !, you ask? Because "Screw you, that's why" -PHP
		echo "";
		die();
	}

    $pword = file_get_contents("./.password.db");
    $uname = file_get_contents("./.username.db");
    $dname = file_get_contents("./.database.db");
	$db = new mysqli("localhost", $uname, $pword, $dname);

    $stmt = $db->prepare("SELECT * FROM latin WHERE word LIKE ? LIMIT 3 union SELECT * FROM latin WHERE word LIKE ? LIMIT 3"); //returns STMT obj
	
	$query_input = $input."%";
	$query_input_2 = "%".$input."%";
	$stmt->bind_param('ss', $query_input, $query_input_2); //returns boolean

	$stmt->execute(); //returns boolean

//	$stmt->bind_result($id, $word); //returns boolean, binds vars, awaits fetch()	
//	$stmt->fetch(); //returns boolean, assigns results to bound vars

	$result = $stmt->get_result(); //returns RESULT obj

	while($row = $result->fetch_assoc()) { //returns assoc array
		echo "Word: " . $row['word'] . "<br>";
		echo "Part of Speech: " . $row['part'] . "<br>";
		echo "Form of Word: " . $row['declension'] . "<br>";
		echo "Modifier: " . $row['modifier'] . "<br>";
		echo "Definition: " . $row['definition'] . "<br><br>";
	}
?>
</body>
</html>
