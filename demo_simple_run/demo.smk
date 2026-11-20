# Code adapted from: https://github.com/harvardinformatics/snakemake-workshop/tree/main

with open("complete/demo-sample-sheet.txt") as samples_in:
    samples = [line.strip() for line in samples_in]


INDIR = "demo-data/"
OUTDIR = "demo-results/"


rule all:
    input:
        OUTDIR + "aggregated_results.tsv"

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

rule aggregate:
    input:
        expand(OUTDIR + "{sample}.summary", sample=samples)
    output:
        OUTDIR + "aggregated_results.tsv"
    run:
        with open(output[0], "w") as out:
            out.write("sample\tlines\twords\n")
            for sample, summary_file in zip(samples, input):
                with open(summary_file) as f:
                    lines = f.readlines()
                    num_lines = lines[0].strip().split("\t")[1]
                    num_words = lines[1].strip().split("\t")[1]
                    out.write(f"{sample}\t{num_lines}\t{num_words}\n")