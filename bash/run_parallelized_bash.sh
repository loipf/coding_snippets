#!/bin/bash

READ_DIR='./reads_mapped/'
OUTPUT_DIR='./read_coverage/results_wes'

### get all folders in READ_DIR
sample_list=($(find $READ_DIR -maxdepth 1 -type d | xargs -n 1 basename | tail -n +2))
#sample_list=('A2' 'A3')


calc_cov(){
   sample_id=$1
   echo "### starting: "$sample_id
   
   mkdir -p $OUTPUT_DIR"/"$sample_id
   cd $OUTPUT_DIR"/"$sample_id
   
   ~/tools/mosdepth_d4 --d4 -t 4 --fast-mode --no-per-base $sample_id $READ_DIR/$sample_id/$sample_id'.bam'
   
   echo "### finished: "$sample_id
}




N=16

for sample_id in "${sample_list[@]}"; do 
    (
      calc_cov "$sample_id"
    ) &

    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done
wait

echo "script finished"
   








