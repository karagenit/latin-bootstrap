#!/bin/bash

pword=`cat .password.db`
uname=`cat .username.db`
dname=`cat .database.db`

function add-entry {
	word=$1
	pos=$2
	decl=$3
	mod=$4
	def=$5
	mysql -u $uname -p$pword -D $dname -e "INSERT INTO latin (id, word, part, declension, modifier, definition) VALUES (NULL, '$word', '$pos', '$decl', '$mod', '$def');"
}

# TODO on startup, DELETE FROM latin

while read line
do
	value=word
	maxind=`echo $line | awk '{ print NF }'`
	word=""
	pos=""
	decl=""
	mod=""
	def=""

	for i in `seq 1 $maxind`
	do
		field=`echo $line | awk -v i="$i" '{ print $i }'`
		echo $field

		if [ "$value" == "word" ]
		then
			parse=`echo $field | sed -E "s/[#]{0,}([A-Za-z.-]{1,})[,]{0,}/\\1/"`
			word="$word $parse"
				
			if [[ $field != *","* ]]
			then
				value=pos
			fi
		elif [ "$value" == "pos" ]
		then
			pos=$field
			value=decl
		elif [ "$value" == "decl" ]
		then
			if [[ "$field" == *"["* ]]
			then
				mod=$field
				value=colon
			else
				decl="$decl $field"
				if [[ "$field" != *"("* ]]
				then
					value=mod
				fi
			fi
		elif [ "$value" == "mod" ]
		then
			mod=$field
			value=colon
		elif [ "$value" == "colon" ] 
		then
			value=def
		elif [ "$value" == "def" ]
		then
			parse=`echo $field | sed -E "s/'//"`
			def="$def $parse"
		fi
	done

	word=`echo $word | sed -E "s/[ ]{0,1}//"` #not sure why but it adds an extra space...

	#echo $word
	add-entry "$word" "$pos" "$decl" "$mod" "$def"

	#echo "$word \t $wtype \t $mod \t $def"
done < dictionary.txt

# TODO progress bar
