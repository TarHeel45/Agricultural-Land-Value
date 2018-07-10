#this script is for importing and cleaning the agricultural land value data from the NASS

#import libraries -------------------------------------------------------------------------
library(tidyr)
library(readr)
library(stringr)
library(data.table)
library(formattable)
library(dplyr)

#import data ------------------------------------------------------------------------------
fre <- read_lines(file = "/Users/John/Desktop/Projects/Agricultural Land Values/Combined Data - Farm Real Estate.csv") #import data file

fre <- as.data.frame(fre) #convert to dataframe

#clean data -------------------------------------------------------------------------------
fre1 <- separate(fre, 1, paste0("X",1:25), sep = ",") #separate into individual columns

fre2 <- fre1 %>%
  setNames(c("X1", "X2", "State", paste(seq(1997, 2017, 1)), "Change")) %>%
  select(-X1, -X2, -Change) #rename columns and select columns of interest

fre3 <- fre2[8:76, ] #only keep individual state/region data 
rownames(fre3) <- 1:nrow(fre3) #renumber rows



fre3<- fre3[!fre3$State=="", ] #remove blank rows

fre3$LandCategory <- "Farm Real Estate" #Add column defining land category (more will come: Farm Real Estate, Cropland, Pasture, Irrigated and Non-Irrigated Cropland)
rownames(fre3) <- 1:nrow(fre3) #renumber rows

fre3$Region <- "Northeast" #define region column 
 

fre3$Region[13:16] <- "Lake States" #define region for each state 
fre3$Region[17:22] <- "Corn Belt"
fre3$Region[23:27] <- "Northern Plains"
fre3$Region[28:33] <- "Appalachian"
fre3$Region[34:38] <- "Southeast"
fre3$Region[39:42] <- "Delta States"
fre3$Region[43:45] <- "Southern Plains"
fre3$Region[46:54] <- "Mountain"
fre3$Region[55:58] <- "Pacific"
fre3$Region[59] <- "Continental U.S."
View(fre3)

fre3$State <- fre3$State %>%
  str_replace_all("[/21]", "") %>%
  str_replace_all("^  ", "") %>%
  str_replace_all(" $", "")

regions <- c("Northeast", "Lake", "Corn Belt", "Northern Plains", "Appalachian", "Southeast", "Delta", "Southern Plains", "Mountain", "Pacific", "United States")


View(fre3 %>%
  gather(paste(seq(1997,2017,1)), key = "Year", value = "Acre Value"))

fre3$`Region or State` = "State"
fre3$`Region or State`[fre3$State %in% regions] = "Region"

Land_Clean <- fre3 %>%
  gather(paste(seq(1997,2017,1)), key = "Year", value = "Acre Value")

View(Land_Clean)
write_csv(Land_Clean, "FRE_Values.csv")
?write_csv
