
source("../init.R", chdir = TRUE)

##============================================================================+
## load R packages ----                                                       |
##============================================================================+
if(!require(pacman)) {
  install.packages("pacman", upgrade_dependencies = FALSE)
}
pacman::p_load(data.table)
if(!require(imbs)) {
  pacman::p_install_gh("imbs-hl/imbs", upgrade_dependencies = FALSE)
}
pacman::p_load(imbs)
pacman::p_load(tools)

##============================================================================+
## seed ----
##============================================================================+
seed <- 20180104
set.seed(seed)

##============================================================================+
## files & dirs ----
##============================================================================+
dups_file <- file.path(proc_dir, "1kg.phase3.v5a.dups")
long_indels_file <- file.path(proc_dir, "1kg.phase3.v5a.longindels")
