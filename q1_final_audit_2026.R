install.packages("tidyverse")
library(tidyverse)

#audit
#setwd()
q1_data_2026 = read_csv("data/2026_q1.csv")


# Clean -------------------------------------------------------------------
#perform the 3 checks to ensure data is accurate and readable
#I expect to see 54 rows and 4 columns
dim(q1_data_2026)
names(q1_data_2026)
summary(q1_data_2026)

q1_data_2026 <- q1_data_2026 |>
  mutate(days_to_close_clean = na_if(days_to_close, -1))


# Analyze -----------------------------------------------------------------
#max_days_open is set to 30 since closing a claim within 30 days is the company standard. Anything beyond is late.
 max_days_open <- 30

q1_data_2026 <- q1_data_2026 |> 
  mutate(late = days_to_close_clean > max_days_open, na.rm = TRUE)

q1_summary_2026 = q1_data_2026 |> 
  group_by(claim_type) |> 
  summarise(
    n           = n(), 
    claims_open = sum(is.na(days_to_close_clean)),
    mean_days   = mean(days_to_close_clean, na.rm = TRUE), 
    pct_late    = mean(late, na.rm = TRUE)
    )

q1_summary_2026

#save
write_csv(q1_summary_2026, "q1_audit_final_2026.csv")
