# Merge notes

Record special case decisions and notes here when meeting with coreviewer.

Remove the columns `assigned` and `document_type` from your individual csv.

Use the 03-combine-reviews.R script to combine reviews into a single csv before consulting about them.

## Mine and Catalina

- Conference name: we updated the description to specify proceedings should be left in name because it is where the material was published
- New content area *guidelines*. This is for curriculum accreditation (e.g. EDISON) or organization guidelines (e.g. ASM, IEEE).
- Field should not be specified as "data science" because these articles are all data science. If there is no additional field it should be "nonspecific".
- New exclusion criteria "MOOC" for massive online class
- Data collection: was the data collected specifically for this study?
- Differences between data types (added reference link)
- Research question doesn't have to be explicit (see updated description)

## Mine and Harry

- Papers which are not accessible via the DOI link should be searched on Google Scholar. If they are not accessible there either, set `open_acces=False` (otherwise, set `open_access=True`)

## Mine and Federica

- **open_access**:
  - We checked whether a document was open access by disconnecting our phone from the wifi and searching for the document on our phone. Our experience with this was good.
  - Sometimes an article is not open access on the journal where it was published but it is avaliable open access somewhere else (e/g. arXiv). Useful to run a search also on Google (not just Google Scholar)
 
- **big_pic_notes**:
  - we usually kept the longest one and modified it to add any good thing from the shortest one
    
- **content_area**:
  - whenever one of the two reviewers had something different from "call to action" (and the other one had "call to action") we discussed and eventually agreed on a different content area than "call to action" (so call to action is confirmed to be the "last resort", since any paper usually has some kind of call to action)
  
## Sinem and Catalina
- **why-not_keep**
  - We added "presentation summary" and "instructors" as an additional category
  
## Sinem and Harry

- **data_collection_type**

We couldn't decide if we need to include "quantified data" as quantitative data within this variable. (Raw data vs. derived data) (Li_2021_exploring_interdisciplinary)

## Sinem and Federica

- What do we mean by "class activity example" Does this code cover the assignments as well or is it just in-class activity?
- We did not resolve "Pieterman_2022_integration" paper. We will check it again after we decide the scope of **research** (Sinem thinks that this paper has a specific aim as investigating the possibility of integrating philosophy of science into biomedical data science education. However,Federica thinks that it does not count as a research question because they are not trying to answer a question but argument their idea)

##  Federica and Harry

- **why_not_keep** & **new_doc_type**
  - posters are not kept
 
- **data_collection_type**
  - Does data collected as part of an example course count as data for the purpose of this column? See Hicks_2019_guide and Rao_2018_milo.
 
- **open_access**
  - Federica had understood that to check open access we should both look at Google Scholar _and_ do a Google Search. Harry understood that we should only look at Google Scholar. We should decide what to do and then look for possible inconsistencies with the chosen method. 

## Federica and Catalina

- **open_access** Should we even being calling this open access? There are papers I can find the pdf of through Google Scholar but if you follow the doi it obviously has to be paid for (e.g. Cuadrado_2021_classification)
- **new_doc_type** "interview" (e.g. Hardin_2021_computing) Are we keeping this? It is similar to "introduction to special issue" so we are unsure.


