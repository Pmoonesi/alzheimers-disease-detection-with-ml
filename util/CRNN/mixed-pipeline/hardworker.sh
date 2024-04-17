#!/bin/bash

# Temporary file name
fn='intermediate.txt'
dn='temp'

mkdir $dn

# Specify the directory to search
directory="ADNI"

# Specify the file extension
extension=".nii"

# Loop through files with the specified extension recursively
while IFS= read -r file; do

    name=$(echo $file | cut -d '/' -f6)
    echo $name
    
    ## skull stripping
    mri_synthstrip -i $file -o $dn/$name.gz 1>/dev/null
    
    ## write in fifo continuously
    echo "$dn/$name.gz" >> $fn

done < <(find "$directory" -type f -name "*$extension" | sort)

