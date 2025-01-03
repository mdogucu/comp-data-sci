## Datasets

So far in this folder there is one dataset for each database labeled with the database name e.g. `scopus.csv`.  

When extracting information from a database 

- Make sure that you search "data science education" in quotes. It should appear in title OR abstract OR keywords. 

- Make sure to check the number of manuscripts returned.

- Export this to a csv with as many variables as possible (even that might seem unnecessary e.g. some electronic ID that the database assigns).

- Make sure the total number of manuscripts on the database and the csv match.

- Save your csv as is without touching anything. We will later do data cleaning and joining with R code.

---

Take notes in this section any human decisions involved that can potentially go into the methods section of the manuscript.

- on Web of Science topic search was conducted. It states "Searches title, abstract, author keywords, and Keywords Plus."

- on PubMed search was conducted to find articles with "data science education" in the title, abstract, or Other Term. Other term is also referred to as Keywords on the [PubMed med line elements page](https://www.nlm.nih.gov/bsd/mms/medlineelements.html#ot)

- on IEEE Xplore Federica conducted the search type "Advanced Search". The search made was _("Document Title":"data science education") OR ("Publication Title":"data science education") OR ("Abstract":"data science education") OR ("Author Keywords":"data science education")_. Publication Year range was left as default (1884-2023). The number of returned manuscripts was 29 (28 conferences + 1 magazine). The .csv file downloaded contained 29 manuscripts (rows) and 30 variables (columns).

- on Science Direct Harry selected Advance Search and then searched "data science education" in the field Title, abstract or author-specified keywords. The number of returned articles was 8. A .bibtex file was downloaded and converted to a .csv file. This final .csv file contained 8 rows and 19 variables (columns)


