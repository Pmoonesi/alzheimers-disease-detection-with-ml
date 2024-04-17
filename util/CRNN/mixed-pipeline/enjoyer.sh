#!/bin/bash

# Temporary file name
fn='intermediate.txt'

# Loop through files with the specified extension recursively
function func {
    file=$1
    name=$(echo $file | cut -d '/' -f2)
    folder=$(echo $name | grep -oP "S\d+\_I\d+")

    mkdir $folder

    ## remove residual skull
    bet $file $folder/temp1.nii.gz -f 0.2
    
    ## normalizing
    high=$(fslstats $folder/temp1.nii.gz -R | cut -d ' ' -f2)
    fslmaths $folder/temp1.nii.gz -div $high $folder/temp2.nii.gz

    ## segment
    fast -g -o $folder/subj $folder/temp2.nii

    # mask
    fslmaths $folder/temp2.nii.gz -mul $folder/subj_seg_1.nii.gz $folder/temp3.nii.gz

    ## registration
    flirt -in $folder/temp3.nii.gz -ref template/gray_matter_median.nii.gz -out $folder/temp4.nii.gz 1>/dev/null 
    # antsRegistrationSyNQuick.sh -d 3 -f template/gray_matter_smooth_75.nii.gz -m $folder/temp3.nii.gz -o $folder/temp4

    ## save
    cp $folder/temp4.nii.gz processed/p_$name
    # cp $folder/temp4_outputWarped.nii.gz processed/p_$name

    ## clean
    rm $file
    rm -rf $folder
}

export -f func


while true; do
    # Check if the intermediate file is empty
    if [ ! -s $fn ]; then
        echo "Intermediate file is empty. Waiting..."
        sleep 30  # Wait for 1 minute
    else
        list_of_files=$(<$fn)
        >$fn
        echo $list_of_files | xargs -n1 | parallel --jobs 4 func
    fi
done
