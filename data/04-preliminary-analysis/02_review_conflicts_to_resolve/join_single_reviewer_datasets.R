
library(dplyr)
library(stringr)


# Define mapping of reviewer codes to reviewer names ----------------------
reviewer_names <- c("catalina", "federica", "sinem", "harry", "mine")

# Read data ---------------------------------------------------------------
all_data <- tibble()
csv_names <- list.files(here::here("data", 
                                   "04-preliminary-analysis",
                                   "01_individual_reviews"), 
                        paste0(".csv")) %>% 
  str_remove(".csv")

for (name in csv_names) {
  single_data <- readr::read_csv(
    here::here("data", 
                "04-preliminary-analysis",
               "01_individual_reviews",
                paste0(name,
                ".csv"))) %>% 
      mutate(reviewer = which(reviewer_names == name)) %>% 
    mutate_all(as.character)
  all_data <- all_data %>% 
    bind_rows(single_data)
}


# Deal with documents being assigned to more than 2 reviewers --------------
# Note: In joining-by-catalina.R, 3 documents with missing doi that were
#       present in two databases had not been identified. Each of these 3 
#       documents then was reviewed 4 times (2 times per each copy) rather than
#       2 times. Here, we identify these cases and we remove 2 of their 4 reviews

# Make sure there are only 3 such documents
all_data %>% 
  group_by(document_link) %>% 
  mutate(n_rows = n()) %>% 
  filter(n_rows > 2) %>% 
  arrange(document_link) %>% 
  View()

# Extract links of the 3 documents
title_3_documents_extra_reviews <- all_data %>% 
  group_by(document_link) %>% 
  mutate(n_rows = n()) %>% 
  filter(n_rows > 2) %>%
  distinct(document_title) %>%
  pull(document_title)
  
# Article "what is a data science/analytics degree?"
# All reviews say "FALSE" and "panel" as the why_not_keep
# We are going to keep the ones from the Scopus database
all_data <- all_data %>% 
  filter(!(
    (document_title == "what is a data science/analytics degree?") &
    (database == "web of science")
  )) 

# Document "the effectiveness of data science as a means to achieve proficiency in scientific literacy"
# 3 reviews say "TRUE" and one review says "FALSE"
# We are going to keep the ones with keep=TRUE, in the spirit of keeping 
# documents if in doubt, at this stage.
# These happen to be the ones that are from the Scopus database
all_data <- all_data %>% 
  filter(!(
    (document_title == "the effectiveness of data science as a means to achieve proficiency in scientific literacy") &
      (database == "ERIC")
  )) 

# Document "developing and deploying a scalable computing platform to support mooc education in clinical data science"
# 3 reviews say "FALSE" and one review says "TRUE"
# We are going to keep the ones with one keep=TRUE, in the spirit of keeping 
# documents if in doubt, at this stage.
# These happen to be the ones that are from the pubmed database
all_data <- all_data %>% 
  filter(!(
    (document_title == "developing and deploying a scalable computing platform to support mooc education in clinical data science") &
      (database == "Scopus")
  )) 

# Check again to make sure all documents now have
all_data %>% 
  group_by(document_link) %>% 
  mutate(n_rows = n()) %>% 
  filter(n_rows > 2) %>% 
  arrange(document_link) %>% 
  View()

# Fix document links ------------------------------------------------------
all_data$document_link[is.na(all_data$document_link)] <- "https://doi.org/10.1109/cloudcom.2016.0109"
all_data$document_link[all_data$document_link == "https://repository.isls.org/bitstream/1/6745/1/749-750.pdf"] <- "https://doi.org/10.22318/icls2020.749"
all_data$document_link[all_data$doi == "10.1109/escience.2019.00076"] <- "https://doi.org/10.1109/escience.2019.00076"

# Flag conflicts ----------------------------------------------------------
all_data$why_not_keep <- stringr::str_to_lower(all_data$why_not_keep)

all_data <- all_data %>% 
  group_by(document_link) %>% 
  mutate(conflict = 
           any(is.na(keep)) | # Any keep is NA
           !( # Or, it doesn't fall in the 2 categories of agreement
             (keep[1] == TRUE && keep[2] == TRUE) |
               (
                 (keep[1] == FALSE && keep[2] == FALSE) & 
                   ((why_not_keep[1] == why_not_keep[2]) | any(is.na(why_not_keep)))
               )
           )
  ) %>% 
  arrange(conflict, document_link) 



# Separate and save non-conflicts -----------------------------------------
non_conflicts <- all_data %>% 
  filter(conflict == FALSE) %>% 
  dplyr::select(-reviewer, -conflict) %>% 
  filter(!duplicated(document_link))
  
readr::write_csv(non_conflicts,
                 here::here("data", 
                            "04-preliminary-analysis",
                            "03_resolved_reviews",
                            "non_conflicts.csv"))

# Separate and save conflicts ---------------------------------------------
conflicts <- all_data %>% 
  filter(conflict == TRUE) %>% 
  group_by(document_link) %>% 
  mutate(
    keep_1 = keep[reviewer_1 == reviewer],
    why_not_keep_1 = why_not_keep[reviewer_1 == reviewer],
    keep_2 = keep[reviewer_2 == reviewer],
    why_not_keep_2 = why_not_keep[reviewer_2 == reviewer]
  ) %>% 
  arrange(document_link, reviewer) %>% 
  dplyr::select(-reviewer, -conflict) %>% 
  filter(!duplicated(document_link)) %>% 
  mutate(keep = NA, why_not_keep = NA)


for (i in 1:(length(reviewer_names)-1)) {
  for (j in (i+1):length(reviewer_names)){
    conflict_pair_data <- conflicts %>% 
      filter((reviewer_1 %in% c(i, j)) & (reviewer_2 %in% c(i, j))) 
    readr::write_csv(conflict_pair_data,
                     here::here("data", 
                                "04-preliminary-analysis",
                                "02_review_conflicts_to_resolve",
                                paste0(reviewer_names[i],
                                       "_",
                                       reviewer_names[j],
                                       ".csv")))
  }
}


# Check conflict files ----------------------------------------------------
catalina_federica <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/catalina_federica.csv")
catalina_harry <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/catalina_harry.csv")
catalina_mine <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/catalina_mine.csv")
catalina_sinem <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/catalina_sinem.csv")
federica_harry <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/federica_harry.csv")
federica_mine <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/federica_mine.csv")
federica_sinem <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/federica_sinem.csv")
sinem_harry <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/sinem_harry.csv")
sinem_mine <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/sinem_mine.csv")
harry_mine <- read_csv("data/04-preliminary-analysis/02_review_conflicts_to_resolve/harry_mine.csv")

(nrow(catalina_federica) + nrow(catalina_harry) + nrow(catalina_mine) + nrow(catalina_sinem) +
  nrow(federica_harry) + nrow(federica_mine) + nrow(federica_sinem) +
  nrow(sinem_harry) + nrow(sinem_mine)) +
  nrow(harry_mine) == 
                      nrow(conflicts)

