#!/bin/bash

# Temporary file name
fn='intermediate.txt'

# Lockfile path
lkf='intermediate.lock'
touch $lkf

# Specify the directory to search
directory="/home/parham/Desktop/Project/data/adni1"

# Specify the file extension
extension=".nii.gz"

# Already processed 
finished=$(ls processed | wc -l)

echo $finished "files are already processed..."

# Loop through files with the specified extension recursively
function fast_surfer {
    file=$1
    base_dir=$(pwd)
    
    echo $file
    img_id=$(echo $file | grep -oP "(I|D)\d{4,8}")
    subject_id=$(echo $file | grep -oP "\d{3}_S_\d{4}")
    sid=$subject_id"_"$img_id
    
    ## skull stripping
    /home/parham/Programs/FastSurfer/run_fastsurfer.sh --fs_license /usr/local/freesurfer/license.txt \
        --t1 $file --sid $sid --sd $base_dir/fastsurfer_seg --seg_only \
        --parallel --device gpu --viewagg_device gpu --threads 4 1>/dev/null
    
    FASTSURFER_HOME=/content/fastsurfer && bash $FASTSURFER_HOME/run_fastsurfer.sh --t1 $file \
                                      --sd "$(pwd)/fastsurfer_seg" \
                                      --sid $sid \
                                      --seg_only --py python3 \
                                      --allow_root \
                                      --parallel --device cuda --viewagg_device cuda --threads 4
    
    ## write in fifo continuously
    flock $lkf --command "echo $sid >> $fn"
}

export -f fast_surfer
export fn
export lkf

find "$directory" -type f -name "*$extension" | sort | tail -n +$((finished + 1)) | xargs -n1 | parallel --jobs 2 fast_surfer


