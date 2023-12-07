#equation: lnV = lnb + alnL

# Loading packages:
library(dplyr)
library(ggplot2)

# Loading the data:
Cui_etal2014 <- read_csv("/cloud/project/question-5-data/Cui_etal2014.csv")
Cui_etal2014

# Renaming columns in the dataset:
cui_new <- Cui_etal2014 %>% 
  rename('V' = `Virion volume (nm×nm×nm)`) %>%
  rename('L' = `Genome length (kb)`)
cui_new

# Calculating the natural logs of V and L:
lnV <- log(cui_new$V)
lnL <- log(cui_new$L)

# Fitting a linear model:
linear <- lm(lnV ~ lnL, cui_new)

# Generating a coefficients' table:
summary(linear)

# Recreating the plot:
ggplot(data = cui_new, aes(x = lnL, y = lnV))+
  geom_point()+
  ylim(8.5,20.4)+
  labs(x = "log [Genome length (kb)]", y = "log [Virion volume (nm3)]")+
  theme_bw()+
  theme(axis.title.x = element_text(face="bold", size = 9.5),
        axis.title.y = element_text(face="bold", size = 9.5))+
  geom_smooth(method = "lm", size = 0.6, fullrange = TRUE)
