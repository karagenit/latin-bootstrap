# Latin Final Project

Latin Translator, built with Whitaker's Words, jQuery, & Bootstrap!

Here is the [current working build](http://techhounds.com/caleb/latin) and the [old server](http://darkstonelabs.com/tests/) of the site.

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

I used [this](http://php.net/manual/en/book.mysqli.php) site as a starting point for setting up the MySQLi queries.

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

#### Dictionary Database Configuration

`CREATE TABLE latin (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, word CHAR(64) NOT NULL, part CHAR(16) NOT NULL, declension CHAR(16), modifier CHAR(16), definition CHAR(128) NOT NULL);`

I used [this](http://www.wikihow.com/Create-a-Database-in-MySQL) guide for setting up the DB. 

## Bash SQL Generator

To place all of the data into the SQL database, I wrote a bash script to parse the text file and make SQL insertions. Funny enough, I actually remembered *not to hard code the DB password* for this file.

#### Awk & Sed

The script does the following:

1. Iterate through each line in the file
2. Separate records using `awk`
3. Remove excess delimiting characters with `sed`
4. Based on current/previous record, determine which column this record belongs in

Alright, let's talk about that last one. I mostly used regex matching to categorize each record. For example, if we are currently writing to the `word` column and this record ends in a comma, the next record should also write to `word`. Or, another example, if this record starts/ends with [] we know that we should write it to `modifier`. 

> **Protip:** when you run this script over ssh, use [screen](https://www.howtogeek.com/howto/ubuntu/keep-your-ssh-session-running-when-you-disconnect/) or something ... it might take a while!

## Bootstrap

I used [Bootstrap](https://getbootstrap.com) to build the web interface. Specifically, I based it on the Jumbotron example/template, though I ultimately scrapped pretty much everything that originally existed besides fonts and a couple styles.

Oh, and of course we have this gem:

```HTML
<div class="row marketing">
	<div class="col-md-3"></div>
	<div class="col-md-6 col-md-offset-3">
		<p id="output">Well, what are you waiting for?<br>Search something already!</p>
	</div>
</div>
```

Adding that empty column for spacing ... *and* adding the offset class to the main column ... but for some reason, taking one out breaks it on either Desktop or Mobile. 

Oh, and there's a `<p><br></p>` stuck in there cause I don't know how to use margins apparently.
