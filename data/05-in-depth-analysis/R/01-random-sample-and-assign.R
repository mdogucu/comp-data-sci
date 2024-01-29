library(tidyverse)

# Load all papers selected at preliminary analysis ------------------------

# At the start, we load all papers selected at preliminary analysis
# to make a summary file that only specifies our_id, document_link,
# document_type, whether it has been assigned and to whom it was assigned

all_papers <- read_csv(
  here::here("data", 
             "04-preliminary-analysis",
             "04_merged_reviews",
             "merged_true.csv")
)

# Make id with words in authors before a comma not corresponding to a single 
# letter with a dot, publication year and first word in document_title not
# corresponding to an article (e.g. "the")
author_component <- all_papers$authors %>% 
  str_extract("[^,]+") %>% 
  str_extract("[^;]+") %>% 
  str_replace_all( "([:alpha:]\\.)?", "") %>%
  str_replace_all("-", " ") %>% 
  str_trim() %>% 
  word(1)
year_component <- all_papers$publication_year
# Fix missing publication year
year_component[
  which(word(all_papers$document_title, 1, 3) ==
          "evaluation edison's data")] <- 2021 
title_component <- all_papers$document_title %>% 
  word(1, 5) %>% 
  str_remove_all(c("^a |^an |^the |^to |^and |^from |
                     new|chapter|\\d|-")) %>% 
  str_remove_all("[[:punct:]]") %>% 
  str_trim() %>% 
  word(1, 2) %>% 
  str_remove_all(c(" a$| an$| the$| to$| and$| from$|
                     as$| of$| for$| in$| as$")) %>% 
  str_trim() %>% 
  str_replace_all(" ", "_")

our_id <- paste(
  author_component,
  year_component,
  title_component,
  sep = "_"
)

# Make dataset to keep track of assigned documents
docs_to_be_assiged <- all_papers %>% 
  mutate(
    our_id = our_id,
    assigned = FALSE
  ) %>% 
  relocate(our_id)

# Identify and specify general document types -----------------------------------------
editorial_material_categories <- c("editorial", "editorial material", "letter")
article_catefories <- c(
  "article",
  "article , report",
  "journal article",
  "article , report , 080: journal articles , 141: reports - descriptive",
  "article; early access"
)

preped_docs_to_be_assiged <- docs_to_be_assiged %>% 
  mutate(new_doc_type = ifelse(
    is.na(document_type), 
    yes = "unknown", 
    no = str_to_lower(document_type)
  )) %>% 
  mutate(new_doc_type = fct_collapse(new_doc_type,
    "unknown" = "unknown",
    "book chapter" = "book chapter",
    "editorial material" = editorial_material_categories,
    "conference paper" = "conference paper",
    "article" = article_catefories
  )) %>% 
  select(-c(reviewer_1, reviewer_2, keep, why_not_keep))

second_round <- tail(preped_docs_to_be_assiged, 5)
preped_docs_to_be_assiged <- head(preped_docs_to_be_assiged, 125)
# Assign reviews with stratified sampling for initial assignments ---------
set.seed(1235)

reviewers <- tibble(
  reviewer_1 = sample(5, 3000, rep = TRUE),
  reviewer_2 = sample(5, 3000, rep = TRUE)
)

distinct_reviewers <- reviewers %>% 
  distinct(reviewer_1, reviewer_2) %>% 
  filter(reviewer_1 != reviewer_2) 

# We want 20 articles so each article gets reviewed by 2 people
# 8 reviews per person, each document reviewed twice, so 20 articles
first_assignments_partial <- preped_docs_to_be_assiged %>% 
  filter(new_doc_type != "unknown") %>% 
  group_by(new_doc_type) %>% 
  sample_n(3)
  
first_assignments_complete <- preped_docs_to_be_assiged %>% 
  filter(new_doc_type == "unknown") %>% 
  sample_n(8) %>% 
  bind_rows(first_assignments_partial) %>% 
  cbind(distinct_reviewers) %>% 
  mutate(assigned = TRUE)
  

unassigned_docs <- preped_docs_to_be_assiged %>% 
  filter(!(our_id %in% first_assignments_complete$our_id))
  
doc_assignments <- distinct_reviewers %>% 
  bind_rows(replicate(10, ., simplify = FALSE)) %>% 
  slice(1:nrow(unassigned_docs)) %>% 
  cbind(unassigned_docs) %>% 
  bind_rows(first_assignments_complete) %>% 
  mutate(reviewer_1 = ifelse( # fixes unequal workload for reviewer 2 and 5
    our_id == "Anderson_2019_keeping",
    yes = 2,
    no = reviewer_1
  ))

reviewer_chain <- c(1,2,3,4,5)
docs <- c()
for (i in 1:5) {
  r1 <- reviewer_chain[i]
  r2 <- reviewer_chain[i%%5+1]
  ids <- (filter(doc_assignments, assigned == FALSE) %>% filter((reviewer_1 == r1 & reviewer_2 == r2) | 
                                                                  (reviewer_1 == r2 & reviewer_2 == r1)))['our_id']
  docs <- c(docs, ids[sample(nrow(ids), 4, replace=FALSE),])
}

doc_assignments$assigned[doc_assignments$our_id %in% docs] <- TRUE 

# Do second round of papers (these papers were accidentally dropped in our initial analysis. 
# I need to keep them separate in this script for reproducibility via the random seed above). 
# Given it's only 5, I will do so manually instead of with a random seed
r1 <- c(1,2,3,4,5)
r2 <- c(2,3,4,5,1)
prepped_round_2 <- second_round %>% mutate("reviewer_2" = r2, .before="our_id") %>%
  mutate("reviewer_1" = r1, .before = "reviewer_2")

## Add additional variables
doc_assignments <- doc_assignments %>% rbind(prepped_round_2) %>% 
  within(rm(assigned)) %>% within(rm(document_type)) %>% 
  mutate(journal = NA,
         conference = NA,
         book = NA,
         affiliation_country = NA,
         content_area	= NA,
         research_question	= NA,
         data_collection_type = NA,	
         main_field	= NA,
         big_pic_notes = NA,
         interesting_facts	= NA,
         keywords	= NA,
         keep = NA,
         why_not_keep = NA)

## Creating Catalina's file
doc_assignments %>% 
  filter((reviewer_1 == 1) | (reviewer_2 == 1)) %>% 
  write_csv(here::here(
    "data", 
    "05-in-depth-analysis",
    "01-initial-independent-reviews",
    "Catalina-all-docs.csv"
  ))

## Creating Federica's file

doc_assignments %>% 
  filter((reviewer_1 == 2) | (reviewer_2 == 2)) %>% 
  write_csv(here::here(
    "data", 
    "05-in-depth-analysis",
    "01-initial-independent-reviews",
    "Federica-all-docs.csv"
  ))

## Creating Sinem's file

doc_assignments %>% 
  filter((reviewer_1 == 3) | (reviewer_2 == 3)) %>% 
  write_csv(here::here(
    "data", 
    "05-in-depth-analysis",
    "01-initial-independent-reviews",
    "Sinem-all-docs.csv"
  ))


## Creating Harry's file

doc_assignments %>% 
  filter((reviewer_1 == 4) | (reviewer_2 == 4)) %>% 
  write_csv(here::here(
    "data", 
    "05-in-depth-analysis",
    "01-initial-independent-reviews",
    "Harry-all-docs.csv"
  ))

## Creating Mine's file

doc_assignments %>% 
  filter((reviewer_1 == 5) | (reviewer_2 == 5)) %>% 
  write_csv(here::here(
    "data", 
    "05-in-depth-analysis",
    "01-initial-independent-reviews",
    "Mine-all-docs.csv"
  ))