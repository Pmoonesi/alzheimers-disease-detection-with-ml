#!/bin/bash

# Specify the directory to search
directory="ADNI"

# Specify the file extension
extension=".nii"

# Count the total number of files
total_files=$(find "$directory" -type f -name "*$extension" | wc -l)

count=0

# Loop through files with the specified extension recursively
while IFS= read -r file; do

    ls | grep '.nii' | xargs -I f rm f
    ls | grep '.mat' | xargs -I f rm f

    name=$(echo $file | cut -d '/' -f6)
    echo $count":"$name
    
    ## skull stripping
    mri_synthstrip -i $file -o temp.nii.gz
    bet temp.nii.gz temp1.nii.gz -f 0.2
    
    ## normalizing
    high=$(fslstats temp1.nii.gz -R | cut -d ' ' -f2)
    fslmaths temp1.nii.gz -div $high temp2.nii.gz

    ## segment
    fast -g -H 0.2 -o subj temp2.nii.gz

    ## clean up the mask
    fslmaths subj_seg_1.nii.gz -fmedian gray_matter_mask.nii.gz

    # mask
    fslmaths temp2.nii.gz -mul gray_matter_mask.nii.gz temp3.nii.gz # changed the seg_2 to seg_1 for gray matter

    ## registration
    # antsRegistrationSyNQuick.sh -d 3 -f template/gray_matter_smooth_75.nii.gz -m temp3.nii.gz -n 10
    flirt -in temp3.nii.gz -ref template/gray_matter_median.nii.gz -out temp4.nii.gz 

    ## save
    cp temp4.nii.gz processed/p_$name.gz
    
    ## increment the counter
    ((count++))

    break

done < <(find "$directory" -type f -name "*$extension" | sort)

# ls | grep '.nii' | xargs -I f rm f
# ls | grep '.mat' | xargs -I f rm f
