configfile: "config.yaml"
workdir: config["WORKING_FOLDER"]
# shell.executable("/bin/bash")
# shell.prefix("source ~/.bashrc; ")

rule all:
    input:
        # "edited_files/snakemake_output_0.txt",
        # "edited_files/snakemake_output_1.txt",
        # "edited_files/snakemake_output_2.txt",
        # "edited_files/snakemake_output_3.txt",
        # "edited_files/snakemake_output_4.txt",
        # "edited_files/snakemake_output_5.txt",
        # "edited_files/snakemake_output_6.txt",
        # "edited_files/snakemake_output_7.txt",
        # "edited_files/snakemake_output_8.txt",
        # "edited_files/snakemake_output_9.txt",
        final = "final_results.txt"

# rule all:
# use expand() to do the above concisely

rule edit_text:
    input: "data_files/snakemake_input_{num}.txt"
    output: "edited_files/snakemake_output_{num}.txt"
    shell: "cat {input} | sed 's/no./number:/' > {output}"

# TODO
rule add_num_to_output_file:
    """Create a rule to add num to the end of the edited files.
    The new files should be in a folder named numbered_files"""
    input: rules.edit_text.output
    output: "numbered_files/snakemake_output_{num}.txt"
    params: "{num}"
    shell: "echo {params} | cat {input} - > {output}"

rule concatenate_all_files:
    """Create a rule to concatenate all the numbered files."""
    input: expand("numbered_files/snakemake_output_{num}.txt", num = list(range(10)))
    output: "final_results.txt"
    shell: "cat {input} > {output}"


# Resources
# https://slides.com/johanneskoester/snakemake-tutorial
#