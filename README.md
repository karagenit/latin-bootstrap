# Latin Final Project

Latin Translator, built with Whitaker's Words, jQuery, & Bootstrap

## The Original App

The idea for this project came from a website called [Whitaker's Words](http://archives.nd.edu/words.html). While it's an incredibly useful app, I had a couple issues with it:

#### It's Old

While this isn't inherently bad, it's a console application written in Ada that uses a Perl script to make the web interface (the Perl takes a query from the user and runs the Ada application with the parameters, then shows the output). I don't like this because:

1. It wasn't designed for the web
2. Old, uncommon languages are hard to maintain

#### It's Slow

Not so much that the actual computation takes a long time - the Ada application is pretty good (I haven't run any speed tests to compare the Ada to the PHP script I wrote, I hope to do that in the future). The issue was having to *click* search and *click* back for every search query (I know, I know, my life is so tough ... I'm lazy okay?) - I wanted to make a webpage that used AJAX to update search results on-the-fly.

#### It's Ugly

Oh yeah, and it looks pretty 00's, so I figured I'd give it a facelift by using Bootstrap to design the page.

## AJAX through jQuery

Here's a code snippet for you:

```JavaScript
$("input").keyup(function(){
		console.log("Posting");
		$.ajax({
			type: "POST",
			url: "latin.php",
			datatype: "html",
			data: {input: document.getElementById("input").value},
			success: function(data) {
				document.getElementById("output").innerHTML = data;
			}
		});
	});
```

Here we're using `jQuery 2.1.3`. When the user types in the search bar, it sends an asynchronous request back to `latin.php` with the text in the search bar, and then displays the results of the request.

## PHP

The server-side PHP handles the database query requests from the user. Some more code:

```PHP
$input = $_POST['input'];
$db = new mysqli("localhost");
$stmt = $db->prepare("SELECT * FROM latin WHERE word LIKE ? LIMIT 1"); //returns STMT obj
$query_input = "%".$input."%";
$stmt->bind_param("s", $query_input); //returns boolean
$stmt->execute(); //returns boolean
$result = $stmt->get_result();
```

This is significantly truncated - all of the output code (including special test cases) has been taken out for simplicity's sake. Still - you can see the process of connecting to the SQL database and running a query on it. One of the fancier things is the use of a *prepared SQL statement*, which can allow for greater efficiency when running multiple queries and prevent SQL injection attacks (it forces the user input to be treated as a literal string).

## SQL Database

## Bash SQL Generator

## Bootstrap

## TODO

* Conjugations
* Better Searching
* Search Speed Optimization
* Cleanup Index/PHP
* Seperate WORD column into 4 cols
* PHP Return Associative Array, Handle JSON Object in JavaScript
* Nicer CSS for results: boxes around each entry, color each field
* Cache prepared statement?
