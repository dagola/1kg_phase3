
################################################################################
#                                                                              #
# 1000 genomes phase 3                                                         #
# File: 01-conversion.R                                                        #
# Description: Conversion of 1000G phase 3 VCF files in PLINK binary format    #
#                                                                              #
################################################################################

source("init.R", chdir = TRUE)

# Convert VCF to PLINK ----
vcf_files <- list.files(
  path = input_dir_1kg_phase3,
  pattern = ".*\\.vcf\\.gz$",
  full.names = TRUE)

reg_name <- "1kg_phase3-create_plink"
reg <- imbs::load_or_create_registry(
  file.dir = file.path(reg_dir, reg_name),
  work.dir = project_dir,
  writeable = TRUE,
  overwrite = TRUE,
  conf.file = slurm_btconf_file
)

ids <- batchtools::batchMap(
  fun = imbs::plink_conversion,
  vcf.file = vcf_files,
  out.prefix = file.path(proc_dir, tools::file_path_sans_ext(basename(vcf_files), compression = TRUE)),
  more.args = list(ref.file = file.path(input_dir_human_reg, "human_g1k_v37.fasta"),
                   bcftools.exec = bcftools_exec,
                   plink.exec = plink_exec,
                   num.threads = 1)
)

ids[, chunk := 1]

batchtools::submitJobs(ids = ids,
                       resources = list(ntasks = 1, ncpus = 1, memory = "10G",
                                        partition = "batch",
                                        chunks.as.arrayjobs = TRUE))

batchtools::waitForJobs()


