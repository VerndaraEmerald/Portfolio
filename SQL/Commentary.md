# Notes
**This is a very long commentary file.** Each subheader has briefs. This is written so that anyone can get a detailed look at my thought processes without talking directly to me.
These databases were produced in SQLite3.

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