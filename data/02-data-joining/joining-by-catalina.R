library(here)
library(tidyverse)
library(janitor)
library(lubridate)


# Read in data and unify common columns -----------------------------------

# Webs of Sience first because it has the most complete data usually
db_web_of_science <- read_csv(
  here("data/01-database-extraction", "web-of-science.csv"),
  col_types = cols(.default = "c", `Publication Year` = "n")
) %>% 
  clean_names() %>% 
  rename(
    document_title = article_title,
    publisher_title = source_title,
    document_link = doi_link,
    authors_addresses = addresses,
    eissn = e_issn
  ) %>% 
  mutate(database = "web of science")

db_eric <- read_csv(
  here("data/01-database-extraction", "eric-proquest.csv"),
  col_types = cols(.default = "c", year = "n")
) %>% 
  clean_names() %>% 
  rename(
    document_title = title,
    publication_year = year,
    publisher_title = pubtitle,
    publisher_url = publisher,
    eissn = elec_issn,
    doi = digital_object_identifier,
    document_link = document_url
  )
  

db_ieee <- read_csv(
  here("data/01-database-extraction", "ieee-xplore.csv"),
  col_types = cols(.default = "c")
) %>% 
  clean_names() %>% 
  rename(
    document_link = pdf_link,
    database = publisher,
    isbn = isb_ns
  ) %>% 
  mutate(date_added_to_xplore = as.Date(online_date, format = "%d %b %Y")) %>% 
  mutate(publication_year = year(date_added_to_xplore))

db_pubmed <- read_csv(
  here("data/01-database-extraction", "pubmed.csv"),
  col_types = cols(.default = "c")
) %>% 
  clean_names() %>% 
  rename(
    document_title = title,
    publisher_title = journal_book
  ) %>% 
  mutate(publication_year = year(as.Date(create_date))) %>% 
  mutate(database = "pubmed")

db_science_direct <- read_csv(
  here("data/01-database-extraction", "science-direct.csv"),
  col_types = cols(.default = "c", `Publication year` = "n")
) %>% 
  clean_names() %>% 
  rename(
    document_type = item_type,
    document_title = title,
    document_link = ur_ls,
    publisher_title = journal
  ) %>% 
  mutate(database = "science direct")

db_scopus <- read_csv(
  here("data/01-database-extraction", "scopus.csv"),
  col_types = cols(.default = "c", Year = "n")
) %>% 
  clean_names() %>% 
  rename(
    document_title = title,
    publication_year = year,
    publisher_title = source_title,
    document_link = link,
    database = source,
    article_number = art_no
  )

all_articles <- db_eric %>% 
  full_join(db_ieee) %>% 
  full_join(db_pubmed) %>% 
  full_join(db_science_direct) %>% 
  full_join(db_scopus) %>% 
  full_join(db_web_of_science) %>% 
  select(order(colnames(.))) %>% 
  mutate(document_title = str_to_lower(document_title)) %>% 
  mutate(doi = str_to_lower(doi))


# Fill in missing doi's and links for those without doi's and links -------

all_articles_reduced <- all_articles %>% 
  select(
    document_title, doi, document_link, authors, publication_year, 
    document_type, abstract, database, open_access
  ) %>% 
  mutate(doi = replace( #1
    doi, 
    document_title == "data science meets science teaching", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #2
    doi, 
    document_title == "envisioning the data science discipline: the undergraduate perspective--interim report. consensus study report", 
    values = "10.17226/24886"
  ))  %>% 
  mutate(doi = replace( #3
    doi, 
    document_title == "statistical literacy for active citizenship: a call for data science education", 
    values = "10.52041/serj.v16i1.213"
  )) %>% 
  mutate(doi = replace( #4
    doi, 
    document_title == "the effectiveness of data science as a means to achieve proficiency in scientific literacy", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #5
    doi, 
    document_title == "big data science education: a case study of a project-focused introductory course", 
    values = "DNE"
  )) %>%
  mutate(document_link = replace( #5
    document_link, 
    document_title == "big data science education: a case study of a project-focused introductory course", 
    values = "https://www.learntechlib.org/p/171521/"
  )) %>%
  mutate(doi = replace( #6
    doi, 
    document_title == "developing and deploying a scalable computing platform to support mooc education in clinical data science", 
    values = "DNE"
  )) %>%
  mutate(document_link = replace( #6
    document_link, 
    document_title == "developing and deploying a scalable computing platform to support mooc education in clinical data science", 
    values = "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8378646/"
  )) %>%
  mutate(doi = replace( #7
    doi, 
    document_title == "enabling data science education in stem disciplines through supervised undergraduate research experiences", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #8
    doi, 
    document_title == "sigcse 2022 - proceedings of the 53rd acm technical symposium on computer science education v. 2", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #9
    doi, 
    document_title == "real data and application-based interactive modules for data science education in engineering", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #11
    doi, 
    document_title == "ethics in data science education", 
    values = "10.18260/1-2--34589"
  )) %>% 
  mutate(doi = replace( #12
    doi, 
    document_title == "self and socially shared regulation of learning in data science education: a case study of “quantified self” project", 
    values = "10.22318/icls2020.749"
  )) %>% 
  mutate(doi = replace( #13
    doi, 
    document_title == "21st international conference on interactive collaborative learning, icl 2018", 
    values = "10.1007/978-3-030-11932-4"
  )) %>% 
  mutate(doi = replace( #14
    doi, 
    document_title == "how environmental science graduate students acquire statistical computing skills", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #15
    doi, 
    document_title == "linking educational resources on data science", 
    values = "10.1609/aaai.v33i01.33019404"
  )) %>% 
  mutate(doi = replace( #16
    doi, 
    document_title == "data wrangling practices and process in modeling family migration narratives with big data visualization technologies", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #17
    doi, 
    document_title == "2018 ieee data science workshop, dsw 2018 - proceedings", 
    values = "10.1109/DSW43626.2018"
  )) %>% 
  mutate(doi = replace( #18
    doi, 
    document_title == "envisioning the data science discipline: the undergraduate perspective: interim report", 
    values = "10.17226/24886"
  )) %>% 
  mutate(doi = replace( #19
    doi, 
    document_title == "evaluating computational thinking in jupyter notebook data science projects", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #20
    doi, 
    document_title == "architecting data science education", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #21
    doi, 
    document_title == "proceedings - 2017 ieee/acm 39th international conference on software engineering: software engineering and education track, icse-seet 2017", 
    values = "10.52041/serj.v16i1.213"
  )) %>% 
  mutate(doi = replace( #22
    doi, 
    document_title == "statistical literacy for active citizenship: a call for data science education", 
    values = "10.52041/serj.v16i1.213"
  )) %>%
  mutate(doi = replace( #23
    doi, 
    document_title == "exploring how different project management methodologies impact data science students", 
    values = "DNE"
  )) %>% 
  mutate(doi = replace( #24
    doi, 
    document_title == "what is a data science/analytics degree?", 
    values = "DNE"
  )) %>%
  mutate(document_link = replace( #24
    document_link, 
    document_title == "what is a data science/analytics degree?", 
    values = "https://aisel.aisnet.org/amcis2017/Panels/Presentations/13"
  )) %>%
  mutate(doi = replace( #25
    doi, 
    document_title == "the effectiveness of data science as a means to achieve proficiency in scientific literacy", 
    values = "DNE"
  )) %>% 
  mutate(document_link = replace( #25
    document_link, 
    document_title == "the effectiveness of data science as a means to achieve proficiency in scientific literacy", 
    values = "http://isedj.org/2015-13/n4/ISEDJv13n4p64.html"
  )) %>% 
  mutate(doi = replace( #26
    doi, 
    document_title == "smart blockchain badges for data science education", 
    values = "10.1109/FIE.2018.8659012"
  )) %>% 
  mutate(doi = replace( #27
    doi, 
    document_title == "the michigan data science team: a data science education program with significant social impact", 
    values = "10.1109/DSW.2018.8439915"
  )) %>% 
  mutate(doi = replace( #28
    doi, 
    document_title == "milo: a visual programming environment for data science education", 
    values = "10.1109/VLHCC.2018.8506504"
  )) %>% 
  mutate(doi = replace( #29
    doi, 
    document_title == "beyond ethics: considerations for centering equity-minded data science", 
    values = "10.5642/jhummath.OCYS6929"
  )) %>% 
  mutate(doi = replace( #30
    doi, 
    document_title == "active learning in data science education", 
    values = "10.1109/ICETA.2018.8572219"
  )) %>% 
  mutate(doi = replace( #32
    doi, 
    document_title == "smart education and future trends", 
    values = "DNE"
  )) %>% 
  mutate(document_link = replace( #32
    document_link, 
    document_title == "smart education and future trends", 
    values = "https://ijcopi.org/ojs/article/view/294"
  )) %>% 
  mutate(doi = replace( #33
    doi, 
    document_title == "interdisciplinary data science education", 
    values = "10.1021/bk-2012-1110.ch006"
  )) %>% 
  mutate(doi = replace( #34
    doi, 
    document_title == "linking educational resources on data science", 
    values = "10.1609/aaai.v33i01.33019404"
  )) %>% 
  mutate(doi = replace( #35
    doi, 
    document_title == "embedding data science into computer science education", 
    values = "10.1109/EIT.2019.8833753"
  )) %>% 
  mutate(doi = replace( #36
    doi, 
    document_title == "interdisciplinary education - the case of biomedical signal processing", 
    values = "10.1109/EDUCON45650.2020.9125200"
  )) %>% 
  mutate(doi = replace( #37
    doi, 
    document_title == "data science education through education data: an end-to-end perspective", 
    values = "10.1109/ISECon.2019.8881970"
  )) %>% 
  mutate(doi = ifelse(doi == "DNE", NA, doi)) %>% 
  mutate(doi = replace( # DOI wrong from Web of Science
    doi,
    document_title == "tailored data science education using gamification",
    values = "10.1109/cloudcom.2016.0108"
  )) %>% 
  mutate(doi = replace( # DOI wrong from Web of Science
    doi,
    document_title == "scaling data warehousing course projects",
    values = "10.1109/csci.2016.0054"
  )) %>%
  mutate(doi = replace( # DOI wrong from Web of Science 
    doi,
    document_title == "quantitative and qualitative analysis of current data science programs from perspective of data science competence groups and framework",
    values = "10.1109/cloudcom.2016.0109"
  )) %>% # This now has a doi but I forgot to give it a document_link. This mistake was noted and fixed in join_single_reviewer_datasets.R
  mutate(document_link = ifelse(
    is.na(doi), 
    document_link, 
    paste0("https://doi.org/", doi)
  )) %>% 
  mutate(document_link = replace(
    document_link,
    document_title == "data science meets science teaching",
    values = "https://www.nsta.org/science-teacher/science-teacher-januaryfebruary-2022/data-science-meets-science-teaching"
  )) %>% 
  filter(duplicated(doi, incomparables = NA) == FALSE) ## Should be document_link not doi. This was noted and fixed in join_single_reviewer_datasets.R




# Save cleaned data -------------------------------------------------------

write_csv(
  all_articles_reduced, 
  path = here("data/02-data-joining", "joint_data.csv")
)
