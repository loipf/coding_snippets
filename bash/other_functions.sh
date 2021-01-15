


### add timestamp before printing
echo_time() {
    date +"%R $*"
}

echo_time "download .fa files"





### outputs number of rows and columns of a file (specify FS separator)
awk 'BEGIN{FS="\t"}END{print "COLUMN NO: "NF " ROWS NO: "NR}' file


### output only rows which lie between linenumbers
awk 'NR >= 400 && NR <= 405' file


