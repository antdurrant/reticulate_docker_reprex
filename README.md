
# reticulate_docker_reprex

<!-- badges: start -->
<!-- badges: end -->

The goal of reticulate_docker_reprex is to ...

a) see if I can simplify it down enough

b) say thanks to Tan for maybe looking at it


#### Problems

without `use_condaenv()` in app.R:
`
> Warning: Error in : Python shared library not found, Python bindings not loaded.
`
	
BUT running from the command line works fine

```
> synsets("dog")

[[1]]
Synset('dog.n.01')

[[2]]
Synset('frump.n.01')

[[3]]
Synset('dog.n.03')

[[4]]
Synset('cad.n.01')...
```

with `use_condaenv()` in app.R:
`
> Warning: Error in : Python shared library not found, Python bindings not loaded.
`
AND running from the command line results in errors
```
 - cannot find nltk, use "ntlk.download('wordnet')"
 - looked in places X,Y,Z
 ```
 
 
with `use_condaenv(conda = "opt/conda")` in app.R:
```
Error: Specified conda binary 'opt/conda' does not exist.

Execution halted
[INFO] shiny-server - Error getting worker: Error: The application exited during initialization. 
 ```
 
BUT works fine from the command line

```
> nltk <- reticulate::import("nltk")
> synsets <- function(x){
+   res<- nltk$wordnet$wordnet$synsets(x)
+   res
+ }
> 
> synsets("dog")

[[1]]
Synset('dog.n.01')

[[2]]
Synset('frump.n.01')... 
```