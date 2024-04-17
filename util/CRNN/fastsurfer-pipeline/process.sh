#!/bin/bash
if [ "$#" -eq 0 ]
  then
    echo "No arguments supplied"
fi


# Specify the directory to search
directory="ADNI"

# Specify the file extension
extension=".nii"

# Function to clean up processed folder
cleanup_processed_folder() {
    rm -rf processed
    mkdir processed
}

cleanup_processed_folder

# Count the total number of files
if [ -z $1 ]; then
  start=1
else
  start=$1
fi

if [ -z $2 ]; then
  end=$(find "$directory" -type f -name "*$extension" | wc -l)
else
  end=$2
fi

echo "start from: "$start
echo "end in: "$end

count=1
total_wanted=$((end - start + 1))
count_total=$start
total_files=$(find "$directory" -type f -name "*$extension" | wc -l)

base_dir=$(pwd)
FASTSURFER_HOME=/content/fastsurfer

# Loop through files with the specified extension recursively
while IFS= read -r file; do

    ls | grep '.nii' | xargs -I f rm f
    ls | grep '.mat' | xargs -I f rm f

    name=$(basename $file)
    img_id=$(echo $name | grep -oP "S\d+\_I\d+")
    subject_id=$(echo $name | grep -oP "\d{3}_S_\d{4}")
    sid=$img_id"_"$subject_id

    echo "("$count_total"/"$total_files") | ("$count"/"$total_wanted"): "$name

    ## run fastsurfer
    bash $FASTSURFER_HOME/run_fastsurfer.sh --fs_license /content/freesurfer/.license \
        --t1 $base_dir/$file --sid $sid --sd $base_dir/fastsurfer_seg --seg_only \
        --parallel --device cuda --viewagg_device cuda --allow_root --threads 2

    ## convert
    # mri_convert fastsurfer_seg/$sid/mri/mask.mgz mask.nii.gz
    /content/freesurfer/bin/mri_convert fastsurfer_seg/$sid/mri/orig_nu.mgz orig.nii.gz
    /content/freesurfer/bin/mri_convert fastsurfer_seg/$sid/mri/aparc.DKTatlas+aseg.deep.mgz aparc.nii.gz

    ## make the mask
    fslmaths aparc.nii.gz -thr 1000 -min 1 gm_mask.nii

    ## mask
    fslmaths orig.nii.gz -mul gm_mask.nii intensity_map.nii

    ## registration
    # antsRegistrationSyNQuick.sh -d 3 -f template/white_matter_temp.nii.gz -m temp3.nii.gz -n 10
    flirt -in intensity_map.nii -ref template/MNI_GM_intensity_median.nii.gz -out final.nii

    ## save
    /content/freesurfer/bin/mri_convert final.nii processed/p_$name.gz

    ## clean 
    rm -rf fastsurfer_seg/*

    ((count++))
    ((count_total++))

done < <(find "$directory" -type f -name "*$extension" | sort | head -n $end | tail -n $total_wanted)

tar -czf "processed_"$start"_"$end".tar.gz" processed
cp "processed_"$start"_"$end".tar.gz" /content/drive/MyDrive/Data/ADNI1-3YR-Residual/ADNI-GM/

ls | grep '.nii' | xargs -I f rm f
ls | grep '.mat' | xargs -I f rm f
