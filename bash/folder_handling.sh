
# delete all files in all current subdirectorys with .h5 extension
find . -name \*.h5 -type f -delete



# search all subdirectorys and rename them like their folder name + move one up
find mirtrap -type d -not -empty -exec mv \{\}/fw.fastq.gz \{\}_fw.fastq.gz \;



# delete all empty subdirectories
find . -type d -empty -delete











