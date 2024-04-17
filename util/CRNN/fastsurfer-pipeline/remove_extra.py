import pandas as pd
import os
import re
import glob

downloaded_df = pd.read_csv('ADNI1_Complete_3Yr_1.5T_4_09_2024.csv').query('Description in ["MPR-R; GradWarp; B1 Correction; N3; Scaled", "MPR; GradWarp; B1 Correction; N3; Scaled"]').query('Visit in ["sc", "m06", "m12", "m18", "m24", "m36"]')

IDs = set(downloaded_df['Image Data ID'])

pattern = r'I\d+'

files = glob.glob('ADNI/**/*.nii', recursive=True)

def is_included(path):
    match = re.search(pattern, path)
    if match:
        image_id = match.group(0)
        # one corrupted image
        if image_id == "I34114":
        	return False
        return image_id in IDs
    else:
        return False
    
excluded_files = list(filter(lambda x: not is_included(x), files))

print(len(files))
print(len(excluded_files))

for file in excluded_files:
    os.remove(file)
