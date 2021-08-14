
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