# `ToFFi Toolbox`

This repository contains the software related to the publication [ToFFi - Toolbox for frequency-based fingerprinting of brain signals](https://doi.org/10.1016/j.neucom.2023.126236), published 24th April 2023 in Neurocomputing journal, by Michał Konrad Komorowski ([@micholeodon](https://github.com/micholeodon)) from Neurocognitive Laboratory at Nicolaus Copernicus University, Torun, Poland, and his collaborators.

## Abstract

*Spectral Fingerprints* (SFs) are unique power spectra signatures of human brain regions of interest (ROIs, [Keitel & Gross, 2016](https://doi.org/10.1371/journal.pbio.1002498)). SFs allow for accurate ROI identification and can serve as biomarkers of differences exhibited by non-neurotypical groups. At present, there are no open-source, versatile tools to perform Spectral Fingerprinting. 

We have filled this gap by creating a modular, highly-configurable MATLAB **Toolbox for Frequency-based Fingerprinting (ToFFi)**. It can transform MEG/EEG signals into unique spectral representations using ROIs provided by anatomical (AAL, Desikan-Killiany), functional (Schaefer), or other custom volumetric brain parcellations. Toolbox design supports reproducibility and parallel computations.


# Prerequisites

  * **MATLAB** (version R2021a or newer)
  * **FieldTrip** toolbox (version 20210816 or newer)

The following toolboxes need to be installed alongside MATLAB:
  * Signal Processing Toolbox,
  * Statistics and Machine Learning Toolbox,
  * Parallel Computing Toolbox.


# Installation

1. Clone, or download this repository as a `.zip` file and unpack.
2. The ToFFi toolbox is ready to use.

# Full documentation

The full documentation of the ToFFi Toolbox can be found [here](ToFFi_Toolbox-20211013/docs/ToFFi_Manual.pdf).


# Source Lines of Code (SLOC)

394 text files.
374 unique files.                                          
144 files ignored.

github.com/AlDanial/cloc v 1.82  T=0.36 s (1006.2 files/s, 81665.7 lines/s)


| Language                 | files            | blank         | comment       | code       |
| ------------------------ | ---------------: | ------------: | ------------: | ---------: |
| MATLAB                   |       243        |   1952        |   3709        |       6894 |
| HTML                     |        91        |   2571        |   4531        |       6609 |
| Bourne Shell             |         9        |    433        |    375        |       1670 |
| Markdown                 |         1        |     11        |      0        |        108 |
| Bourne Again Shell       |        14        |     42        |    208        |         84 |
| MUMPS                    |         2        |      3        |      0        |         16 |
| **SUM:**                 |       **360**    |   **5012**    |   **8823**    |  **15381** |



# License

This code is licensed under the GNU LESSER GENERAL PUBLIC LICENSE, version 2.1.
