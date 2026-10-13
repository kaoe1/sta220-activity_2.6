install.packages("tidyverse")
library(tidyverse)

#audit
#setwd()
q1_data_2025 = read_csv("data/2025_q1.csv")


# Clean -------------------------------------------------------------------
#perform the 3 checks to ensure data is accurate and readable
#I expect to see 48 rows and 4 columns
dim(q1_data_2025)
names(q1_data_2025)
summary(q1_data_2025)

q1_data_2025 <- q1_data_2025 |>
  mutate(days_to_close_clean = na_if(days_to_close, -1))


# Analyze -----------------------------------------------------------------
#max_days_open is set to 30 since closing a claim within 30 days is the company standard. Anything beyond is late.
 max_days_open <- 30

q1_data_2025 <- q1_data_2025 |> 
  mutate(late = days_to_close_clean > max_days_open, na.rm = TRUE)

q1_summary_2025 = q1_data_2025 |> 
  group_by(claim_type) |> 
  summarise(
    n           = n(), 
    claims_open = sum(is.na(days_to_close_clean)),
    mean_days   = mean(days_to_close_clean, na.rm = TRUE), 
    pct_late    = mean(late, na.rm = TRUE)
    )

q1_summary_2025

#save
write_csv(q1_summary_2025, "q1_audit_final_2025.csv")
