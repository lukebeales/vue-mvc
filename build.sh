#!/bin/bash

# all the different sections to include files from
sections=("headers" "helpers" "views" "models" "controllers" "routes")

# copy the index file to ./build/index.html
rm -r -f ./build/*
cp -av ./app/index.html ./build

# loop through all the sections
for section in "${sections[@]}"
do

	mkdir -p ./build/${section} && echo "" > ./build/${section}/.compiled

	# now we're going to add all the custom app includes for this section
	if [ -d "./app/${section}" ]; then

		echo "reading ./app/${section}..."

		# get a list of all files in the current folder that DO NOT start with a dot
		files=( $(ls -1 ./app/${section}) )

		# for each file...
		for file in "${files[@]}"
		do

			echo "- reading in ${file}..."

			# cat it to a temporary file starting with a dot to hide it.
			echo "" >> ./build/${section}/.compiled
			echo "<!-- ==================== -->" >> ./build/${section}/.compiled
			echo "<!-- ${file} -->" >> ./build/${section}/.compiled
			echo "<!-- ==================== -->" >> ./build/${section}/.compiled
			cat ./app/${section}/${file} >> ./build/${section}/.compiled
			echo "" >> ./build/${section}/.compiled
		done

	fi



	# now sed the dot file in place of {{ libraries }} or whatever folder we're looking at in to build/index.html
	echo "merging ./build/${section}/.compiled in to ./build/index.html"
	sed -i -e "/{{ ${section} }}/r./build/${section}/.compiled" -e "s///" ./build/index.html


	# now remove the section folder
	rm -r -f ./build/${section}

done

