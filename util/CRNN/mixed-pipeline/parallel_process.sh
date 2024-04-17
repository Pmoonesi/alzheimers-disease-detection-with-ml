#!/bin/bash

# Specify the directory to search
directory="ADNI"

# Specify the file extension
extension=".nii"

# Loop through files with the specified extension recursively
function func {
    file=$1

    name=$(echo $file | cut -d '/' -f6)
    folder=$(echo $file | cut -d '/' -f5)

    mkdir $folder

    ## skull stripping
    mri_synthstrip -i $file -o temp.nii.gz 1>/dev/null
    bet temp.nii.gz temp1.nii.gz -f 0.2
    
    ## normalizing
    high=$(fslstats $folder/temp1.nii.gz -R | cut -d ' ' -f2)
    fslmaths $folder/temp1.nii.gz -div $high $folder/temp2.nii.gz

    ## segment
    fast -g -o $folder/subj $folder/temp2.nii

    # mask
    fslmaths $folder/temp2.nii.gz -mul $folder/subj_seg_1.nii.gz $folder/temp3.nii.gz

    ## registration
    # antsRegistrationSyNQuick.sh -d 3 -f template/gray_matter_smooth_75.nii.gz -m temp3.nii.gz -n 10
    flirt -in $folder/temp3.nii.gz -ref template/gray_matter_median.nii.gz -out $folder/temp4.nii.gz 1>/dev/null

    ## save
    cp $folder/temp4.nii.gz processed/p_$name.gz

    rm -rf $folder
}

export -f func

find "$directory" -type f -name "*$extension" | sort | parallel --jobs 3 func

