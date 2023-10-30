# Innovations from assignment

While the regression models are fairly mundane, they do contain a few deviations from my professor's expectations. I will make no claim to being phenomenal, but I will make some claim to wanting to constantly improve the efficiency of my programs and a willingness to learn the steps to do so.

* The SAS code uses macros to automatically output several things, including:
    * Model fit is outputted to a csv file in temp outputs that the Reader.ipnyb file uses.
    * Log-likelihood values from model fit and null model.
    * The number of degrees of freedoms.
    * Automatic deviance test from the above two.
    * Outputting only the final row during prediction.

Likewise, I created 2 Python aids for the first homework assignment:
* The Reader.ipnyb automatically reads out parameters and estimates to create a LaTex equation.
* The Writer.ipnyb takes in several user inputs, e.g. the exercise number, response variables, modifications to any variables, distribution, and link function, to write most of the SAS models. This has not been updated to deal with later regressions, e.g. cumulative logit (which requires proc format)

Furthermore, the Python models were entirely self-taught and derived from searches online with minimal direction from my professor. This arose as a favor to her, as her current textbook uses R and SAS. It does not currently have Python regression models. Python models that were made for homework are stored in the corresponding homework file, whereas Python models made for exercises in her textbook are stored in Txtbk_ex_python.