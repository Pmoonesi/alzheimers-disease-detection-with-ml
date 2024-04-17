#!/bin/bash

# Temporary file name
fn='intermediate.txt'
dn='temp'

mkdir $dn

# Specify the directory to search
directory="ADNI"

# Specify the file extension
extension=".nii"

base_dir=$(pwd)

# Loop through files with the specified extension recursively
while IFS= read -r file; do

    name=$(basename $file)
    img_id=$(echo $name | grep -oP "S\d+\_I\d+")
    subject_id=$(echo $name | grep -oP "\d{3}_S_\d{4}")
    sid=$subject_id"_"$img_id

    echo $name
    
    ## skull stripping
    /home/parham/Programs/FastSurfer/run_fastsurfer.sh --fs_license /usr/local/freesurfer/license.txt \
        --t1 $base_dir/$file --sid $sid --sd $base_dir/fastsurfer_seg --seg_only \
        --parallel --device cuda --viewagg_device cuda --threads 6 1>/dev/null
    
    ## write in fifo continuously
    echo $sid >> $fn

done < <(find "$directory" -type f -name "*$extension" | sort)

