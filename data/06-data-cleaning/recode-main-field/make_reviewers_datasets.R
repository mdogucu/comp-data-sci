
library(tidyverse)

# Load final data (so that `keep` entries are the finalized ones)
all_reviews <- read_csv(here::here("data", "all_reviews.csv"))

# Filter docs with keep = TRUE
reviews <- all_reviews |> 
  filter(keep == TRUE)

# Select necessary variables
reviews <- reviews |> 
  dplyr::select(our_id, document_link, 
                reviewer_1, reviewer_2,
                content_area)

# Create new columns
reviews <- reviews |> 
  mutate(audience_discipline = NA,
         reason_audience_discipline = NA,
         data_science_topics = NA, 
         reason_data_science_topics = NA, 
         observational_unit = NA, 
         reason_observational_unit = NA,
         department = NA,
         reason_department = NA)

### Assign all papers to deadlines
reviewer_names <- c("catalina", "federica", "sinem", "harry", "mine")
data_directory <- here::here("data", "06-data-cleaning", 
                             "recode-main-field")
## These publications had already been reviewed
batch_0 <- c("Doudesis_2022_data_science", "Takemura_2018_new_era", 
             "Rao_2018_milo", "Zhang_2020_self", "Hazzan_2021_journal", 
             "Romney_2019_curriculum", "Betz_2020_next_wave", 
             "Belloum_2019_bridging", "Bhavya_2020_collective_development", 
             "Fisler_2022_datacentricity_rethinking", 
             "Kross_2019_practitioners_teaching", 
             "Bile_2020_comparative_study", "Hicks_2019_guide", 
             "Bhavya_2021_scaling_up", "Song_2016_big_data")

deadlines <- c("Oct 27", "Nov 3", "Nov 10")
reviews$deadline = NA
reviews_new <- tibble()


for (r1 in 1:4) {
  
  for (r2 in (r1+1):5){
    
    reviews_r1_r2 <- reviews |> 
      filter(reviewer_1 %in% c(r1, r2) & reviewer_2 %in% c(r1, r2)) 
    
    pubs_tot <- nrow(reviews_r1_r2)
    to_assign_week <- floor(pubs_tot/3)
    remainder <- pubs_tot %% to_assign_week
    start_from <- 0
    end_at <- to_assign_week
    
    for (b in 1:length(deadlines)) {
      if (b == length(deadlines)) {
        reviews_r1_r2$deadline[start_from:pubs_tot] <- deadlines[b]
      } else {
        reviews_r1_r2$deadline[start_from:end_at] <- deadlines[b]
        start_from <- end_at + 1
        end_at <- min(pubs_tot, start_from + to_assign_week - 1)
      }
    }
    reviews_r1_r2 <- reviews_r1_r2 |> 
      mutate(
      deadline = case_when(
        our_id %in% batch_0 ~ "Oct 22",
        .default = deadline
      )
    )

    # Write CSV files for reviewer pair
    file_name <- paste0(reviewer_names[r1], "_", reviewer_names[r2], ".csv")
    reviews_r1_r2 %>% 
      write_csv(
        here::here(data_directory, "02-combined-reviews", file_name)
      )    
    
    # Bind reviewer pair to rest
    reviews_new <- bind_rows(reviews_new, reviews_r1_r2)
    

  }
}


### Write CSV files for each reviewer
  
reviews_new %>% 
  filter(reviewer_1 == 1 | reviewer_2 == 1) %>% 
  write_csv(
    here::here(data_directory, "01-individual-reviews", "catalina.csv")
  )

reviews_new %>% 
  filter(reviewer_1 == 2 | reviewer_2 == 2) %>% 
  write_csv(
    here::here(data_directory, "01-individual-reviews", "federica.csv")
  )

reviews_new %>% 
  filter(reviewer_1 == 3 | reviewer_2 == 3) %>% 
  write_csv(
    here::here(data_directory, "01-individual-reviews", "sinem.csv")
  )

reviews_new %>% 
  filter(reviewer_1 == 4 | reviewer_2 == 4) %>% 
  write_csv(
    here::here(data_directory, "01-individual-reviews", "harry.csv")
  )

reviews_new %>% 
  filter(reviewer_1 == 5 | reviewer_2 == 5) %>% 
  write_csv(
    here::here(data_directory, "01-individual-reviews", "mine.csv")
  )
