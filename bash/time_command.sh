#!/bin/bash

cd $PWD
touch command_timed.txt

for num_cores in 1 2 3 ; do
	echo $num_cores

	echo $num_cores >> command_timed.txt
	{ time sleep 3 2>1; } 2>> command_timed.txt

	echo "#####################" >> command_timed.txt
done

rm 1

