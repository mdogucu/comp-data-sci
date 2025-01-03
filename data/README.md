# Data

```all_reviews.csv``` contains the full analysis of all reviewed publications. For reproducibility, the steps to construct this csv are provided as numbered subdirectories.

## Variables

Some variables were obtained programatically:
- ID Name (```our_id```) An easily-readable identifier, produced automatically, for each article that was reatined at the preliminary analysis stage.
- Document Title (```document_title```)
- DOI (```doi```) The digital object identifier for the publication.
- Document Link (```document_link```)
- Author Names (```authors```)
- Abstract (```abstract```) The full abstract of the publication.
- Database (```database```) The database from which the publication was collected.

The remaining variables were filled in during the preliminary and in-depth analysis stages, by the consensus of 2 randomly-assigned reviewers:

- Reviewers (```reviewer_1, reviewer_2```) The 2 randomly-assigned reviewers for each article's in-depth analysis. Articles with prelim_review=True have the preliminary reviewers listed instead.
- Retained (```keep```) Whether the paper was retained or excluded for formatting or relevance reasons. For papers with keep=False, see prelim_review for which stage it was excluded at.
- Reason for Exclusion (```why_not_keep```)
- Preliminary vs In-depth Analysis (```prelim_review```) set to True if the paper was excluded at the preliminary analysis stage, False if it was analyzed in-depth.

The remaining variables were filled in during in-depth analysis:

- Open access (```open_access```)
  - Papers which are not accessible via the DOI link were searched on Google Scholar in incognito mode (to ensure cookies don't lead to false positives). If a paper was accessible through either the DOI link or the Google Scholar search, we labeled open_access=True; otherwise False.
 
- First Published Online (```first_published```) The date at which a publication was first published online.
- Document type (```new_doc_type```, named to separate it from a now-deleted programatically-obtained variable named document_type):
  - "conference article" (with the conference name provided in ```conference```)
  - "journal article" (with the journal name provided in ```journal```)
  - "book chapter" ( with the book name provided in ```book```)
  - "magazine article" (with the magazine name provided in ```book```)
    
- Affiliation country of authors (```affiliation_country```) Affiliation of authors' home institution(s). Authors are separated by commas; "and" separates multiple affiliations for the same author.

- Content area (```content_area```) A categorization of the subject matter for each publication. Note that, in the manuscript, this is referred to as "publication focus". Categories: 
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
  
- Discipline of target audience for publication (```audience_discipline```). The goal is to identify all specific disciplines that are the target audience of the publication. We want to focus on the discipline of the audience, over other features of the audience (e.g. educators vs administrators vs policy-makers). The word "educators" is implicit in every value. For example, `audience_discipline` = statistics means the target audience is statistics educators/educators of statistics students. Example values: statistics, computer science, medicine, engineering, medicine, computer science (double coding), oceanography, broad. "broad" should be used when the audience is the broad data science community (similar to "call to action" it refers to anything that doesn't have a more specific audience). Use double coding (use ";" for separationg) for papers whose audiences are contained in multiple specific disciplines (e.g. "medicine, engineering"). Do not use "multidisciplinary," "nonspecific," or "data science."

- Observational unit (```observational_unit```) This is for all studies that collected data. Enter "not applicable" for studies without data. An observational unit can be considered as what is potentially in each row of the collected dataset. In studies with empirical data, try to imagine the data frame, what is in each row of the data frame? That is an observational unit. Some examples from today's discussion included, "students from an XXX course", "data science programs in some research universities", or "job ads" There was a study that did data mining on data science job ads. Use ";" for separationg double coding. We can generalize them after we have finished collecting the data, but for now we should be as detailed as possible when recording this variable. e.g. "senior Information Technology Software Development concentration students enrolled in the capstone course" instead of just "information technology students"
  
- Department of program, course, etc. (```department```). This is only for publications in: course activity example, class activity example, extra curricular activity example, program example, pedagogical approach, educational technology. For publications outside of those content areas, we record "not applicable". If a publication only considers a hypothetical course, program, etc. and no department is involved, we also record "not applicable". If a real course, program, etc. is implemented by the department is not specified, we record "not specified". We will not pull this from author affiliation. Use ";" for separationg double coding. In cases where the observational unit was departments, we do not record those deparments under this variable. If a publication specifies multiple department were involved, but doesn't specify which, we will record "multiple departments".

- Discipline of the source (i.e. conference/journal/book) where the document was published (```source_discipline```). If the source publishes content in one or more disciplines _including but not limited to education-focused content_ then we code _only_ the discipline(s) and _not_ "education" (e.g. "computer science", "computer science; engineering"). Conversely, if the source _only_ publishes content specific to education in discipline x (e.g. computer science) , then we code "discipline x education" (for example, "computer science education"). If the source publishes about discipline x (e.g. statistics) _and_ data science, then we only code discipline x. When a source declares to publish _only_ about data science (and does not mention any other discipline x), then we code it as "broad".
  
- Big picture notes (```big_pic_notes```) A high-level, brief and qualitative description of the article
- Interesting facts (```interesting_facts```)
- Keywords (```keywords```)
