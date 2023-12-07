# Reproducible research: version control and R

\# INSERT ANSWERS HERE #

QUESTIONS 1, 2 and 3:  
* Link to the logistic_growth repo: https://github.com/tgbhujm/logistic_growth.git  

QUESTION 4:
* A script for simulating a random_walk is provided in the question-4-code folder of this repo. Execute the code to produce the paths of two random walks. What do you observe? (10 points)
  
The random walk function creates a data frame containing three columns: the first one is the x-coordinates of an object, the second one is its y-coordinates, and the third one is time. The number of rows is n, where n is the number of timepoint at which the position of the object is recorded. The starting point of the function is set – c(0,0,1) means that the initial coordinates of the object at time 1 are (0,0). The subsequent coordinates are determined by randomly assigning an angle at which the object moves in 2D space. When plotted using ggplot, this yields a coordinate system with the path of the object; the color of the path changes with time, which makes it easier to visually track the movement of the object.
In this example, the random walk function is run twice. But despite n being specified as 500 in both cases, the two plots and hence two paths are different. This is because even though the starting point is the same, the subsequent angles at which the object moves are chosen at random, which in turn specify the direction of movement. Each line linking consecutive positions is of the same length (0.25, specified in the function), which explains why the object does not make jumps of different lengths.
* Investigate the term random seeds. What is a random seed and how does it work? (5 points)  

A random seed is usually an integer vector which is used to initiate the generation of pseudorandom numbers. Pseudorandom numbers differ from true random numbers in that while true random numbers are generated based on properties of unpredictable physical phenomena (such as Brownian motion), pseudorandom numbers are generated based on a deterministic algorithm (such as that used in R to simulate Brownian motion in the example above). An algorithm is deterministic because as long as you know the seed (initial starting point of the generation) and the state of the random number generator (type of algorithm), you can generate the same pseudorandom numbers regardless of how many times you run a simulation. This is important with respect to data reproducibility, because if a given analysis involves generating e.g., a random sample of the population, you would want your collaborators to be working with the same random sample (numbers). This can be achieved via the function set.seed() in R, when in the brackets you write a random number. As long as your collaborator writes the same number in the brackets before running the simulation, the variables will be assigned the same random values as those that you have been working with.  
* Edit the script to make a reproducible simulation of Brownian motion. Commit the file and push it to your forked reproducible-research_homework repo. (10 points)  

Done - see below  
* Go to your commit history and click on the latest commit. Show the edit you made to the code in the comparison view (add this image to the README.md of the fork). (5 points)  
![Q4_comparing_commits](https://github.com/tgbhujm/reproducible-research_homework/assets/150151014/fd94e31b-4b1a-406f-9a1a-54d7fe0ef0d8)


QUESTION 5:
* Import the data for double-stranded DNA (dsDNA) viruses taken from the Supplementary Materials of the original paper into Posit Cloud (the csv file is in the question-5-data folder). How many rows and columns does the table have? (3 points)  

The table has 33 rows, each of which represents a virus sequence record.
The table also has 13 columns covering different viral characteristics: Family, Genus, Type species, GenBank accession no., Envelope, Virion type, T, Virion diameter (nm), Virion length (nm), Virion volume (nm3), Molecule, Genome length (kb), Protein no.
* What transformation can you use to fit a linear model to the data? Apply the transformation. (3 points)  
  
V = βL^α is a multiplicative equation – therefore, it becomes linear when it is log-transformed. The base is not relevant, so we can arbitrarily choose the natural log (ln). The transformation will yield the equation lnV = ln(βL^α), equivalent to lnV = lnβ + ln(L^α), equivalent to lnV = lnβ + αlnL. This means that when you estimate α and β, you can predict lnV from lnL (hence V from L), using a linear equation.
* Find the exponent (α) and scaling factor (β) of the allometric law for dsDNA viruses and write the p-values from the model you obtained, are they statistically significant? Compare the values you found to those shown in Table 2 of the paper, did you find the same values? (10 points)
  
lnV = lnβ + αlnL is a linear equation where α is the slope and lnβ the intercept. We can use linear regression to model the equation. When running the summary function on the lm(lnV ~ lnL), we get 1.5152 as a value for the exponent α (slope), and 7.0748 as a value for lnβ (intercept). Therefore, the scaling factor β is e^7.0748 = 1181.8071. When rounded, both α and β match the values in Table 2 of the paper by Cui et al., 2014 for dsDNA viruses: α = 1.52, β = 1182.  
The p-values from the model are 2.28e-10 for the intercept (lnβ), and 6.44e-10 for the slope (α). Both values are statistically significant, because they are well below the threshold of 0.05 (which is usually used for analyzing biological data).  
(NOTE: SEE FILE "question-5-code" FOR THE ACTUAL CODE)  
* Write the code to reproduce the figure shown below. (10 points)  
  
ggplot(data = cui_new, aes(x = lnL, y = lnV))+  
  geom_point()+  
  ylim(8.5,20.4)+  
  labs(x = "log [Genome length (kb)]", y = "log [Virion volume (nm3)]")+  
  theme_bw()+  
  theme(axis.title.x = element_text(face="bold", size = 9.5),  
        axis.title.y = element_text(face="bold", size = 9.5))+  
  geom_smooth(method = "lm", size = 0.6, fullrange = TRUE)  

The resulting figure is as shown:  
![Q5_recreateplot](https://github.com/tgbhujm/reproducible-research_homework/assets/150151014/9216ef86-7f6c-4445-98e9-d319e33d08b1)  

* What is the estimated volume of a 300 kb dsDNA virus? (4 points)
  
Using the equation V = βL^α, and the values α = 1.52, β = 1182 for the exponent and scaling factor respectively, we can estimate the volume of a dsDNA virus with a 300 kb long genome:  
V = βL^α => V = 1182 x 300^1.52 => V = 6 884 014.62 nm3

BONUS QUESTION (10 points):  
* Explain the diﬀerence between reproducibility and replicability in scientiﬁc research. How can git and GitHub be used to enhance the reproducibility and replicability of your work? what limitations do they have? (e.g. check the platform protocols.io).

In scientific research, data analysis is considered to be well executed if it has 4 characteristics: reproducible, replicable, robust, and generalizable. For the purpose of this assignment, I will focus on the first two.  
Reproducibility means that the same data can be analysed in the same way multiple times, with the same results/conclusions being reached every time. This requires for the all the data and methods to be provided in a self-explanatory form, so that e.g., a third person can recreate the whole process. In contrast, replicability involves the use of DIFFERENT data, which is being analysed in the same way, yielding the same results. This requires specifically the methods to be applicable to different datasets, so that researches that have collected their own data can apply them.  
The reproducibility and replicability of a project can be enhanced using git and GitHub. While git is a version control system which, as the name suggests, allows researchers to track the changes (different versions) of the project, GitHub is web-based interface that uses git. Therefore, one can use git without GitHub, but not vice-versa.  

The features of git and GitHub that enhance research reproducibility and replicability include:  

* the main body of the project can remain unaltered until the researcher is certain that their analysis works. In other words, one can “branch” the repository so that there are multiple versions. The researcher can work on one of the branches, so if mistakes are made, there is always the main branch that one can go back to.  
* the repository can be shared among collaborators. This means that multiple individuals can work with the same data/analysis simultaneously, greatly contributing to both the reproducibility and the replicability of the work. If collaborators were storing their progress solely on their own device, it would likely not be in a format that is suited to multiple users (e.g., the read.csv function would read a location on your computer, which would differ from that on somebody else’s computer).  
* GitHub is cloud-based. This is important, because if a researcher’s own device was to stop working, the data and analysis will not be lost.  
With that said, git and GitHub have their disadvantages. Since they keep the whole history of a project, if that history is very long and contains many big files, the performance of GitHub might suffer. Unfortunately, if a user does need a large file, it cannot be uploaded, because the maximum file size for GitHub repository upload is 50 MB. This could be a problem for individuals dealing with very large datasets. In addition, although git is open-use, the paid versions of GitHub can be expensive. Lastly, git and GitHub are arguably not very intuitive to use, so it takes a while for researchers to get accustomed to dealing with them. Difficulties may include the number of steps necessary to push a change from Posit cloud to GitHub, the number and complexity of windows that appear when one wants to merge branches, etc. 


## Instructions

The homework for this Computer skills practical is divided into 5 questions for a total of 100 points (plus an optional bonus question worth 10 extra points). First, fork this repo and make sure your fork is made **Public** for marking. Answers should be added to the # INSERT ANSWERS HERE # section above in the **README.md** file of your forked repository.

Questions 1, 2 and 3 should be answered in the **README.md** file of the `logistic_growth` repo that you forked during the practical. To answer those questions here, simply include a link to your logistic_growth repo.

**Submission**: Please submit a single **PDF** file with your candidate number (and no other identifying information), and a link to your fork of the `reproducible-research_homework` repo with the completed answers. All answers should be on the `main` branch.

## Assignment questions 

1) (**10 points**) Annotate the **README.md** file in your `logistic_growth` repo with more detailed information about the analysis. Add a section on the results and include the estimates for $N_0$, $r$ and $K$ (mention which *.csv file you used).
   
2) (**10 points**) Use your estimates of $N_0$ and $r$ to calculate the population size at $t$ = 4980 min, assuming that the population grows exponentially. How does it compare to the population size predicted under logistic growth? 

3) (**20 points**) Add an R script to your repository that makes a graph comparing the exponential and logistic growth curves (using the same parameter estimates you found). Upload this graph to your repo and include it in the **README.md** file so it can be viewed in the repo homepage.
   
4) (**30 points**) Sometimes we are interested in modelling a process that involves randomness. A good example is Brownian motion. We will explore how to simulate a random process in a way that it is reproducible:

   - A script for simulating a random_walk is provided in the `question-4-code` folder of this repo. Execute the code to produce the paths of two random walks. What do you observe? (10 points)
   - Investigate the term **random seeds**. What is a random seed and how does it work? (5 points)
   - Edit the script to make a reproducible simulation of Brownian motion. Commit the file and push it to your forked `reproducible-research_homework` repo. (10 points)
   - Go to your commit history and click on the latest commit. Show the edit you made to the code in the comparison view (add this image to the **README.md** of the fork). (5 points)

5) (**30 points**) In 2014, Cui, Schlub and Holmes published an article in the *Journal of Virology* (doi: https://doi.org/10.1128/jvi.00362-14) showing that the size of viral particles, more specifically their volume, could be predicted from their genome size (length). They found that this relationship can be modelled using an allometric equation of the form **$`V = \beta L^{\alpha}`$**, where $`V`$ is the virion volume in nm<sup>3</sup> and $`L`$ is the genome length in nucleotides.

   - Import the data for double-stranded DNA (dsDNA) viruses taken from the Supplementary Materials of the original paper into Posit Cloud (the csv file is in the `question-5-data` folder). How many rows and columns does the table have? (3 points)
   - What transformation can you use to fit a linear model to the data? Apply the transformation. (3 points)
   - Find the exponent ($\alpha$) and scaling factor ($\beta$) of the allometric law for dsDNA viruses and write the p-values from the model you obtained, are they statistically significant? Compare the values you found to those shown in **Table 2** of the paper, did you find the same values? (10 points)
   - Write the code to reproduce the figure shown below. (10 points)

  <p align="center">
     <img src="https://github.com/josegabrielnb/reproducible-research_homework/blob/main/question-5-data/allometric_scaling.png" width="600" height="500">
  </p>

  - What is the estimated volume of a 300 kb dsDNA virus? (4 points)

**Bonus** (**10 points**) Explain the difference between reproducibility and replicability in scientific research. How can git and GitHub be used to enhance the reproducibility and replicability of your work? what limitations do they have? (e.g. check the platform [protocols.io](https://www.protocols.io/)).
