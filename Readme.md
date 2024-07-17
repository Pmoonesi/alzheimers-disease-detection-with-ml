# Alzheimer’s disease detection using machine learning

## Abstract

Alzheimer’s disease is one of the most important and complex neurodegenerative diseases,
and early and accurate diagnosis can prevent its rapid progression. The aim of this research is
to propose and evaluate various machine learning and deep learning models for Alzheimer’s
disease detection using MRI images. In this study, three different approaches were employed
for MRI image classification. In the first method, classical machine learning algorithms in-
cluding Support Vector Machine (SVM), Random Forest (RF), and Multilayer Perceptron
(MLP) were used. The second method utilized three-dimensional Convolutional Neural Net-
works (CNNs) to extract spatial features from images, while the third method combined three-
dimensional CNNs with Recurrent Neural Networks (RNNs) to extract both spatial and tem-
poral features. Evaluation results indicate that using recurrent networks along with convolu-
tional networks outperforms three-dimensional CNNs and classical methods. Additionally,
significant improvement in model accuracy was achieved by employing data augmentation
techniques. However, dropout and transfer learning methods negatively affected the models’
performance. In conclusion, this research demonstrates that advanced deep learning methods
can enhance the accuracy of Alzheimer’s disease detection and suggests further investigation
is needed to develop effective strategies against overfitting. The findings of this study could
contribute to the development of more precise tools for early diagnosis of Alzheimer’s disease
and improving patients’ quality of life.

## Table of Contents
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Results](#results)
<!-- - [Acknowledgements](#acknowledgements) -->
<!-- - [License](#license) -->
<!-- - [Usage](#usage) -->
<!-- - [Configuration](#configuration) -->
<!-- - [Contributing](#contributing) -->

## Installation

You can follow the below instructions to be able to use each section's scripts and notebooks:

- [Data Acquisition](#data-acquisition-requirements)
- [Preprocess](#preprocess-requirements)
- [Training](#training-requirements)

### Data Acquisition Requirements

We need to install selenium package:

```shell
pip install selenium
```

In cases where we are running our acquisition script on colab sessions, we need some extra actions to configure chrome drivers, we can use the following script in those situations instead:

```shell
bash "notebooks/1 - data-acquisition/setup.sh"
```

### Preprocess Requirements

Preprocessing depends on three dependent frameworks so we need to install each according to their instructions:

- To install [FastSurfer](https://github.com/Deep-MI/FastSurfer) you can visit [here](https://github.com/Deep-MI/FastSurfer/blob/dev/doc/overview/INSTALL.md).

- To install [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSL) you can visit [here](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation).

- To install [FreeSurfer](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferWiki) you can visit [here](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall).

### Training Requirements

In all of the training sections, we need numpy, pandas and scikit-learn libraries. We can install them using the following command:

```shell
pip install numpy pandas scikit-learn
```

We also need to make sure we have <ins>cuda enabled</ins> pytorch installed on our devices. To do that, you can visit [here](https://pytorch.org/).

## Project Structure

```
root/
│
├── data/ # guide to request for access to the datasets
│ ├── adni.md/
│ ├── oasis.md/
│ └── ppmi.md/ 
│
├── notebooks/ # notebooks used to prepare and execute mentioned algorithms
│ ├── 1 - data-acquisition/ 
│ ├── 2 - preprocess/ 
│ ├── 3 - classic-methods/ 
│ ├── 4 - convolutional-neural-networks/ 
│ └── 5 - recurrent-neural-networks/
│
├── splits/ # CSVs containing tune and test splits
│ ├── ADNI1/ 
│ └── ADNI3/ 
│
├── reports/ # Results and outputs
│ ├── 3 - classic-methods/
│ ├── 4 - convolutional-neural-networks/
│ ├── 5 - recurrent-neural-networks/
│ └── results.md
│
├── util/ # utility scripts and extra
│
└── README.md

```

## Results

For detailed results and analysis, please refer to the [results](./reports/results.md).

<!-- ## Acknowledgements -->

<!-- ## License -->

<!-- ## Usage -->

<!-- ## Configuration -->

<!-- ## Contributing -->