

### add timestamp before printing
echo_time() {
    date +"%R $*"
}
echo_time "download .fa files"


### outputs number of rows and columns of a file (specify FS separator)
awk 'BEGIN{FS="\t"}END{print "COLUMN NO: "NF " ROWS NO: "NR}' file


### output only rows which lie between linenumbers
awk 'NR >= 400 && NR <= 405' file


### compare two files if identical
cmp --silent file1 file2 && echo '### SUCCESS: identical files ###' || echo '### WARNING: different files ###'


### compare if identical files in subfolder (first slow line by line, second only name comparison)
diff -qr dir1 dir2
diff <(ls -1a dir1) <(ls -1a dir2)

### get disk usage info per user
du -shc /home/* 2>&1 | grep -v '^du:'


### get system information
inxi -Fxz


### create md5 hash for all files with a certain name
find . -type f -name '*.bam' -execdir sh -c 'md5sum "$1" > "$1.md5"' _ {} \;





