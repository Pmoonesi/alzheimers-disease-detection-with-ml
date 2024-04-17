#!/bin/bash

# Temporary file name
fn='intermediate.txt'

mkdir processed

# Loop through files with the specified extension recursively
function func {
    sid=$1
    folder=$sid

    mkdir $folder
    
    ## convert
    # mri_convert fastsurfer_seg/$sid/mri/mask.mgz mask.nii.gz
    mri_convert fastsurfer_seg/$sid/mri/orig_nu.mgz $folder/orig.nii.gz 1>/dev/null
    mri_convert fastsurfer_seg/$sid/mri/aparc.DKTatlas+aseg.deep.mgz $folder/aparc.nii.gz 1>/dev/null

    ## make the mask
    fslmaths $folder/aparc.nii.gz -thr 1000 -min 1 $folder/gm_mask.nii.gz

    ## mask
    fslmaths $folder/orig.nii.gz -mul $folder/gm_mask.nii.gz $folder/intensity_map.nii.gz

    ## registration
    # antsRegistrationSyNQuick.sh -d 3 -f template/white_matter_temp.nii.gz -m temp3.nii.gz -n 10
    flirt -in $folder/intensity_map.nii.gz -ref template/MNI_GM_intensity_median -out $folder/final.nii.gz 1>/dev/null

    ## save
    cp $folder/final.nii.gz processed/p_$sid.nii.gz

    ## cleanup
    rm -rf $folder
    rm -rf fastsurfer_seg/$sid
}

export -f func


while true; do
    # Check if the intermediate file is empty
    if [ ! -s $fn ]; then
        echo "Intermediate file is empty. Waiting..."
        sleep 360  # Wait for 6 minutes
    else
        list_of_files=$(<$fn)
        echo "processing "$(echo $list_of_files | xargs -n1 | wc -l)" files"
        >$fn
        echo $list_of_files | xargs -n1 | parallel --jobs 2 func
    fi
done
