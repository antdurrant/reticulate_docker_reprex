
# reticulate_docker_reprex

<!-- badges: start -->
<!-- badges: end -->

The goal of reticulate_docker_reprex is to figure out how to connect a specified python to shiny apps in docker.


## Problems


### `/with_condaenv_auto`

#### `app.R`

```
Listening on http://127.0.0.1:36559


*** '/var/log/shiny-server//rmd-shiny-20210814-040937-46759.log' has been deleted ***


*** '/var/log/shiny-server//hello-shiny-20210814-040937-36565.log' has been deleted ***


*** /var/log/shiny-server//with_condaenv_auto-shiny-20210814-040946-36559.log ***


CondaHTTPError: HTTP 000 CONNECTION FAILED for url <https://conda.anaconda.org/conda-forge/linux-64/current_repodata.json>

Elapsed: -


An HTTP error occurred when trying to retrieve this URL.

HTTP errors are often intermittent, and a simple retry will get you on your way.

'https://conda.anaconda.org/conda-forge/linux-64'



Warning: Error in : Error 1 occurred creating conda environment r-reticulate

103: stop

102: conda_create

101: py_discover_config

100: initialize_python

99: ensure_python_initialized

98: reticulate::import

97: get_translation [/srv/shiny-server/with_condaenv_auto/app.R#9]

96: renderText [/srv/shiny-server/with_condaenv_auto/app.R#58]

95: func

82: renderFunc

81: output$translation

1: runApp
```


_on retry_

```
*** '/var/log/shiny-server//with_condaenv_auto-shiny-20210814-060800-34817.log' has been created ***


*** /var/log/shiny-server//with_condaenv_auto-shiny-20210814-060800-34817.log ***

su: ignoring --preserve-environment, it's mutually exclusive with --login

── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

✔ ggplot2 3.3.3 ✔ purrr 0.3.4

✔ tibble 3.1.0 ✔ dplyr 1.0.5

✔ tidyr 1.1.3 ✔ stringr 1.4.0

✔ readr 1.4.0 ✔ forcats 0.5.1

── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──

✖ dplyr::filter() masks stats::filter()

✖ dplyr::lag() masks stats::lag()


Listening on http://127.0.0.1:34817

Warning: Error in py_module_import: ModuleNotFoundError: No module named 'nltk'


Detailed traceback:

File "/usr/local/lib/R/site-library/reticulate/python/rpytools/loader.py", line 44, in _import_hook

level=level


101: <Anonymous>
```

so is it making a new condaenv?

#### CLI

```
> library(shiny)
> library(reticulate)
> library(tidyverse)
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
✔ ggplot2 3.3.3     ✔ purrr   0.3.4
✔ tibble  3.1.0     ✔ dplyr   1.0.5
✔ tidyr   1.1.3     ✔ stringr 1.4.0
✔ readr   1.4.0     ✔ forcats 0.5.1
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
> 
> use_condaenv()
> get_translation <- function(token, part_of_speech, language){
+     # for every synset that contains the token and matches the part_of_speech
+     synsets <- reticulate::import("nltk", delay_load = FALSE)$wordnet$wordnet$synsets
+     
+         purrr::map(
+             1:length(synsets(token, pos = part_of_speech)) ,
+             ~synsets(token, pos = part_of_speech)[[.x]]$lemma_names(lang = language)[1]
+         ) %>%
+             # lose anything that did not return a value
+             purrr::discard(is.null) %>%
+             unlist() %>%
+             stringr::str_flatten(collapse = " || ") 
+         }
> 
> get_translation(token = "dog", part_of_speech = "n", language = "fra")
[1] "canis_familiaris || chien || chien || achille || chien || chien || chien"
Warning message:
Python '/home/shiny/.conda/envs/r-reticulate/bin/python' was requested but '/opt/conda/bin/python' was loaded instead (see reticulate::py_config() for more information) 
> 
```

yes, it looks like it is...

### `with_condaenv_def`

### `app.R`

```
*** '/var/log/shiny-server//with_condaenv_auto-shiny-20210814-040946-36559.log' has been deleted ***


*** '/var/log/shiny-server//with_condaenv_def-shiny-20210814-042023-40421.log' has been created ***


*** /var/log/shiny-server//with_condaenv_def-shiny-20210814-042023-40421.log ***

su: ignoring --preserve-environment, it's mutually exclusive with --login

[2021-08-14T04:20:26.833] [INFO] shiny-server - Error getting worker: Error: The application exited during initialization.

── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

✔ ggplot2 3.3.3 ✔ purrr 0.3.4

✔ tibble 3.1.0 ✔ dplyr 1.0.5

✔ tidyr 1.1.3 ✔ stringr 1.4.0

✔ readr 1.4.0 ✔ forcats 0.5.1

── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──

✖ dplyr::filter() masks stats::filter()

✖ dplyr::lag() masks stats::lag()

Error: Specified conda binary '/home/shiny/opt/conda/bin/conda' does not exist.

Execution halted

```

_clearly I don't know where/what the binary is?_

#### CLI

```
> library(shiny)
> library(reticulate)
> library(tidyverse)
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
✔ ggplot2 3.3.3     ✔ purrr   0.3.4
✔ tibble  3.1.0     ✔ dplyr   1.0.5
✔ tidyr   1.1.3     ✔ stringr 1.4.0
✔ readr   1.4.0     ✔ forcats 0.5.1
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
> 
> use_condaenv(conda = "~/opt/conda/bin/conda")
Error: Specified conda binary '/root/opt/conda/bin/conda' does not exist.
> 
> get_translation <- function(token, part_of_speech, language){
+     # for every synset that contains the token and matches the part_of_speech
+     synsets <- reticulate::import("nltk", delay_load = FALSE)$wordnet$wordnet$synsets
+     
+         purrr::map(
+             1:length(synsets(token, pos = part_of_speech)) ,
+             ~synsets(token, pos = part_of_speech)[[.x]]$lemma_names(lang = language)[1]
+         ) %>%
+             # lose anything that did not return a value
+             purrr::discard(is.null) %>%
+             unlist() %>%
+             stringr::str_flatten(collapse = " || ") 
+         }
> get_translation(token = "dog", part_of_speech = "n", language = "fra")
[1] "canis_familiaris || chien || chien || achille || chien || chien || chien"
> 
```
_clearly I don't know where/what the binary is?_


### `/with_nothing`

#### `app.R`

```
*** '/var/log/shiny-server//with_nothing-shiny-20210814-041426-37891.log' has been created ***


*** /var/log/shiny-server//with_nothing-shiny-20210814-041426-37891.log ***

su: ignoring --preserve-environment, it's mutually exclusive with --login

── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

✔ ggplot2 3.3.3 ✔ purrr 0.3.4

✔ tibble 3.1.0 ✔ dplyr 1.0.5

✔ tidyr 1.1.3 ✔ stringr 1.4.0

✔ readr 1.4.0 ✔ forcats 0.5.1

── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──

✖ dplyr::filter() masks stats::filter()

✖ dplyr::lag() masks stats::lag()


Listening on http://127.0.0.1:37891

Warning: Error in : Python shared library not found, Python bindings not loaded.

Use reticulate::install_miniconda() if you'd like to install a Miniconda Python environment.

102: stop

101: python_not_found

100: initialize_python

99: ensure_python_initialized

98: reticulate::import

97: get_translation [/srv/shiny-server/with_nothing/app.R#9]

96: renderText [/srv/shiny-server/with_nothing/app.R#58]

95: func

82: renderFunc

81: output$translation

1: runApp
```


#### CLI

```
> library(reticulate)
> library(tidyverse)

── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
✔ ggplot2 3.3.3     ✔ purrr   0.3.4
✔ tibble  3.1.0     ✔ dplyr   1.0.5
✔ tidyr   1.1.3     ✔ stringr 1.4.0
✔ readr   1.4.0     ✔ forcats 0.5.1
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
> 
> get_translation <- function(token, part_of_speech, language){
+     # for every synset that contains the token and matches the part_of_speech
+     synsets <- reticulate::import("nltk", delay_load = FALSE)$wordnet$wordnet$synsets
+     
+         purrr::map(
+             1:length(synsets(token, pos = part_of_speech)) ,
+             ~synsets(token, pos = part_of_speech)[[.x]]$lemma_names(lang = language)[1]
+         ) %>%
+             # lose anything that did not return a value
+             purrr::discard(is.null) %>%
+             unlist() %>%
+             stringr::str_flatten(collapse = " || ") 
+         }
> get_translation(token = "dog", part_of_speech = "n", language = "fra")
[1] "canis_familiaris || chien || chien || achille || chien || chien || chien"
> 
```



### `/with_python_auto`

#### `app.R`

```
*** '/var/log/shiny-server//with_nothing-shiny-20210814-041426-37891.log' has been deleted ***


*** '/var/log/shiny-server//with_python_auto-shiny-20210814-042301-35233.log' has been created ***

[2021-08-14T04:23:04.308] [INFO] shiny-server - Error getting worker: Error: The application exited during initialization.


*** /var/log/shiny-server//with_python_auto-shiny-20210814-042301-35233.log ***

su: ignoring --preserve-environment, it's mutually exclusive with --login

── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

✔ ggplot2 3.3.3 ✔ purrr 0.3.4

✔ tibble 3.1.0 ✔ dplyr 1.0.5

✔ tidyr 1.1.3 ✔ stringr 1.4.0

✔ readr 1.4.0 ✔ forcats 0.5.1

── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──

✖ dplyr::filter() masks stats::filter()

✖ dplyr::lag() masks stats::lag()

Error in unique(c(.globals$use_python_versions, python)) :

argument "python" is missing, with no default

Calls: runApp ... eval -> eval -> ..stacktraceon.. -> use_python -> unique

Execution halted
```

_oh, `use_python()` does not have an _auto-find_

### `/with_python_def`

#### `app.R`

```
*** '/var/log/shiny-server//with_python_def-shiny-20210814-060132-45627.log' has been created ***


*** /var/log/shiny-server//with_python_def-shiny-20210814-060132-45627.log ***

su: ignoring --preserve-environment, it's mutually exclusive with --login

── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

✔ ggplot2 3.3.3 ✔ purrr 0.3.4

✔ tibble 3.1.0 ✔ dplyr 1.0.5

✔ tidyr 1.1.3 ✔ stringr 1.4.0

✔ readr 1.4.0 ✔ forcats 0.5.1

── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──

✖ dplyr::filter() masks stats::filter()

✖ dplyr::lag() masks stats::lag()


Listening on http://127.0.0.1:45627

Warning: Error in : Python shared library not found, Python bindings not loaded.

Use reticulate::install_miniconda() if you'd like to install a Miniconda Python environment.

102: stop

101: python_not_found

100: initialize_python

99: ensure_python_initialized

98: reticulate::import

97: get_translation [/srv/shiny-server/with_python_def/app.R#9]

96: renderText [/srv/shiny-server/with_python_def/app.R#58]

95: func

82: renderFunc

81: output$translation

1: runApp
```


### CLI

```

> library(shiny)
> library(reticulate)
> library(tidyverse)
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
✔ ggplot2 3.3.3     ✔ purrr   0.3.4
✔ tibble  3.1.0     ✔ dplyr   1.0.5
✔ tidyr   1.1.3     ✔ stringr 1.4.0
✔ readr   1.4.0     ✔ forcats 0.5.1
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
> 
> use_python(python = "~/opt/conda/bin/python")
> 
> get_translation <- function(token, part_of_speech, language){
+     # for every synset that contains the token and matches the part_of_speech
+     synsets <- reticulate::import("nltk", delay_load = FALSE)$wordnet$wordnet$synsets
+     
+         purrr::map(
+             1:length(synsets(token, pos = part_of_speech)) ,
+             ~synsets(token, pos = part_of_speech)[[.x]]$lemma_names(lang = language)[1]
+         ) %>%
+             # lose anything that did not return a value
+             purrr::discard(is.null) %>%
+             unlist() %>%
+             stringr::str_flatten(collapse = " || ") 
+         }
> get_translation(token = "dog", part_of_speech = "n", language = "fra")
[1] "canis_familiaris || chien || chien || achille || chien || chien || chien"
> 
```


### `with_python_named`

_after checking that `RETICULATE_PYTHON` actually is an environment variable through the CLI... maybe feeding "RETICULATE_PYTHON" to `use_python()` works?

#### `app.R`

nope

```
Listening on http://127.0.0.1:45523


*** '/var/log/shiny-server//rmd-shiny-20210814-062800-36843.log' has been deleted ***


*** '/var/log/shiny-server//hello-shiny-20210814-062800-38885.log' has been deleted ***


*** /var/log/shiny-server//with_python_named-shiny-20210814-062818-45523.log ***

Warning: Error in : Python shared library not found, Python bindings not loaded.

Use reticulate::install_miniconda() if you'd like to install a Miniconda Python environment.

102: stop

101: python_not_found

100: initialize_python

99: ensure_python_initialized

98: reticulate::import

97: get_translation [/srv/shiny-server/with_python_named/app.R#9]

96: renderText [/srv/shiny-server/with_python_named/app.R#58]

95: func

82: renderFunc

81: output$translation

1: runApp
```


#### CLI

_still_ just works fine

```
> library(shiny)
> library(reticulate)
> library(tidyverse)
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
✔ ggplot2 3.3.3     ✔ purrr   0.3.4
✔ tibble  3.1.0     ✔ dplyr   1.0.5
✔ tidyr   1.1.3     ✔ stringr 1.4.0
✔ readr   1.4.0     ✔ forcats 0.5.1
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
> 
> use_python(python = "RETICULATE_PYTHON")
> 
> get_translation <- function(token, part_of_speech, language){
+     # for every synset that contains the token and matches the part_of_speech
+     synsets <- reticulate::import("nltk", delay_load = FALSE)$wordnet$wordnet$synsets
+     
+         purrr::map(
+             1:length(synsets(token, pos = part_of_speech)) ,
+             ~synsets(token, pos = part_of_speech)[[.x]]$lemma_names(lang = language)[1]
+         ) %>%
+             # lose anything that did not return a value
+             purrr::discard(is.null) %>%
+             unlist() %>%
+             stringr::str_flatten(collapse = " || ") 
+         }
> get_translation ("dog", "n", "fra")
[1] "canis_familiaris || chien || chien || achille || chien || chien || chien"
> 
```

is it because I am running CLI from root?

...nope

1. Go to same directory as apps
```
# ls
bin   etc   lib    libexec  mnt   rocker_scripts  sbin	tmp
boot  home  lib32  libx32   opt   root		  srv	usr
dev   init  lib64  media    proc  run		  sys	var
# cd srv
# ls
shiny-server
# cd shiny-server
# ls
01_hello       05_sliders  09_upload	sample-apps	    with_python_auto
02_text        06_tabsets  10_download	with_condaenv_auto  with_python_def
03_reactivity  07_widgets  11_timer	with_condaenv_def   with_python_named
04_mpg	       08_html	   index.html	with_nothing
```

2. Launch R
```
# R  

R version 4.0.5 (2021-03-31) -- "Shake and Throw"
Copyright (C) 2021 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.
```

3. Check we are where we think we are
```
> list.files()
 [1] "01_hello"           "02_text"            "03_reactivity"     
 [4] "04_mpg"             "05_sliders"         "06_tabsets"        
 [7] "07_widgets"         "08_html"            "09_upload"         
[10] "10_download"        "11_timer"           "index.html"        
[13] "sample-apps"        "with_condaenv_auto" "with_condaenv_def" 
[16] "with_nothing"       "with_python_auto"   "with_python_def"   
[19] "with_python_named" 
> sessionInfo()
R version 4.0.5 (2021-03-31)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 20.04.2 LTS

Matrix products: default
BLAS/LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.8.so

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=C             
 [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

loaded via a namespace (and not attached):
[1] compiler_4.0.5
> library(shiny)
> library(reticulate)
> library(tidyverse)
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
✔ ggplot2 3.3.3     ✔ purrr   0.3.4
✔ tibble  3.1.0     ✔ dplyr   1.0.5
✔ tidyr   1.1.3     ✔ stringr 1.4.0
✔ readr   1.4.0     ✔ forcats 0.5.1
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
> 
> use_python(python = "RETICULATE_PYTHON")
> 
> get_translation <- function(token, part_of_speech, language){
+     # for every synset that contains the token and matches the part_of_speech
+     synsets <- reticulate::import("nltk", delay_load = FALSE)$wordnet$wordnet$synsets
+     
+         purrr::map(
+             1:length(synsets(token, pos = part_of_speech)) ,
+             ~synsets(token, pos = part_of_speech)[[.x]]$lemma_names(lang = language)[1]
+         ) %>%
+             # lose anything that did not return a value
+             purrr::discard(is.null) %>%
+             unlist() %>%
+             stringr::str_flatten(collapse = " || ") 
+         }
```

4. Check we are still there after loading python/nltk

```
> list.files()
 [1] "01_hello"           "02_text"            "03_reactivity"     
 [4] "04_mpg"             "05_sliders"         "06_tabsets"        
 [7] "07_widgets"         "08_html"            "09_upload"         
[10] "10_download"        "11_timer"           "index.html"        
[13] "sample-apps"        "with_condaenv_auto" "with_condaenv_def" 
[16] "with_nothing"       "with_python_auto"   "with_python_def"   
[19] "with_python_named" 
```

5. Try it ... yep, works fine

```
> get_translation("dog", "n", "fra")
[1] "canis_familiaris || chien || chien || achille || chien || chien || chien"
> 
```