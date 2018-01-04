
##============================================================================+
## directories setup ----
##============================================================================+
user <- Sys.info()["user"]
switch (user,
        gola = main_dir <- path.expand("~/Documents/Work/1kg_phase3/")
)

dir.create(scripts_dir <- file.path(main_dir, "scripts"),
           recursive = TRUE, showWarnings = FALSE)
dir.create(report_dir <- file.path(main_dir, "report"),
           recursive = TRUE, showWarnings = FALSE)

input_dir <- "/imbs/external_data/annotation_and_references/"
input_dir_1kg_phase3 <- file.path(input_dir,
                                  "annotation_and_references",
                                  "hapmap",
                                  "1000G",
                                  "1000G_genotypes_phase3_20130502")
input_dir_human_reg <- file.path(input_dir,
                                 "annotation_and_references",
                                 "human",
                                 "b37")
dir.create(project_dir <- "/imbs/projects/1kg_phase3",
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
plink_exec <- "plink1.9b5"
bcftools_exec <- "bcftool1.6"
gcta_exec <- "gcta1.26.0"
