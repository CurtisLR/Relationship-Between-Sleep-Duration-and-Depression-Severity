Relationship Between Sleep Duration and Depression Severity

Overview
This project investigates the non-linear (quadratic) relationship between sleep duration and depression severity among US adults. Using data from the NHANES (National Health and Nutrition Examination Survey), this econometric analysis explores whether both short and long sleep durations are associated with higher depression scores.

Key Findings
Found a statistically significant U-shaped relationship between sleep duration and depression.
Depression severity (PHQ-9 score) was lowest among adults who sleep approximately 8 hours.
The model controls for physical activity, diet, demographics, and income.

Methodology
Data Source: NHANES Cycle D (2005-2006).
Sample Size: 5,334 observations (after cleaning).
Dependent Variable: Depression Severity (calculated via PHQ-9 screener).
Model: Weighted Multiple Linear Regression with a quadratic term for sleep ('sleep + sleep^2').

Stack
Language: R
Libraries: 'dplyr', 'haven' (for XPT files), 'ggplot2'.
