## Commentary
My initial attempt at making a regression model, with the three SAS files stored here, actually excludes a variable I was especially excited to test, that being transfer GPA. More commentary on the motivations can be found in the SQL folder, but the essence is that, if only organizing by whether or not applications have transfer GPAs, first-time first-years (FTFY/freshmen) with transfer GPAs are more often accepted, implying that dual enrollment could have profound impact on one's admissions success at CSULB. My initial plan was also to run across every major in 2022. Variables of interest would have been high school GPA, transfer GPA, major, and local/non-local — the main four that should have substantial impact.

At the suggestion of my professor, Dr. Olga Korosteleva, I did truncate this down to just the math department's 2022 applications, with the inclusions of ethnicity and sex and the exclusion of transfer GPA since only about 1% of the math department applications had transfer GPAs. It's doubtful if a viable conclusion/model can be gleaned from something like that.

Out of curiosity, though, I did make two extra regression models: "all majors, categorical transfer" truncates all transfer GPA entries as just they had it or did not, whereas "all majors, continuous transfer" includes the GPA. Since I lacked the number of dual enrollment classes, I believed that the presence was more important to examine than the actual transfer GPA, as it's possible for someone with a 3-point-something to have taken 12 CC classes while a 4.0 took anywhere from 1 to 12. How CSULB would weigh this is a secondary question entirely. Since these were more for my curiosity, their aesthetics are underprepared.

I am one of the students with transfer GPAs.