from snakemake.io import protected

configfile: "config/demo-config.yaml"

rule all:
    input:
        config["output_directory"] + "aggregated_results.tsv"

rule count_lines:
    input:
        config["input_directory"] + "{sample}.txt"
    output:
        config["output_directory"] + "{sample}.lines"
    log:
        "logs/count_lines_{sample}.log"
    params:
        config["line_count"]
    shell:
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