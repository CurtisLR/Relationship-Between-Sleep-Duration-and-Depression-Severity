install.packages("dplyr")
install.packages("haven")
install.packages("ggplot2")
library(dplyr)
library(haven)
library(ggplot2)


depression <- read_xpt("data/DPQ_D.xpt")
sleep <- read_xpt("data/SLQ_D.xpt")
exercise <- read_xpt("data/PAQ_D.xpt")
demographics <- read_xpt("data/DEMO_D.xpt")
diet <- read_xpt("data/DBQ_D.xpt")

#Join segments into one dataset
df <- demographics %>%
  inner_join(depression, by = "SEQN") %>%
  inner_join(sleep, by = "SEQN") %>%
  inner_join(exercise, by = "SEQN") %>%
  inner_join(diet, by = "SEQN")

#Obtain phq_9 which will be depression severity
df <- df %>%
  mutate(
    phq9 = DPQ010 + DPQ020 + DPQ030 + DPQ040 +
      DPQ050 + DPQ060 + DPQ070 + DPQ080 + DPQ090,
    depressed = phq9 >= 10
  )

#Certain codes mean that respondent refused to answer
#So I am replacing them with NA using if_else statements
df <- df %>%
  mutate(
    SLD010H = if_else(SLD010H %in% c(77, 99), NA, SLD010H),
    PAQ180 = if_else(PAQ180 %in% 1:4, PAQ180, NA),
    INDFMINC = if_else(INDFMINC %in% c(77,99), NA, INDFMINC), #documentation specifies that there are some 77 and 99 responses for this question
    DBQ700 = if_else(DBQ700 %in% c(7, 9), NA, DBQ700),
    sleeping_hours_sq = SLD010H^2
  )

#Select and rename variables 
df <- df %>%
  select(
    sleeping_hours = SLD010H, #IV
    sleeping_hours_sq = sleeping_hours_sq, #IV
    dep_severity = phq9, #DP
    phys_act = PAQ180,
    diet = DBQ700,
    age = RIDAGEYR,
    gender = RIAGENDR,
    race = RIDRETH1,
    income = INDFMINC,
    weights = WTINT2YR
  )

#Turn categorical variables into factors instead of numeric
df <- df %>%
  mutate(
    gender = factor(gender, levels = c(1, 2), labels = c("Male", "Female")),
    race = factor(race),
    phys_act = factor(phys_act),
    diet = factor(diet),
    income = factor(income)
  )
#Run regression
model <- lm(
  dep_severity ~ sleeping_hours + sleeping_hours_sq +
    phys_act + diet + age + gender + race + income,
  data = df,
  weights = weights
)

summary(model)

ggplot(df, aes(x = sleeping_hours, y = dep_severity)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm",
              formula = y ~ x + I(x^2),
              color = "blue") +
  labs(
    x = "Sleep hours",
    y = "Depression Severity",
    title = "Sleeping Duration and Depression Relationship"
  )

