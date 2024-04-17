#!/bin/bash

# Specify the directory to search
directory="ADNI"

# Specify the file extension
extension=".nii"

# Define the desired number of parts
desired_parts=5

# Define the directory to copy zipped files
destination_directory="/content/drive/MyDrive/Data/ADNI1-1YR-1.5T/processed/"

# Function to clean up processed folder
cleanup_processed_folder() {
    rm -rf processed/*
}

# Count the total number of files
total_files=$(find "$directory" -type f -name "*$extension" | wc -l)

# Calculate the number of files per part
files_per_part=$((total_files / desired_parts))
remainder=$((total_files % desired_parts))

count=0
segment=0

existing_parts=$(ls "$destination_directory"processed"$segment"_part_*.zip 2>/dev/null | wc -l)
part=$((existing_parts + 1))
skip=$((existing_parts * files_per_part))

# Loop through files with the specified extension recursively
while IFS= read -r file; do
    
    # Increment the counter
    ((count++))

    if [ $count -le $skip ]; then
        continue
    fi

    name=$(echo $file | cut -d '/' -f6)
    echo $count":"$name
    
    ## skull stripping
    python /content/freesurfer/python/scripts/mri_synthstrip -i $file -o temp.nii && bet temp.nii skull.nii -f 0.4
    
    ## normalizing
    high=$(fslstats temp.nii -R | cut -d ' ' -f2)
    fslmaths skull.nii -div $high temp2.nii

    ## registering
    flirt -in temp2.nii -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -out temp3.nii

    ## save
    cp temp3.nii processed/final_$name

    # Check if the count reaches the files per part limit
    if [ $((count % files_per_part)) -eq 0 ]; then
        # Zip the processed files
        tar -czf processed"$segment"_part_"$part".zip processed
        
        # Copy the zipped file to the destination directory
        cp processed"$segment"_part_"$part".zip $destination_directory
        
        # Clean up processed folder
        cleanup_processed_folder
        
        # Increment the part number
        ((part++))
    fi
    
done < <(find "$directory" -type f -name "*$extension")

# Zip and copy the remaining processed files if any
if [ $remainder -ne 0 ]; then
    # Zip the remaining processed files
    tar -czf processed"$segment"_part_"$part".zip processed
    
    # Copy the zipped file to the destination directory
    cp processed"$segment"_part_"$part".zip $destination_directory
    
    # Clean up processed folder
    cleanup_processed_folder
fi
