library(dplyr)
library(purrr)

csv <- readr::read_csv(here::here("data", 
                                  "04-preliminary-analysis",
                                  "03_resolved_reviews","non_conflicts.csv"))
print(nrow(csv))

csv_names <- list.files(here::here("data", 
                                   "04-preliminary-analysis",
                                   "03_resolved_reviews"), 
                        paste0(".csv"))
f.names <- csv_names[csv_names != "non_conflicts.csv"]

for(f in f.names){
  csvb <-  readr::read_csv(here::here("data", 
               "04-preliminary-analysis",
               "03_resolved_reviews",
               f))
  if (f == "sinem_mine.csv"){
    csvb[6,]$why_not_keep  <- "duplicated paper" # remove the duplicated retracted file
  }
  csv <- rbind(csv, csvb[,-c(14,15,16,17)])
  print(nrow(csv))
}

csv_names <- list.files(here::here("data", 
                                   "04-preliminary-analysis",
                                   "01_individual_reviews"), 
                        paste0(".csv")) %>% 
  str_remove(".csv")

# add back in files removed for being duplicates
all_data <- tibble()
for (name in csv_names) {
  single_data <- readr::read_csv(
    here::here("data", 
               "04-preliminary-analysis",
               "01_individual_reviews",
               paste0(name,
                      ".csv"))) %>% 
    mutate_all(as.character)
  all_data <- all_data %>% 
    bind_rows(single_data)
}

row_to_add <- (all_data %>% filter(
    (document_title == "what is a data science/analytics degree?") &
      (database == "web of science")))[1,]
row_to_add$keep = FALSE
row_to_add$why_not_keep = "duplicated paper"
csv <- rbind(csv, row_to_add)

row_to_add <- (all_data %>% filter(
  (document_title == "the effectiveness of data science as a means to achieve proficiency in scientific literacy") &
    (database == "ERIC")))[1,]
row_to_add$keep = FALSE
row_to_add$why_not_keep = "duplicated paper"
csv <- rbind(csv, row_to_add)

row_to_add <- (all_data %>% filter(
  (document_title == "developing and deploying a scalable computing platform to support mooc education in clinical data science") &
    (database == "Scopus")))[1,]
row_to_add$keep = FALSE
row_to_add$why_not_keep = "duplicated paper"
csv <- rbind(csv, row_to_add)

csv <- csv %>% 
  filter(!(
     document_link == "https://doi.org/10.1007/s42081-018-0021-7" & 
       document_type == "Correction"
   ))
row_to_add <- (all_data %>% filter(
  document_link == "https://doi.org/10.1007/s42081-018-0021-7" & 
    document_type == "Correction"))[1,]
row_to_add$keep = FALSE
row_to_add$why_not_keep = "duplicated paper"
csv <- rbind(csv, row_to_add)

print(nrow(csv))

readr::write_csv(csv,here::here("data", 
                                     "04-preliminary-analysis",
                                     "04_merged_reviews",
                                     "merged_full.csv"))

new_csv <- csv[csv['keep'] == TRUE,]

readr::write_csv(new_csv, here::here("data", 
                                     "04-preliminary-analysis",
                                     "04_merged_reviews",
                                     "merged_true.csv"))

print(sum(csv['keep']))
print(sum(1-csv['keep']))
table(csv['why_not_keep'])
