#!/usr/bin/env Rscript

### This script enables the user to train the word embeddings model repeatedly
### on multiple corpora using batch files in Windows. This is needed in order 
### to create time-series variables based on word vectors trained on separate 
### corpora.
 
### R's implementation of word2vec terminates after a certain number of 
### iterations, so training the model in a loop within an R script is infeasible. 

### To execute this script, create a batch file with the following text:

# cd [enter working directory here]
# Rscript embed_batch.R [startrow1] [endrow2]
# Rscript embed_batch.R [startrow2] [endrow2]
# etc...

### This batch file will execute the R script for the given rows of the 
### corpus and restart after each iteration.

### Script developed by Michel Dilmanian

#############
### Setup ###
#############

# Pass arguments from command line
args <- commandArgs(trailingOnly = TRUE)
startrow_arg <- as.numeric(args[1])
endrow_arg <- as.numeric(args[2])

# Set working directory and load data file
setwd('WORKING_DIRECTORY')
load('nytinf_clean_qtr')

# Name the data object "nyt" to run this script
nyt <- nytinf_clean_qtr


###################################
### Fnc: train embeddings model ###
###################################

train <- function(rowindex, filename){
  
  library(rword2vec)

  # Write relevant text to txt file 
  write.table(nyt$text[rowindex], file = paste(filename), 
              sep = ' ', eol = ' ',
              row.names = FALSE, col.names = FALSE)
  
  # Train model
  word2vec(train_file = paste(filename), 
           output_file = paste0(filename, '.bin'),
           binary = 1, num_threads = 3,
           debug_mode = 1, iter = 15)
  
  # Convert .bin output file to .txt 
  bin_to_txt(paste0(filename, '.bin'), 
             paste0(filename, '.txt'))
  
}


#############################
### Run training function ###
#############################

# Run for each month of data
for (i in startrow_arg:endrow_arg){
  
  message(i)
  
  # Train embeddings model
  train(rowindex = i, filename = paste(i))
  
}

