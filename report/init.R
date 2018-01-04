
source("../init.R", chdir = TRUE)

##============================================================================+
## knitr setup                                                                |
##============================================================================+
options(width = 60)
opts_knit$set(verbose = TRUE, progress = FALSE,
              aliases = c(fw = "fig.width", fh = "fig.height",
                  fc = "fig.cap", fsc = "fig.subcap", ow = "out.width"))

opts_chunk$set(comment = "#", fig.width = 6, fig.height = 6, echo = FALSE,
               cache = TRUE, fig.path = file.path(imgDir, "knitr"),
               fig.align = "center", fig.pos = "htb", dpi = 200,
               warning = FALSE, message = FALSE, results = 'hide')


##============================================================================+
## xtable setup                                                               |
##============================================================================+
options(xtable.caption.placement = "top")
options(xtable.booktabs = TRUE)
