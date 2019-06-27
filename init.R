
##============================================================================+
## directories setup ----
##============================================================================+
user <- Sys.info()["user"]
system <- Sys.info()["nodename"]
home <- Sys.getenv("HOME")
project_name <- "1kg_phase3"
work_dirs <- list(
  n01 = list(
    gola = "Documents/Work"
  ),
  n04 = list(
    gola = "Documents/Work"
  ),
  gola.local = list(
    gola = "Documents/Work"
  ),
  damian.novalocal = list(
    damian = "documents"
  )
)
main_dir <- file.path(home,
                      work_dirs[[system]][[user]],
                      project_name)

dir.create(scripts_dir <- file.path(main_dir, "scripts"),
           recursive = TRUE, showWarnings = FALSE)
dir.create(report_dir <- file.path(main_dir, "report"),
           recursive = TRUE, showWarnings = FALSE)

input_dir <- switch(system,
                    damian.novalocal = "/data",
                    "/imbs/external_data/annotation_and_references/"
)
input_dir_1kg_phase3 <- switch(system,
                               damian.novalocal = file.path(input_dir, "1000G"),
                               file.path(input_dir,
                                         "hapmap",
                                         "1000G",
                                         "1000GP_Phase3")
)
input_dir_human_ref <- switch(system,
                              damian.novalocal = file.path(input_dir, "GRCh37REF"),
                              file.path(input_dir,
                                        "human-ref-genomes",
                                        "b37")
)
dir.create(project_dir <- switch(system,
                                 damian.novalocal = "/data/1kg_phase3",
                                 "/imbs/projects/1kg_phase3"
                                 ),
           recursive = TRUE, showWarnings = FALSE)

dir.create(proc_dir <- file.path(project_dir, "proc"),
           recursive = TRUE, showWarnings = FALSE)

dir.create(reg_dir <- file.path(project_dir, "registries"),
           recursive = TRUE, showWarnings = FALSE)

dir.create(output_dir <- file.path(project_dir, "output"),
           recursive = TRUE, showWarnings = FALSE)

##============================================================================+
## rds files ----
##============================================================================+

##============================================================================+
## parameters ----
##============================================================================+

##============================================================================+
## external software ----
##============================================================================+
bcftools_exec <- switch(system,
                        "damian.novalocal" = "/home/damian/bin/bcftools1.9",
                        "/software/bin/bcftools1.6"
)
genotype_harmonizer_exec <- switch(system,
                                   "damian.novalocal" = "/home/damian/bin/GenotypeHarmonizer1.4.20",
                                   "/software/bin/GenotypeHarmonizer1.4.20"
)
plink_exec <- switch(system,
                     "damian.novalocal" = "/home/damian/bin/plink1.90b6.10",
                     "/software/bin/plink1.9b5"
)
plink2_exec <- switch(system,
                      "damian.novalocal" = "/home/damian/bin/plink2.0a20190617",
                      "/software/bin/plink2a20190527"
)
gcta_exec <- switch(system,
                    "damian.novalocal" = "/home/damian/bin/gcta1.92.2b",
                    "/software/bin/gcta1.26.0"
)
