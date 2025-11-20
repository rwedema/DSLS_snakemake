with (open(snakemake.input.lines) as line_reader,
      open(snakemake.input.words) as word_reader,
      open(snakemake.output[0], "w") as out_writer):

    num_lines = line_reader.read().split()[0]
    num_words = word_reader.read().split()[0]

    out_writer.write(f"lines\t{num_lines}\nwords\t{num_words}\n")