# Data

```all_reviews.csv``` contains the full analysis of all reviewed publications. For reproducibility, the steps to construct this csv are provided as numbered subdirectories.

## Variables

Some variables were obtained programatically:
- Document Title (```document_title```)
- DOI (```doi```) The digital object identifier for the publication.
- Document Link (```document_link```)
- Author Names (```authors```)
- Publication Year (```publication_year```) For conferences this will be conference year not necessarily the same as publication year.
- Abstract (```abstract```) The full abstract of the publication.
- Database (```database```) The database from which the publication was collected.
- Keywords (```keywords```)
- ID Name (```our_id```) An easily-readable identifier, produced automatically, for each article that was reatined at the preliminary analysis stage.

The remaining variables were filled in during the preliminary and in-depth analysis stages, by the consensus of 2 randomly-assigned reviewers:

- Preliminary vs In-depth Analysis (```prelim_review```) set to True if the paper was excluded at the preliminary analysis stage, False if it was analyzed in-depth.
- Retained (```keep```) Whether the paper was retained or excluded for formatting or relevance reasons. For papers with keep=False, see prelim_review for which stage it was excluded at.
- Reason for Exclusion (```why_not_keep```)
- Reviewers (```reviewer_1, reviewer_2```) The 2 randomly-assigned reviewers for each article's in-depth analysis. Articles with prelim_review=True have the preliminary reviewers listed instead.

The remaining variables were filled in during in-depth analysis:

- Open access (```open_access```)
  - Papers which are not accessible via the DOI link were searched on Google Scholar in incognito mode (to ensure cookies don't lead to false positives). If a paper was accessible through either the DOI link or the Google Scholar search, we labeled open_access=True; otherwise False.
- Document type (```new_doc_type```, named to separate it from a now-deleted programatically-obtained variable named document_type):
  - "conference article" (with the conference name provided in ```conference```)
  - "journal article" (with the journal name provided in ```journal```)
  - "book chapter" ( with the book name provided in ```book```)
  - "magazine article" (with the magazine name provided in ```book```)
- Affiliation country of authors (```affiliation_country```) Affiliation of authors' home institution(s). Authors are separated by commas; "and" separates multiple affiliations for the same author.
- Content area (```content_area```) A categorization of the subject matter for each publication. Categories: 
  - education technology (e.g. software and tools)
  - review of current state of data science education
  - course example
  - pedagogical approach (e.g. team based learning)
  - program example (as in curriculumn)
  - class activity example
  - extra curricular activity example
  - guidelines (as in organization guidelines, e.g. ASM, IEEE) 
  - call to action (e.g. expressing need for data science or data science defined curriculum, while not meeting the criteria of any above content area)
- Research question (```research_question```) If the authors pose a specific research question or study goal
- Type of Data Collected (```data_collection_type```)  Categories: (Refer to <https://learning.eupati.eu/mod/page/view.php?id=497>)
  - quantitative
  - qualitative (e.g. interviews)
  - mixed (i.e. both quantitative and qualitative)
  - no data


- Field (```main_field```) The prevailing discipline of the paper, as agreed upon by reviewers based on factors such as:
  - The department offering the course/program outlined in the publication.
  - The perceived audience of the publication, based on presentation and venue
  - The prevailing major of students used to collect data in the case of a course or class activity example.
  
- Big picture notes (```big_pic_notes```) A high-level, brief and qualitative description of the article
- Interesting facts (```interesting_facts```)