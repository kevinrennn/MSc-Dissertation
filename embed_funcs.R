### This script generates the functions required to compute cosine 
### similarities based on trained word embedding models. 

### The first function extracts the embeddings vector for a specific word,
### the second creates a matrix of trained vectors based on an output file, 
### and the third computes the average cosine similarity between a target word
### and a set of dictionary words.

### Script developed by Michel Dilmanian

############################
### Function: extractvec ###
############################

# Extracts and returns vector for a specified word ('word') 
# from a matrix of trained word embeddings ('wordvectors')

extractvec <- function(word, wordvectors){
  
  # Find row matching word-pattern
  rownum <- grep(glob2rx(word), wordvectors[,1])
  # Assign to new object (data frame)
  # (Default word2vec output is 100 dimensions)
  vec <- wordvectors[rownum, 2:101]
  # Return transpose of data frame
  return(t(vec))
  
}

############################
### Function: extractmat ###
############################

# Creates and returns matrix of trained wordvectors based on the output
# of training the word2vec model. 'Filename' is the path excluding .txt suffix.

extractmat <- function(filename){
  return(
    read.table(paste0(filename, '.txt'), 
               skip = 1, fill = TRUE,
               stringsAsFactors = FALSE)
  )
}


#########################
### Function: compute ###
#########################

# Computes and returns average cosine similarity between a target word 
# ('target') and a list of dictionary words ('dictwords') from a matrix 
# of trained word embeddings ('wordvectors')

compute <- function(wordvectors, dictwords, target){  
  
  require(lsa)
  
  # Save vectors for relevant words
  inflation <- as.numeric(extractvec(paste(target), wordvectors))
  # Create matrix for wordvectors
  dict_mat <- as.matrix(inflation)
  colnames(dict_mat) <- paste(target)
  
  # Loop through dictionary terms
  for (w in dictwords){
    # Extract vector(s)
    dict_word <- extractvec(paste(w), wordvectors)
    # If not NA, zero, or numeric... 
    if (anyNA(dict_word) | all(dict_word == 0) | !is.numeric(dict_word)){
      next
    } else {
      # ... Add to matrix
      dict_mat <- cbind(dict_mat, dict_word)
    }
  }
  
  # Compute mean similarity b/w 'inflation' and all other words
  if (ncol(dict_mat) > 1){
    cosine <- mean(cosine(dict_mat)[-1,1])
  } else {
    cosine <- NA
  }
  
  # Return cosine similarity 
  return(cosine)
  
}

