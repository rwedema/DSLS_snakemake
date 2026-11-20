# DSLS_snakemake

## Install Conda
https://www.anaconda.com/docs/getting-started/miniconda/main

## Snakemake installation into a new Conda environment
Check in your terminal that you have the Conda **base** environment active.

Enter the following command in the terminal to install snakemake into a new Conda environment called **snakemake_demo**:  
`conda create -c conda-forge -c bioconda -c nodefaults -n snakemake_demo snakemake`

To list the available Conda environment use: `conda env list`  
To activate the just created environment use: `conda activate snakemake_demo`

You will see *(snakemake_demo)* in the terminal prompt indicating that the activation was successful. 

For this demo a few extra libraries are needed that we are going to install manually   
`conda install conda-forge::matplotlib`  
`conda install conda-forge::seaborn`  
`conda install anaconda::graphviz`

## Run the snakemake workflow
Always first check your workflow using the `--dryrun` option to catch early errors.  
`snakemake --cores 1 -s demo.smk --dryrun`

When no errors are listed, you can run the snakemake workflow:   
`snakemake --cores 1 -s demo.smk`

To create a graph depicting the rules and their dependencies:   
`snakemake --cores 1 -s demo.smk --rulegraph | dot -Tpng > demo-rulegraph.png`

To also include the samples and create the DAG (directed acyclic graph) use:   
`snakemake --cores 1 -s demo.smk --dag | dot -Tpng > demo-dag.png`

To run a workflow that has the conda directive in rules use:
`snakemake --cores 1 -s demo.smk --use-conda`

To delete generated output from a workflow use:
`snakemake --cores 1 -s demo.smk --delete-all-output`