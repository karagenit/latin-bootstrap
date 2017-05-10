<!DOCTYPE html>
<html>
<body>
<?php 
	//echo "Posted: ";
	//echo $_POST['input']; 
	//echo "\n";

	$input = $_POST['input'];

	$db = new mysqli("localhost", "techhound", "team868!", "dict");

	//echo "DB Error: ";
	//echo $db->connect_error;
	
	echo "Input Length: ";
	echo strlen($input);
	echo "<br>";
	
	echo "Query @ Value: ";
	$stmt = $db->prepare("SELECT * FROM test WHERE id = ?;"); //returns STMT obj
	
	$stmt->bind_param("s", strlen($input)); //returns boolean

	$stmt->execute(); //returns boolean

//	$stmt->bind_result($id, $word); //returns boolean, binds vars, awaits fetch()	
//	$stmt->fetch(); //returns boolean, assigns results to bound vars

	$result = $stmt->get_result(); //returns RESULT obj

	while($row = $result->fetch_assoc()) { //returns assoc array
		echo $row['word'];
	}
?>
</body>
</html>
