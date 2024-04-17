#!/bin/bash

# Specify the directory to search
directory="ADNI"

# Specify the file extension
extension=".nii"

lower_bound=1
uppder_bound=100

count=0

# Loop through files with the specified extension recursively
while IFS= read -r file; do
    
    # Increment the counter
    ((count++))
    
    name=$(echo $file | cut -d '/' -f6)
    
    echo $count":"$name

    if [ $count -ge $lower_bound ] && [ $count -le $uppder_bound ]; then
        ## skull stripping
        # bet $file temp.nii -R -f 0.35
        python /content/freesurfer/python/scripts/mri_synthstrip -i $file -o temp.nii && bet temp.nii skull.nii -f 0.4
        
        ## normalizing
        high=$(fslstats temp.nii -R | cut -d ' ' -f2)
        fslmaths skull.nii -div $high temp2.nii

        ## registering
        flirt -in temp2.nii -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -out temp3.nii

        ## save
        cp temp3.nii processed/final_$name
    fi
    
    #Check if the counter exceeds the uppder bound
    if [ $count -ge $uppder_bound ]; then
        echo "Processed "$uppder_bound" files, exiting loop."
        break
    fi

done < <(find "$directory" -type f -name "*$extension")
