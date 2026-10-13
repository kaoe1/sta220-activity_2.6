# reprex-avg_days.R
# Riley: the average days to close looks too low. Can anyone see why?

library(tidyverse)

claims_small <- tribble(
  ~claim_id, ~days_to_close,
  "X-001",               28,
  "X-002",               40,
  "X-003",               -1,
  "X-004",               -1
)

# I expected an average of 34 days, with half of the claims late.
# I get an average of 16.5 days and a share late of 0.25.
claims_small <- claims_small |>
  mutate(days_to_close_clean = na_if(days_to_close, -1))

claims_small |>
  summarize(
    avg_days   = mean(days_to_close_clean, na.rm = TRUE),
    share_late = mean(days_to_close_clean > 30, na.rm = TRUE)
  )
