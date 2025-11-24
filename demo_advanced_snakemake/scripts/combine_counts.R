lines <- read.table(snakemake@input[["lines"]], header=FALSE)
words <- read.table(snakemake@input[["words"]], header=FALSE)

num_lines <- lines[1]
num_words <- words[1]

out_line <- paste("lines", "\t", num_lines, "\n", "nwords", "\t", num_words)

writeLines(out_line, snakemake@output[[1]])