library(tidyverse)

# change these accordingly 

reviewers <- c("Mine", "Sinem", "Catalina", "Federica", "Harry")

for (r1 in c(1:4)) {
  for (r2 in c((r1+1):5)){
    reviewer_a <- reviewers[r1]
    reviewer_b <- reviewers[r2]
    
    data_a <- read_csv(here::here(paste0(
      "data/05-in-depth-analysis/",
      "01-initial-independent-reviews/",
      reviewer_a, "-all-docs.csv")),
      col_types = cols(.default = "c")) %>% 
      filter((reviewer_1 %in% as.character(c(reviewer_a_code, reviewer_b_code))) &
               reviewer_2 %in% as.character(c(reviewer_a_code, reviewer_b_code))) %>% 
      mutate(file_name = reviewer_a)
    
    
    data_b <- read_csv(here::here(paste0(
      "data/05-in-depth-analysis/",
      "01-initial-independent-reviews/",
      reviewer_b, "-all-docs.csv")),
      col_types = cols(.default = "c")) %>% 
      filter((reviewer_1 %in% as.character(c(reviewer_a_code, reviewer_b_code))) &
               reviewer_2 %in% as.character(c(reviewer_a_code, reviewer_b_code))) %>% 
      mutate(file_name = reviewer_b)
    
    combined <- bind_rows(data_a, data_b) %>% 
      arrange(our_id, by = file_name)
    
    write_csv(combined, 
              here::here(paste0(
                "data/05-in-depth-analysis/",
                "02-combined-reviews/",
                reviewer_a,"-", reviewer_b, "-combined.csv")))
  }
}