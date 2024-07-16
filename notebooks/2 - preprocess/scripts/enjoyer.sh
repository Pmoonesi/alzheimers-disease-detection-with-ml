#!/bin/bash

# Temporary file name
fn='intermediate.txt'

mkdir processed 2>/dev/null
mkdir processed_stats 2>/dev/null
mkdir processed_gm 2>/dev/null

# Loop through files with the specified extension recursively
function func {
    sid=$1
    folder=$sid

    mkdir $folder
    
    ## convert
    mri_convert fastsurfer_seg/$sid/mri/mask.mgz $folder/mask.nii.gz 1>/dev/null
    mri_convert fastsurfer_seg/$sid/mri/orig_nu.mgz $folder/orig_nu.nii.gz 1>/dev/null
    mri_convert fastsurfer_seg/$sid/mri/aparc.DKTatlas+aseg.deep.mgz $folder/aparc.nii.gz 1>/dev/null

    ## mask
    fslmaths $folder/orig_nu.nii.gz -mul $folder/mask.nii.gz $folder/masked.nii.gz 1>/dev/null

    ## registration
    flirt -init best_transform.mat  -omat $folder/affine.mat -in $folder/masked.nii.gz -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -out $folder/final.nii.gz 

    ## save
    mkdir -p processed_stats/$sid
    mkdir -p processed_gm/$sid
    
    cp $folder/final.nii.gz processed/p_$sid.nii.gz
    cp $folder/orig_nu.nii.gz processed_gm/$sid/orig_nu.nii.gz
    cp $folder/aparc.nii.gz processed_gm/$sid/aparc.nii.gz
    cp fastsurfer_seg/$sid/stats/aseg+DKT.stats processed_stats/$sid/aseg+DKT.stats
    cp fastsurfer_seg/$sid/stats/cerebellum.CerebNet.stats processed_stats/$sid/cerebellum.CerebNet.stats
    # cp $folder/affine.mat processed_stats/$sid/affine.mat
    
    ## cleanup
    rm -rf $folder
    rm -rf fastsurfer_seg/$sid
}

export -f func


while true; do
    if [ ! -s $fn ]; then
        echo "Intermediate file is empty. Waiting..."
        sleep 780  # Wait for 6 * 2 = 12 minutes (+1)
    else
        list_of_files=$(<$fn)
        echo "processing "$(echo $list_of_files | xargs -n1 | wc -l)" files"
        >$fn
        echo $list_of_files | xargs -n1 | parallel --jobs 4 func
    fi
done
