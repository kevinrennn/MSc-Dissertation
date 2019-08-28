### This script computes cosine similarity measures based on the word embeddings
### models trained using the embed_batch.R file. 

### As it is set up now, the script will calculate the average cosine similarity 
### between 'inflation' and negative/positive words from the Lexicoder 
### Sentiment Dictionary (LSD). It can easily be adjusted using the parameters
### in the `compute` function. 

### To execute this script:

  ### 1. Set the working directory;
  ### 2. Load the corpus and name it 'nyt';
  ### 3. Provide the path that contains the trained embedding outputs. 

### Script developed by Michel Dilmanian


#############
### Setup ###
#############

# Set directory and load data file (corpus)
setwd('WORKING_DIRECTORY')
load('nytinf_clean_qtr')

# Name the data object "nyt" to run this script
nyt <- nytinf_clean_qtr

# Import word embedding functions from separate R script
source('embed_funcs.R')

# Path for analysis
path <- 'path/for/trained/embeddings/outputs'

# Set parameters for analysis
# (Determines for which rows of the corpus cosine similarity is computed)
nstart <- 53
nend <- 272

#########################
### Load dictionaries ###
#########################

# Load dictionaries
library(quanteda)
library(quanteda.dictionaries)

### Extract lists of words for analysis

# Positive/negative sentiment from LSD dictionary
neg_dict <- data_dictionary_LSD2015$negative
pos_dict <- data_dictionary_LSD2015$positive

# Fear/trust from NRC dictionary
fear_dict <- data_dictionary_NRC$fear
trust_dict <- data_dictionary_NRC$trust


###################################
### Compute cosine similarities ###
###################################

# Generate vectors to store results
embed_neg <- rep(NA, nrow(nyt))
embed_pos <- rep(NA, nrow(nyt))

# Run analysis for rows specified by 'nstart' and 'nend' 
for (i in nstart:nend){
  
  message(i)
  # Assign path to filename variable
  filename <- paste0(path, i)
  # Get matrix of embeddings
  trainedvecs <- extractmat(filename)
  # Compute similarity measures
  neg <- compute(wordvectors = trainedvecs, 
                 dictwords = neg_dict,
                 target = 'inflation')
  pos <- compute(wordvectors = trainedvecs, 
                 dictwords = pos_dict,
                 target = 'inflation')
  # Assign
  embed_neg[i] <- neg
  embed_pos[i] <- pos

}


