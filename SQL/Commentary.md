# Notes
**This is a very long commentary file.** Each subheader has briefs. This is written so that anyone can get a detailed look at my thought processes without talking directly to me.
These databases produced in SQLite3. Please be aware that the 500k+ rows of data in the Transfer database is very large, so after decompression, the transfer database will be about half of a GB. **Because of this size, exhibit caution when uncompressing**.

## GGUSD 
Brief: I compared schools in my high school's district for their relative efforts and successes in applying/being admitted to UCs.

The database has a view for 2019+ for all of the schools in my high school district, GGUSD, and their admissions rates per UC and over the entire CSUs. This was really done more as an experiment with SQL; I ended up doing most of what I wanted in Google Sheets since the data was sufficiently small enough to load in Sheets and since portability/shareability were more important.

### GGUSD UC-by-UC Sheet
These outputs are stored on my personal email.
[A UC-by-UC Google Sheet can be found here](https://docs.google.com/spreadsheets/d/1GMsVy7m0FugFrCameAbU2gCzUipeeGtpVCeObg03PK4/edit#gid=189555208). It contains four meaningful tables and a data sheet:

**UC-by-UC, App Pop Mean Comp**, full description "UC-By-UC, admission rates among applications per high school, compared to GGUSD Mean," is a metric of the relative skill of each GGUSD school's applicants, categorized by the percent accepted to each UC and year of application. Each cell is the difference between the % of a high school's senior population that had applied to that UC and the average UC admission rate across GGUSD. Thus, green cells imply that school's applicants outperformed the average, whereas red cells imply the school underperformed. 

Since this is based on the % that had applied, it is possible for the results to seem counterintuitive when a "good" or "academically-rigorous" high school has a lower acceptance rate. However, what might be the case is that the best several of one high school to apply, whereas another school sees the best dozen apply. In such a case, the latter may have a lower acceptance rate and appear to underperform versus the average, when in reality, more students applied and were rejected. 

**UC-by-UC, SP Mean Comp**, full name "UC-by-UC, admission rates among seniors per high school, compared to GGUSD Mean," is a metric of each high school's senior population's relative effort (SP stands for senior population). Green cells denote that the school performs above the GGUSD average for that university and admission type, e.g. that school either applies more or is admitted more often to that school. Larger greens imply that the school is especially drawn to that university.

What does this imply for policy? Some schools may have very high application rates among seniors, but lower acceptance rates. That is, many of its seniors apply, even if they may not be as qualified; this could be a reflection of the academic culture of that high school. Others may have low application rates among seniors, but higher acceptance rates. That is, it is likely only the best several are applying, while the rest simply don't bother.

### GGUSD UC Sheets
These results are best seen in my [GGUSD UC Sheets Google Sheet here.](https://docs.google.com/spreadsheets/d/1ReXjuTcaIJ2oH9GOdklDr5SnDuMTxHzZA3kD1N0b3iI/edit#gid=1779884986) This includes four graphs: 
* 2019-2022 GGUSD High School Senior Accept % to UC. This is the percentage of applications accepted university-wide, organized by year and categorized by high school.
* 2019-2022 GGUSD High School Senior Apply % to UC: This is the percentage of seniors that apply to the UC system.

The two graphs below are comparisons with the corresponding graph above, using my high school, La Quinta (LQ), as a reference. Using the Senior Apply % comparison, it is clear that LQ's student population typically applies more often than the other schools in GGUSD. The next closest is usually Bolsa. In contrast, a school like Los Amigos usually has a much lower percentage of its senior population applying, but typically has higher acceptance rates. 

In total, this implies that LQ likely has a culture that values going to a UC more than most of its GGUSD counterparts, but that this higher population of students applying means that there's more "less-qualified" students, thereby reducing its apparent acceptance rate. It would be a mistake to use only UC acceptance rates if used as a metric in deciding which is the "best" GGUSD school since the relative efforts of the senior populations differs. 

There's also other questions that I have yet to organize properly. Might LQ students simply be applying to the more prestigious UCs like Berkeley, LA, and Irvine?  

That being said, caution must be exhibited since 3 of the 4 years used are post-COVID and may not be reflective of their rates before it. Considering the long-term effects of COVID, though, it may be necessary to weigh post-COVID years more, anyway.

## Admissions data
Brief: Although I have come to realize my initial interest and conclusions for the admissions data set weren't statistically valid (just comparing admission rates for FTFY with and without transfer GPAs), the contexts of this project inspired me to seriously respect and become interested in the educational role community colleges play in their immediate area.

### Initial work and why the data is unusual
The project uses a CSULB admissions data set that was previously available from CSULB's Institution of Research and Analytics (IR&A) in Spring of 2023, but access mysteriously vanished with no announcement after summer 2023 (the IR&A was apparently restructured, so that may have some role). Since it was previously available, and since there was no announcement of wrongdoing on their end, I don't believe there was anything wrong with the data being available. My queries with this data set can be found in the SQL section.
 
My initial interest in it arose from my good experience in a dual enrollment course at Golden West College, which had inspired me to seriously consider the role of community colleges in my immediate area. I became more interested when I discovered that the admissions dataset includes transfer GPAs for FTFY, which firstly implies that they dual enrolled and secondly is bizarre to have in a data set. I have never encountered any other university that had CSULB's level of data publicly available nor distinguishes dual enrollment — the UCs come closest with their data, which have dual enrollment rolled up alongside honors and AP courses.

What was fascinating, though, was that FTFYs with any transfer GPA were accepted significantly more than those without. When considering that most dual enrollers have higher GPAs, though, it's clear that there's some other cause explaining both, anyway. Still, a cursory glance at the SQL databases does reveal that it can still be an edge on others within a GPA bin (e.g. in 3.0-3.99, those with transfer GPAs were accepted more often).

However, one year, 2019, has 1/7th of the FTFY population apply with transfer GPAs. This is a substantial jump from the literal 1% for all other years in my data set. I've largely ignored this since it seems unlikely that such a jump might occur without persisting at all, but I have reached out before to the IR&A about this. They have yet to respond.

### Asides
I've yet to perform a more detailed and certain statistical analysis on this data set. I strongly suspect the rate of dual enrolling is covariant with higher GPA, mitigating how much someone can say that merely dual enrolling will necessarily improve chances of admissions. As such, I would freely admit that, until then, using this to guide serious policy is a mistake; call this just a curiosity. Despite this, seeing the apparent effect of dual enrollment has still motivated my interest in education and educational economics, particularly in this sector of gifted children/advanced studies, of which dual enrollment is a part of.

Especially as someone in an Asian-American community, a lot of it is UC or bust, but with increasing demands on students, it's becoming at times less feasible or more stressful. Yet, I find that cultivating this respect towards community colleges — how they provide second chances for returning learners, opportunities for advanced students, and help create an inexpensive place of learning and collaboration — is really something worthwhile. This respect is something that I want to expand in my own community, if at least so they know of their opportunities. 

Many opportunities exist. It's just a matter of finding them, like CIF, which I only encountered by happening to be in the same room as my professor when she mentioned receiving an email from them.

To conclude, I would like to thank the instructor of that dual enrollment art course, Don Ray McKinney. Seeing that intersection of lives, from an older Romanian woman who finally could express her art, to a mother-daughter pair, was very warming, and I'll remember it dearly.