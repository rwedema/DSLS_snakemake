from snakemake.io import protected

rule all:
    input:
        config["output_directory"] + "aggregated_results.tsv",
        "plots/plot_A.svg"

rule count_lines:
    input:
        config["input_directory"] + "{sample}.txt"
    output:
        config["output_directory"] + "{sample}.lines"
    log:
        "logs/count_lines_{sample}.log"
    params:
        config["line_count"]
    threads:
        config["threads"]
    shell:
        # wc --threads {threads} {params} {input} > {output} 2> {log}
        "wc {params} {input} > {output} 2> {log}"

rule count_words:
    input:
        config["input_directory"] + "{sample}.txt"
    output:
        config["output_directory"] + "{sample}.words"
    log:
        stderr="logs/count_lines_{sample}_stderr.log"
    params:
        config["word_count"]
    message: "Executing rule count_words with {params} as parameter on the following files {input}."
    shell:
        "wc {params} {input} > {output}  2> {log.stderr}"

rule combine_counts:
    input:
        lines = config["output_directory"] + "{sample}.lines",
        words = config["output_directory"] + "{sample}.words"
    output:
        temp(config["output_directory"] + "{sample}.summary")
    benchmark:
        "benchmark/{sample}.combine_counts_benchmark.txt"
    conda:
        "envs/combine_counts.yaml"
    script:
        #"scripts/combine_counts.py"
        "scripts/combine_counts.R"

rule aggregate:
    input:
        expand(config["output_directory"] + "{sample}.summary", sample=config["samples"]),
    output:
        #protected(config["output_directory"] + "aggregated_results.tsv")
        config["output_directory"] + "aggregated_results.tsv"
    conda:
        # need to add the --use-conda argument
        "envs/aggregate.yaml"
    script:
        "scripts/aggregate.py"

rule get_fast:
    output:
        "demo-results/test.fasta",
    log:
        "logs/get_fasta.log",
    params:
        id="KY785484",
        db="nuccore",
        format="fasta",
        # optional mode
        mode=None,
    wrapper:
        "v7.0.0/bio/entrez/efetch"

rule plot:
    input:
        "demo-results/test.fasta"
    output:
        svg = report("plots/plot_A.svg", caption="report/plot_A.rst", category='Step1')
    conda:
        "envs/plot.yaml"
    script:
        "scripts/plot_sequence_distribution.py"

