
##============================================================================+
## directories setup ----
##============================================================================+
user <- Sys.info()["user"]
system <- Sys.info()["nodename"]
home <- Sys.getenv("HOME")
project_name <- "1kg_phase3"
work_dirs <- list(
  damian = "documents"
)
main_dir <- file.path(home,
                      work_dirs[[system]][[user]],
                      project_name)

dir.create(scripts_dir <- file.path(main_dir, "scripts"),
           recursive = TRUE, showWarnings = FALSE)
dir.create(report_dir <- file.path(main_dir, "report"),
           recursive = TRUE, showWarnings = FALSE)

input_dir <- "/data"
input_dir_1kg_phase3 <- file.path(input_dir, "1000G", "release", "20130502")
input_dir_human_ref <- file.path(input_dir, "GRCh37REF")
dir.create(
  path = project_dir <- file.path(input_dir_1kg_phase3, "converted"),
  recursive = TRUE, showWarnings = FALSE
)

dir.create(
  path = proc_dir <- file.path(project_dir, "proc"),
  recursive = TRUE, showWarnings = FALSE
)

dir.create(
  path = reg_dir <- file.path(project_dir, "registries"),
  recursive = TRUE, showWarnings = FALSE
)

dir.create(
  path = output_dir <- file.path(project_dir, "output"),
  recursive = TRUE, showWarnings = FALSE
)

##============================================================================+
## rds files ----
##============================================================================+

##============================================================================+
## parameters ----
##============================================================================+

##============================================================================+
## external software ----
##============================================================================+
bcftools_exec <- "/home/damian/bin/bcftools1.9"
genotype_harmonizer_exec <- "/home/damian/bin/GenotypeHarmonizer1.4.20"
plink_exec <- "/home/damian/bin/plink1.90b6.10"
plink2_exec <- "damian.novalocal" = "/home/damian/bin/plink2.0a20190617"
gcta_exec <- "/home/damian/bin/gcta1.92.2b"
