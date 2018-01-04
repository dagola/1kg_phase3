
source("../init.R", chdir = TRUE)

##============================================================================+
## load R packages ----
##============================================================================+
if (!require(pacman)) {
  install.packages("pacman")
}
pacman::p_load(batchtools)
pacman::p_load(R.utils)

##============================================================================+
## setup batchtools ----
##============================================================================+
slurmtmpl_file <- file.path(getwd(), "batchtools_config/slurm.batchtools.tmpl")
slurm_btconf_file <- file.path(getwd(), "batchtools_config/batchtools.slurm.R")
interactive_btconf_file <- file.path(getwd(), "batchtools_config/batchtools.interactive.R")
multicore_btconf_file <- file.path(getwd(), "batchtools_config/batchtools.multicore.R")

##============================================================================+
## custom functions ----
##============================================================================+
R.utils::sourceDirectory(file.path(scripts_dir, "functions"))
