# Splits

In this folder, you're supposed to place the split CSVs for both of the datasets.
For each one, there should be three different CSVs; One that contains all of the subjects data, and the other two are a split of the first one into tune and test splits.

You should apply for the premission to access the CSV's the same way you request access to the data. For that, read [here](../data/adni.md).

After you've downloaded the CSV's for your data, you should split the CSV using separate sets of subjects to avoid data leakage.

Your final split structure should be like:
```
splits/
│
├── ADNI1/
│ ├── ADNI1_all.csv/
│ ├── ADNI1_test.csv/
│ └── ADNI1_tune.csv/ 
│
├── ADNI3/
│ ├── ADNI3_all.csv/
│ ├── ADNI3_test.csv/
│ └── ADNI3_tune.csv/ 
│
└── README.md

```