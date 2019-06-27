
################################################################################
#                                                                              #
# 1000 genomes phase 3                                                         #
# File: 01-conversion.R                                                        #
# Description: Conversion of 1000G phase 3 VCF files in PLINK binary format.   #
#              Follows the instructions on                                     #
# http://apol1.blogspot.de/2016/10/1000-genomes-project-phase-3-principal.html #
#              and                                                             #
# http://apol1.blogspot.de/2014/11/best-practice-for-converting-vcf-files.html #
#                                                                              #
################################################################################

source("init.R", chdir = TRUE)

# Convert VCF to PLINK ----
vcf_files <- list.files(
  path = input_dir_1kg_phase3,
  pattern = ".*chr.*\\.vcf\\.gz$",
  full.names = TRUE)

reg_name <- "1kg_phase3-create_plink"
reg <- imbs::load_or_create_registry(
  file.dir = file.path(reg_dir, reg_name),
  work.dir = project_dir,
  writeable = TRUE,
  overwrite = TRUE,
  conf.file = slurm_btconf_file,
  packages = c("imbs")
)

ids <- batchtools::batchMap(
  fun = imbs::plink_normalize_vcf_conversion,
  vcf.file = vcf_files,
  output.prefix = file.path(proc_dir, tools::file_path_sans_ext(basename(vcf_files), compression = TRUE)),
  more.args = list(ref.file = file.path(input_dir_human_ref, "human_g1k_v37.fasta"),
                   bcftools.exec = bcftools_exec,
                   plink.exec = plink_exec)
)

ids[, chunk := 1]

batchtools::submitJobs(
  ids = ids,
  resources = list(
    ntasks = 1, ncpus = 1, memory = 10000,
    partition = "batch", walltime = 0,
    chunks.as.arrayjobs = TRUE,
    name = sprintf("%s_Normalize_Convert", project_name)
  )
)

batchtools::waitForJobs()

# Impute sex using chromosome X ----
chrX_prefix <- file.path(proc_dir, "chrX.1kg.phase3.v5a")

reg_name <- "1kg_phase3-impute_sex"
reg <- imbs::load_or_create_registry(
  file.dir = file.path(reg_dir, reg_name),
  work.dir = project_dir,
  writeable = TRUE,
  overwrite = FALSE,
  conf.file = slurm_btconf_file
)

ids <- batchtools::batchMap(
  fun = imbs::plink_sex_imputation,
  bfile = chrX_prefix,
  output.prefix = sprintf("%s.seximputed", chrX_prefix),
  more.args = list(f.values = c(0.95, 0.95),
                   exec = plink_exec,
                   num.threads = 1)
)

ids[, chunk := 1]

batchtools::submitJobs(ids = ids,
                       resources = list(ntasks = 1, ncpus = 1, memory = "10G",
                                        partition = "fast", walltime = 10,
                                        chunks.as.arrayjobs = TRUE))

batchtools::waitForJobs()

# Check for duplicate markers ----
bim_files <- list.files(
  path = proc_dir,
  pattern = "chr(\\d|X)+.1kg.phase3.v5a.bim$",
  full.names = TRUE
)


reg_name <- "1kg_phase3-find_duplicate_markers"
reg <- imbs::load_or_create_registry(
  file.dir = file.path(reg_dir, reg_name),
  work.dir = project_dir,
  writeable = TRUE,
  overwrite = FALSE,
  conf.file = slurm_btconf_file,
  packages = c("data.table")
)

ids <- batchtools::batchMap(
  fun = function(bim.file, dups.file) {

    bim <- data.table::fread(bim.file)

    imbs::system_call("lockfile-create", args = c(dups.file))
    cat(bim[duplicated(V2), V2], file = dups.file, append = TRUE, sep = "\n")
    imbs::system_call("lockfile-remove", args = c(dups.file))

  },
  bim.file = bim_files,
  more.args = list(dups.file = dups_file)
)

ids[, chunk := 1]

batchtools::submitJobs(ids = ids,
                       resources = list(ntasks = 1, ncpus = 1, memory = "10G",
                                        partition = "fast", walltime = 10,
                                        chunks.as.arrayjobs = TRUE))

batchtools::waitForJobs()

# Remove duplicate markers ----
plink_prefixes <- tools::file_path_sans_ext(
  list.files(
    path = proc_dir,
    pattern = "chr(\\d|X)+.1kg.phase3.v5a.bed$",
    full.names = TRUE
  )
)

reg_name <- "1kg_phase3-exclude_dups"
reg <- imbs::load_or_create_registry(
  file.dir = file.path(reg_dir, reg_name),
  work.dir = project_dir,
  writeable = TRUE,
  overwrite = FALSE,
  conf.file = slurm_btconf_file,
  packages = c("data.table")
)

ids <- batchtools::batchMap(
  fun = imbs::plink_subset,
  bed.file = sprintf("%s.bed", plink_prefixes),
  bim.file = sprintf("%s.bim", plink_prefixes),
  output.prefix = sprintf("%s.seximputed.nodups", plink_prefixes),
  more.args = list(fam.file = sprintf("%s.seximputed.fam", chrX_prefix),
                   exec = plink_exec,
                   exclude = dups_file)
)

ids[, chunk := 1]

batchtools::submitJobs(ids = ids,
                       resources = list(ntasks = 1, ncpus = 1, memory = "8G",
                                        partition = "fast", walltime = 10,
                                        chunks.as.arrayjobs = TRUE))

batchtools::waitForJobs()

# Check for very long indels ----
bim_files <- list.files(
  path = proc_dir,
  pattern = "chr(\\d+|X).1kg.phase3.v5a.seximputed.nodups.bim$",
  full.names = TRUE
)

reg_name <- "1kg_phase3-find_long_indels"
reg <- imbs::load_or_create_registry(
  file.dir = file.path(reg_dir, reg_name),
  work.dir = project_dir,
  writeable = TRUE,
  overwrite = FALSE,
  conf.file = slurm_btconf_file,
  packages = c("data.table")
)

ids <- batchtools::batchMap(
  fun = function(bim.file, to.long, longindels.file) {

    bim <- data.table::fread(bim.file)

    imbs::system_call("lockfile-create", args = c(longindels.file))
    cat(bim[nchar(V2) > to.long, V2], file = longindels.file, append = TRUE, sep = "\n")
    imbs::system_call("lockfile-remove", args = c(longindels.file))

  },
  bim.file = bim_files,
  more.args = list(to.long = 150,
                   longindels.file = long_indels_file)
)

ids[, chunk := 1]

batchtools::submitJobs(ids = ids,
                       resources = list(ntasks = 1, ncpus = 1, memory = "10G",
                                        partition = "fast", walltime = 10,
                                        chunks.as.arrayjobs = TRUE))

batchtools::waitForJobs()

# Remove long indels ----
plink_prefixes <- tools::file_path_sans_ext(
  list.files(
    path = proc_dir,
    pattern = "chr(\\d+|X).1kg.phase3.v5a.seximputed.nodups.bed$",
    full.names = TRUE
  ),
  compression = TRUE
)

reg_name <- "1kg_phase3-exclude_long_indels"
reg <- imbs::load_or_create_registry(
  file.dir = file.path(reg_dir, reg_name),
  work.dir = project_dir,
  writeable = TRUE,
  overwrite = FALSE,
  conf.file = slurm_btconf_file
)

ids <- batchtools::batchMap(
  fun = imbs::plink_subset,
  bfile = plink_prefixes,
  output.prefix = sprintf("%s.nolongindels", plink_prefixes),
  more.args = list(exec = plink_exec,
                   exclude = long_indels_file)
)

ids[, chunk := 1]

batchtools::submitJobs(ids = ids,
                       resources = list(ntasks = 1, ncpus = 1, memory = "8G",
                                        partition = "fast", walltime = 10,
                                        chunks.as.arrayjobs = TRUE))

batchtools::waitForJobs()

# Merge into one file ----
plink_prefixes <- tools::file_path_sans_ext(
  list.files(
    path = proc_dir,
    pattern = "chr([2-9]+|[0-9]{2}|X).1kg.phase3.v5a.seximputed.nodups.nolongindels.bed$",
    full.names = TRUE
  ),
  compression = TRUE
)

merge_list_file <- file.path(proc_dir, "merge.list")

writeLines(plink_prefixes, merge_list_file)

first_prefix <- file.path(proc_dir, "chr1.1kg.phase3.v5a.seximputed.nodups.nolongindels")

reg_name <- "1kg_phase3-merge"
reg <- imbs::load_or_create_registry(
  file.dir = file.path(reg_dir, reg_name),
  work.dir = project_dir,
  writeable = TRUE,
  overwrite = FALSE,
  conf.file = slurm_btconf_file
)

ids <- batchtools::batchMap(
  fun = imbs::plink_merge_list,
  bfile = first_prefix,
  output.prefix = file.path(proc_dir, "1kg.phase3.v5a.seximputed.nodups.nolongindels"),
  merge.list = merge_list_file,
  more.args = list(exec = plink_exec)
)

ids[, chunk := 1]

batchtools::submitJobs(ids = ids,
                       resources = list(ntasks = 1, ncpus = 1, memory = 51000,
                                        partition = "batch",
                                        chunks.as.arrayjobs = TRUE))

batchtools::waitForJobs()
