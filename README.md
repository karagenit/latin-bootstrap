# Latin Final Project

Latin Translator, built with Whitaker's Words, jQuery, & Bootstrap!

Here is the [current working build](darkstonelabs.com/tests/) of the site.

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
$stmt = $db->prepare("SELECT * FROM latin WHERE word LIKE ? LIMIT 1");
$query_input = "%".$input."%";
$stmt->bind_param("s", $query_input); 
$stmt->execute(); 
$result = $stmt->get_result();
```

This is significantly truncated - all of the output code (including special test cases) has been taken out for simplicity's sake. Still - you can see the process of connecting to the SQL database and running a query on it. One of the fancier things is the use of a *prepared SQL statement*, which can allow for greater efficiency when running multiple queries and prevent SQL injection attacks (it forces the user input to be treated as a literal string).

#### A Big 'ol Goof

> **Protip:** don't hard code your database passwords

So, yeah, that's a thing I did. And then I pushed the file to github. With the password in it. In plaintext.

*No, you can't find it now, not even if you look through each and every one of my previous commits*. I used `git filter-branch --tree-filter 'rm -f latin.php' HEAD` to recurse through each previous commit and remove the file. That's why you'll see a few commits that are totally empty - the file that was originally changed by that commit was removed.

But, hey, when you overwrite a bunch of commits, github counts them as new contributions ... I did 55 things yesterday!

> **Protip:** before doing major repo changes, make sure you're sync'd with your remote

After running `filter-branch` I realized there were a few commits on `origin` I didn't have locally ... pulling caused merge conflicts, so I ended up having to drop a couple commits (they were just edits to README, which I copied in later).

#### HTAccess

> **Protip:** don't add your PHP files to your `.htaccess` - it won't work!

I mean, it *will* work ... not only will users not be able to navigate to that file, but any other page that tries to GET/POST to it will get a `403 Access Denied`. There really isn't any way to prevent users from "accidentally" visiting the straight PHP file ... just make sure it doesn't do anything weird when there isn't any input.

## SQL Database

Here's the [original plaintext database](http://archives.nd.edu/whitaker/dictpage.htm) that this site uses to lookup definitions - it's also the database used by the original Words program. For ease of use, I wrote a script which parsed the file and stuck the data in an SQL database.

#### Setting Up MySQL/MariaDB

This took me about an hour to get working, as I'd never worked with MySQL specifically before. For whatever reason, the service *just would not start*. I scoured Stack Overflow & other forms to no avail, so I began searching through all of the log files it created. One of them mentioned that I may have an improper configuration file, so I began comparing my local config files to "defaults" I found online. 

In particular, I found differences in my `/etc/my.cnf`. Specifically, I saw that many of the directory settings (which usually point to `/var/`) were pointing to `/mnt/ram4/var/`. Removing this prefix seemed to clear up my issue - I was immediately able to start the MySQL server.

After that, I had a couple issues with permissions. First, obviously, I had to configure my user with access to all databases. I also had to remove the `old_passwords=1` line from `/etc/my.cnf` ... I'm not sure what that did, but the DB was complaining about it (and taking it out seemed to fix it).

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
