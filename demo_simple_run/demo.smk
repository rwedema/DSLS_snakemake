INDIR = "demo-data/"
OUTDIR = "demo-results/"

rule count_lines:
    input:
        INDIR + "{sample}.txt"
    output:
        OUTDIR + "{sample}.lines"
    shell:
      "wc -l {input} > {output}"

rule count_words:
    input:
        INDIR + "{sample}.txt"
    output:
        OUTDIR + "{sample}.words"
    shell:
        "wc -w {input} > {output}"

rule combine_counts:
    input:
        lines = OUTDIR + "{sample}.lines",
        words = OUTDIR + "{sample}.words"
    output:
        OUTDIR + "{sample}.summary"
    run:
        with (open(input.lines) as line_reader,
              open(input.words) as word_reader,
              open(output[0], "w") as out_writer):
            num_lines = line_reader.read().split()[0]
            num_words = word_reader.read().split()[0]
            out_writer.write(f"lines\t{num_lines}\nwords\t{num_words}\n")
