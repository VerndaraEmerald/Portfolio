# Innovations from assignment

While the regression models are fairly mundane, they do contain a few deviations from my professor's expectations. I will make no claim to being phenomenal, but I will make some claim to wanting to constantly improve the efficiency of my programs and a willingness to learn the steps to do so.

* The SAS code uses macros to automatically output several things, including:
    * Model fit is outputted to a csv file that the Reader.ipnyb file uses.
    * Log-likelihood values from model fit and null model.
    * The number of degrees of freedoms.
    * Automatic deviance test from the above two.
    * Outputting only the final row during prediction.

Likewise, I created 2 Python aids for the first homework assignment:
* The Reader.ipnyb automatically reads out parameters and estimates to create a LaTex equation.
* The Writer.ipnyb takes in several user inputs, e.g. the exercise number, response variables, modifications to any variables, distribution, and link function, to write most of the SAS models. This has not been updated to deal with later regressions, e.g. cumulative logit (which requires proc format)

Furthermore, the Python models were entirely self-taught and derived from searches online with minimal direction from my professor. This arose as a favor to her, as her current textbook uses R and SAS. It does not currently have Python regression models. Python models that were made for homework are stored in the corresponding homework file, whereas Python models made for exercises in her textbook are stored in Txtbk_ex_python.

# Project
Brief: Although I have come to realize my initial interest and conclusions for the admissions data set weren't statistically valid (just comparing admission rates for FTFY with and without transfer GPAs), the contexts of this project inspired me to seriously respect and become interested in the educational role commmunity colleges play in their immediate area.

The project uses a CSULB admissions data set that was previously available from CSULB's Institution of Research and Analytics (IR&A) in Spring of 2023, but access mysteriously vanished with no announcement after summer 2023 (the IR&A was apaprently restructured, so that may have some role). Since it was previously available, and since there was no announcement of wrongdoing on their end, I don't believe there was anything wrong with the data being available.

My initial interest in it arose from my good experience in a dual enrollment course at Golden West College, which had inspired me to seriously consider the role of community colleges in my immediate area. I became more interested when I discovered that the admissions dataset includes transfer GPAs for FTFY, which firstly implies that they dual enrolled and secondly is bizarre to have in a data set. I have never encountered any other university that had CSULB's level of data publically available nor distinguishes dual enrollment — the UCs come closest with their data, which have dual enrollment rolled up alongside honors and AP courses.

What was fascinating, though, was that FTFYs with any transfer GPA were accepted significantly more than those without. When considering that most dual enrollers have higher GPAs, though, it's clear that there's some other cause explaining both, anyway. Still, a cursory glance at the SQL databases does reveal that it can still be an edge on others within a GPA bin (e.g. in 3.0-3.99, those with transfer GPAs were accepted more often).

I've yet to perform a more detailed and certain statistical analysis on this data set. I strongly suspect the rate of dual enrolling is covariant with higher GPA, mitigating how much someone can say that merely dual enrolling will necessarily improve chances of admissions. As such, I would freely admit that, until then, using this to guide serious policy is a mistake; call this just a curiosity. Despite this, seeing the apparent effect of dual enrollment has still motivated my interest in education and educational economics, particularly in this sector of gifted children/advanced studies, of which dual enrollment is a part of.

Especially as someone in an Asian-American community, a lot of it is UC or bust, but with increasing demands on students, it's becoming at times less feasible or more stressful. Yet, I find that cultivating this respect towards community colleges — how they provide second chances for returning learners, opportunities for advanced students, and help create an inexpensive place of learning and collaboration — is really something worthwhile.

To conclude, I would like to thank the instructor of that dual enrollment art course, Don Ray McKinney. Seeing that intersection of lives, from an older Romanian woman who finally could express her art, to a mother-daughter pair, was very warming, and I'll remember it dearly.