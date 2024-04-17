#!/bin/bash

# Specify the directory to search
directory="ADNI"

# Specify the file extension
extension=".nii"

# Loop through files with the specified extension recursively
function func {
    file=$1

    base_dir=$(pwd)
    name=$(basename $file)
    img_id=$(echo $name | grep -oP "S\d+\_I\d+")
    subject_id=$(echo $name | grep -oP "\d{3}_S_\d{4}")
    sid=$subject_id"_"$img_id
    folder=$sid

    mkdir $folder

    # run fastsurfer
    /home/parham/Programs/FastSurfer/run_fastsurfer.sh --fs_license /usr/local/freesurfer/license.txt \
        --t1 $base_dir/$file --sid $sid --sd $base_dir/fastsurfer_seg --seg_only \
        --parallel --device cuda --viewagg_device cpu --threads 3 1>/dev/null

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
    cp $folder/final.nii.gz processed/p_$name.gz

    ## cleanup
    rm -rf $folder
    rm -rf fastsurfer_seg/$sid
}

export -f func

find "$directory" -type f -name "*$extension" | sort | parallel --jobs 2 func

