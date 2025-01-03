
library(tidyverse)

# Load final data (so that `keep` entries are the finalized ones)
all_reviews <- read_csv(here::here("data", "all_reviews.csv"))

# Filter docs with keep = TRUE
selected_reviews <- all_reviews |> 
  filter(keep == TRUE)

# Select necessary variables: rev1, rev2, our_id, doc_link
selected_reviews <- selected_reviews |> 
  dplyr::select(our_id, document_link, reviewer_1, reviewer_2)

# Create new column
selected_reviews <- selected_reviews |> 
  mutate(first_published = NA)

### Write CSV files for each reviewer

catalina <- selected_reviews %>% 
  filter(reviewer_1 == 1 | reviewer_2 == 1) %>% 
  write_csv(
    here::here("data/06-data-cleaning/add-year-first-published/catalina.csv")
  )

federica <- selected_reviews %>% 
  filter(reviewer_1 == 2 | reviewer_2 == 2) %>% 
  write_csv(
    here::here("data/06-data-cleaning/add-year-first-published/federica.csv")
  )

sinem <- selected_reviews %>% 
  filter(reviewer_1 == 3 | reviewer_2 == 3) %>% 
  write_csv(
    here::here("data/06-data-cleaning/add-year-first-published/sinem.csv")
  )

harry <- selected_reviews %>% 
  filter(reviewer_1 == 4 | reviewer_2 == 4) %>% 
  write_csv(
    here::here("data/06-data-cleaning/add-year-first-published/harry.csv")
  )

mine <- selected_reviews %>% 
  filter(reviewer_1 == 5 | reviewer_2 == 5) %>% 
  write_csv(
    here::here("data/06-data-cleaning/add-year-first-published/mine.csv")
  )
