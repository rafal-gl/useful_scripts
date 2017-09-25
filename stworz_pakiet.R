#####################################################################
# Skrypt do budowy kolejnych wersji pakietu getinCRM
# Autor: Rafał Głąbski
#####################################################################

library(devtools)
library(roxygen2)
library(stringr)
library(dplyr)
old_wd <- getwd()
setwd("P:/Departament Kampanii/ZESPOL_ANALIZ/R/pakiety/budowa_pakietu")
options(devtools.desc.author="'First Last <first.last@example.com> [aut, cre]'")
unlink('getinCRM', recursive = TRUE)

### Numer następnej wersji ###
# Za change_ind wybierz liczbę od 1 do 4, im mniejsza tym ważniejsza zmiana 
# 1 - rewolucja
# 2 - nowe funkcje
# 3 - zmiana działania którejś z funkcji
# 4 - debug
change_ind = 4
change_levels = c("major", "minor", "build", "revision")

vers = grep(".tar.gz", dir("P:/Departament Kampanii/ZESPOL_ANALIZ/R/pakiety"), 
            value = TRUE)
vers = unlist(str_extract_all(vers, "\\d(\\.(\\d)+)*"))
last_ver = vers[rank(-as.numeric(gsub('\\.', '', vers)))[1]]
last_ver_num = as.numeric(strsplit(last_ver, "\\.")[[1]])
last_ver_num = c(last_ver_num, 
                 rep(0, length(change_levels) - length(last_ver_num)))
new_ver_num = last_ver_num
new_ver_num[change_ind] = new_ver_num[change_ind] + 1
if(change_ind < length(change_levels)) {
  new_ver_num[(change_ind + 1) : length(new_ver_num)] = 0
} 
new_ver = paste(new_ver_num, collapse = ".")

create(path = "getinCRM",
       description = list(Title = "Modelowanie w ZM DSG",
                          Version = new_ver,
                          Description = "Kilka przydatnych funkcji w modelowaniu predykcyjnym w Zespole Analiz i Modelowania w GNB",
                          License = "Internal use only",
                          "Authors@R" = "c(person(given = \"Rafal\", family = \"Glabski\", email = \"rafal.glabski@gnb.pl\", role = c(\"aut\", \"cre\")))", 
                          Author = "Rafal Glabski, Sebastian Gargas, Karol Urban",
                          Maintainer = "Rafal Glabski <rafal.glabski@gnb.pl>",
                          #Suggests = "ROracle",
                          Depends = "broom, C50, DBI, dplyr, geosphere, ggmap, ggplot2, methods, partykit, purrr, reshape2, rgeos, rJava, RJDBC, rjson, ROCR, RODBC, sp, stringr, tcltk, xtable",
                          Imports = "broom, C50, DBI, dplyr, geosphere, ggmap, ggplot2, methods, partykit, purrr, reshape2, rgeos, rJava, RJDBC, rjson, ROCR, RODBC, sp, stringr, tcltk, xtable",
                          Encoding = "UTF-8"))

file.copy(list.files("getinCRM_funkcje", full.names = TRUE),
          to = "getinCRM/R")
setwd("./getinCRM")
document()
setwd("..")
install("getinCRM")
library(getinCRM)
# check("getinCRM")

build(pkg = 'getinCRM', path = "P:/Departament Kampanii/ZESPOL_ANALIZ/R/pakiety")

setwd(old_wd)

# dokumentacja
# pack <- "getinCRM"
# path <- find.package(pack)
# system(paste(shQuote(file.path(R.home("bin"), "R")),
#              "CMD", "Rd2pdf", shQuote(path)))
