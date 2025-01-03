
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(here))

# Collect paths to csv files with main_field recoded by
# two reviewers into multiple variables
folder_path <- here("data", 
                    "06-data-cleaning", 
                    "recode-main-field",
                    "02-combined-reviews")
csv_names <- list.files(folder_path)
combined_csv_paths <- paste0(folder_path, "/", csv_names)

# Load all such csv files
recoded_main_field_all <- read_csv(
  combined_csv_paths[1], 
  show_col_types = FALSE, 
  col_types = cols(.default = col_character())
)

for(path in combined_csv_paths[-1]) {
  recoded_main_field_all <- bind_rows(
    recoded_main_field_all,
    read_csv(
      path, 
      show_col_types = FALSE, 
      col_types = cols(.default = col_character())
    )
  )
  print(path)
  read_csv(
    path, 
    show_col_types = FALSE, 
    col_types = cols(.default = col_character())
  ) |> colnames() |>  print()
}

# Keep only our_id (for joining) and new variables
recoded_main_field_all <- recoded_main_field_all |> 
  dplyr::select(-document_link,
                -reviewer_1,
                -reviewer_2,
                -content_area,
                -deadline)

# Write recoded_main_field_all.csv
write_csv(recoded_main_field_all, here("data", 
                                       "06-data-cleaning", 
                                       "recode-main-field",
                                       "recoded_main_field_all.csv"))
