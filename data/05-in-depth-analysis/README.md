
# In-Depth Analysis

```01-initial-independent-reviews``` contains a csv of assigned publications for each reviewer which were retained at the preliminary analysis stage. Each article was assigned to 2 reviewers, who read it in full before (1) deciding whether the publication should be retained or excluded, and (2) determining the value for each variable of interest. These decisions were synthesized in ```02-combined-reviews``` which contains the final decisions for each article, reflecting the agreement of both reviewers.

The files in ```01-initial-independent-reviews``` contain the notes for each individual reviewer, with 2 limitations. First, they are not complete, as not all thoughts and decisions were pushed in advance of reviewer-reviewer meetings to resolve conflicts. Second, there are 5 papers missing from them (which are present in ```02-combined-reviews```). These papers were left out of our initial round of reviews in error; see line 128 of ```R/01-random-sample-and-assign.R```, which will produce complete templates of the independent review files if run.

The script ```R/02-combine-reviews.R``` takes a pair of reviewers' independent reviews and produces a combined file. This file contains a pair of rows for each publication, one for each reviewers' decisions. We manually edited those files down by resolving conflicts then deleting every other row until there was a single row per publication.

```merge.md``` contains notes contributed by each pair of reviewers when resolving their conflicts, meant to help future pairs of reviewers maintain consistency.


The following is the correspondence between reviewers numbers and names:

1. Catalina
2. Federica
3. Sinem
4. Harry
5. Mine
