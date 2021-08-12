library(reticulate)


# use_condaenv()
# use_condaenv(conda = "opt/conda")
nltk <- reticulate::import("nltk")

synsets <- function(x){
  res<- nltk$wordnet$wordnet$synsets(x)
  res
}

synsets("dog")

synset <- function(x) {
  nltk$wordnet$wordnet$synset(x)
}

synset('dog.n.01')$lemma_names(lang = "fra")
