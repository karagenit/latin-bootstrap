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
	$query = "SELECT * FROM test WHERE id = " . strlen($input);
	$result = $db->query($query);
	
	while($row = $result->fetch_assoc()) {
		echo $row['word'];
	}
?>
</body>
</html>
