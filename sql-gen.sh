#!/bin/bash

pword=$1

function add-entry {
	word=$1
	pos=$2
	decl=$3
	mod=$4
	def=$5
	mysql -u techhound -p$pword -D dict -e "INSERT INTO latin (id, word, part, declension, modifier, definition) VALUES (NULL, '$word', '$pos', '$decl', '$mod', '$def');"
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

		#if :: - do nothing, value=def
		#if [*] - value=mod
		#if *, - value=word

		if [ "$value" == "word" ]
		then
			parse=`echo $field | sed -E "s/[#]{0,}([A-Za-z.-]{1,})[,]{0,}/\\1/"`
			# odd behavior note: with [A-Za-z.] instead, it still keeps -, entries, AND keeps the ,
			word="$word $parse"
				
			if [[ $field != *","* ]]
			then
				value=pos
			fi
		elif [ "$value" == "pos" ]
		then
			pos=$field
			value=decl
		fi
	done

	#echo $word
	add-entry "$word" "$pos" 'test' 'test' 'test'

	#echo "$word \t $wtype \t $mod \t $def"
	# TODO set empy vals to NULL
	# add-entry $word $wtype $mod $def
done < dictionary.txt

# TODO progress bar
# TODO prompt for user/pass
