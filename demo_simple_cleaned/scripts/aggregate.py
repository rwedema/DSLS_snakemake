with open(snakemake.output[0], "w") as out:
    out.write("sample\tlines\twords\n")

    for sample, summary_file in zip(snakemake.config["samples"], snakemake.input):
        with open(summary_file) as f:
            lines = f.readlines()

            num_lines = lines[0].strip().split("\t")[1]
            num_words = lines[1].strip().split("\t")[1]

            out.write(f"{sample}\t{num_lines}\t{num_words}\n")