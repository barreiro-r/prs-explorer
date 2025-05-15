# Polygenic Risk Score Explorer

[![Launch PRS Dashboard](https://img.shields.io/badge/R%20Shiny-PRS%20explorer-6746BB?style=for-the-badge&logo=r&logoColor=white)](https://barreiro-r.shinyapps.io/prs-explorer/)
[![Launch PRS Dashboard](https://img.shields.io/badge/Serveless-PRS%20explorer-6746BB?style=for-the-badge&logo=serverless&logoColor=white)](https://barreiro-r.github.io/prs-explorer/)

> [!NOTE]  
> R Shiny (shynyapps.io) has a limitation of parallel users and users by month. Serveless version may take a while do load. No mobile-friendly version available (sadly).


This project features an interactive dashboard designed to help users understand how various factors influence Polygenic Risk Score (PRS) metrics. Using simulated data, the dashboard allows for the exploration of the impact of:

**Sample Size:** Observe how the number of individuals in control and case groups affects PRS metric stability and reliability.


**Prevalence:** Investigate how the proportion of cases in the population (disease prevalence) influences the performance and interpretation of PRS.

**Mean and Standard Deviation (SD) of PRS:** Analyze how the distribution of polygenic risk scores in both case and control groups correlates with various PRS metrics.

## Dashboard Overview

![A dashboard interface showing various plots and controls. Key elements visible include "Data Distribution" showing two bell curves for low-risk and high-risk samples, "Odds Ratio by Quintile", "Prevalence by Quantile", "ROC curve", and input parameters for "Samples", "PRS Mean", and "PRS SD" for both "CONTROLS" and "CASES"](imgs/dashpreview.png)


The dashboard visualizes several key aspects of PRS data and performance:

* **Data Distribution:** Displays the distribution of polygenic risk scores for simulated case and control groups. Users can see how changes in mean and SD for each group alter these distributions.
* **Odds Ratio by Quintile:** Shows the odds ratio for different quintiles of the PRS distribution, illustrating the risk stratification capability.
* **Prevalence by Quantile:** Visualizes the prevalence of the condition across different quantiles of the PRS, highlighting how risk increases with higher scores.
* **Receiver Operating Characteristic (ROC) Curve:** Presents the ROC curve and the Area Under the Curve (AUC) to assess the discriminative ability of the PRS.
* **Key Metrics:** Displays calculated metrics such as:
    * t-test p-value
    * Nagelkerke's $R^2$
    * OR per SD (Odds Ratio per Standard Deviation)

## Purpose and Motivation

The primary goal of this project is to provide an educational tool for researchers, students, and anyone interested in understanding the nuances of polygenic risk scores. By allowing users to manipulate key variables and observe their effects in a simulated environment, this dashboard aims to clarify:

* The importance of adequate sample size in PRS studies.
* How disease prevalence can affect the interpretation of PRS results and their clinical utility.

## How it was made

The dashboad was made interly using R and R Shiny. Many packages were used:

- 📦 {tidyverse} Everything;
- 📦 {ggtext} Markdown on plots;
- 📦 {scales} Scales;
- 📦 {pROC} ROC curve and AUROC;
- 📦 {ggiraph} Interactivity to plots (removed in github pages);
- 📦 {grid} Gradient filling;
- 📦 {liveshiny} For serverless and hosting in GitHub pages;



## License

This project is licensed under the GPL-3.0 license License - see the [LICENSE.md](LICENSE.md) file for details.

## References

- Brockman, D. G., Petronio, L., Dron, J. S., Kwon, B. C., Vosburg, T., Nip, L., Tang, A., O’Reilly, M., Lennon, N., Wong, B., Ng, K., Huang, K. H., Fahed, A. C., & Khera, A. V. (2021). **Design and user experience testing of a polygenic score report: a qualitative study of prospective users.** *BMC Medical Genomics*, 14(1). https://doi.org/10.1186/s12920-021-01056-0  
- Choi, S. W., Mak, T. S., & O’Reilly, P. F. (2020). **Tutorial: a guide to performing polygenic risk score analyses.** *Nature Protocols*, 15(9), 2759–2772. https://doi.org/10.1038/s41596-020-0353-1  
- Khera, A. V., Chaffin, M., Aragam, K. G., Haas, M. E., Roselli, C., Choi, S. H., Natarajan, P., Lander, E. S., Lubitz, S. A., Ellinor, P. T., & Kathiresan, S. (2018). **Genome-wide polygenic scores for common diseases identify individuals with risk equivalent to monogenic mutations.** *Nature Genetics*, 50(9), 1219–1224. https://doi.org/10.1038/s41588-018-0183-z  
- Kumuthini, J., Zick, B., Balasopoulou, A., Chalikiopoulou, C., Dandara, C., El-Kamah, G., Findley, L., Katsila, T., Li, R., Maceda, E. B., Monye, H., Rada, G., Thong, M., Wanigasekera, T., Kennel, H., Marimuthu, V., Williams, M. S., Al-Mulla, F., & Abramowicz, M. (2022). **The clinical utility of polygenic risk scores in genomic medicine practices: a systematic review.** *Human Genetics*, 141(11), 1697–1704. https://doi.org/10.1007/s00439-022-02452-x  
- Sud, A., Kinnersley, B., & Houlston, R. S. (2017). **Genome-wide association studies of cancer: current insights and future perspectives.** *Nature Reviews Cancer*, 17(11), 692–704. https://doi.org/10.1038/nrc.2017.82  
- Torkamani, A., Wineinger, N. E., & Topol, E. J. (2018). **The personal and clinical utility of polygenic risk scores.** *Nature Reviews Genetics*, 19(9), 581–590. https://doi.org/10.1038/s41576-018-0018-x  
- Wang, Y., Tsuo, K., Kanai, M., Neale, B. M., & Martin, A. R. (2022). **Challenges and opportunities for developing more generalizable polygenic risk scores.** *Annual Review of Biomedical Data Science*, 5(1), 293–320. https://doi.org/10.1146/annurev-biodatasci-111721-074830