## Preliminary Analysis

At this stage, we read each article's abstract to determine whether it was relevant to our literature review of undergraduate data science education. For a full analysis of exclusion reasons, please see our paper.

Not all articles which were excluded were dropped at this stage; in some cases, it was only after reading the full paper that we decided to exclude an article (see [in-depth analysis](../05-in-depth-analysis/)).

The workflow for our preliminary analysis was:
- Each article was assigned to 2 reviewers for analysis, with these assignments written into [01_individual_reviews](01_individual_reviews/). Each reviewer was instructed to fill in the `keep` column, and the `why_not_keep` column where they set `keep=False`. 
- These individual `csv` files were then combined into [02_review_conflicts_to_resolve](02_review_conflicts_to_resolve/) so that reviewers could resolve disagreements. 
- Once a mutual understanding was reached, reviewers moved their combined files to [03_resolved_reviews](03_resolved_reviews/). 
- Finally, conflict-resolved reviews were merged into [04_merged_reviews/merged_full.csv](04_merged_reviews/merged_full.csv), which contains all analysis, and [04_merged_reviews/merged_true.csv](04_merged_reviews/merged_true.csv), which contains articles that were retained for in-depth analysis (i.e. with `keep=True`). All scripts needed to perform these merges are included in the relevant subdirectories. 