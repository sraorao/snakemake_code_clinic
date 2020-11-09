# configfile: ""
# workdir: "/home/srao/PycharmProjects/snakemake_cc"


# 1 --------------------------------------------------------------------------------------------------------------------
rule count_words:
    """Takes a text file as input, and outputs another text file.
    Simple rule.
    """
    input: "reduplication_poetry.txt"
    output: "word_count.txt"
    shell: "cat {input} | grep -oE '([A-Za-z])+' | sort | uniq -c > {output}"

# 2 --------------------------------------------------------------------------------------------------------------------
rule count_reduplicated_words:
    """Takes a text file as input, and outputs another text file.
    Note the double backslashes.
    """
    input: "reduplication_poetry.txt"
    output: "redup_count.txt"
    shell:
        """
        cat {input} | \
        tr [:upper:] [:lower:] | \
        grep -oE '\\b([A-Za-z].*)[ -]*\\1\\b' | \
        sort | \
        uniq -c | \
        sed -e 's/^\s*//' -e 's/\s/\t/' > {output}
        """
# 3 --------------------------------------------------------------------------------------------------------------------
rule count_lines:
    """Takes a text file as input, and outputs another text file.
    Uses non-file parameters using params keyword.
    """
    input: "reduplication_poetry.txt"
    output: "line_count.txt"
    params: "'.*'"
    shell:
        """
        cat {input} | \
        tr [:upper:] [:lower:] | \
        grep -oE {params} | \
        sort | \
        uniq -c > {output}
        """
# 4 --------------------------------------------------------------------------------------------------------------------
rule plot_counts:
    """plot the results from rule 2.
    Assumes that you have R set up for pdf plotting.
    """
    input: "redup_count.txt"
    output: "counts_plot.pdf"
    script: "plot_counts.R"

# 5 --------------------------------------------------------------------------------------------------------------------
rule generate_data_files:
    """generate data files for wildcards workflow."""
    input: "Snakefile" # dummy input
    output: expand("data_files/snakemake_input_{num}.txt", num = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    params: "file no. "
    shell: "for each in {output}; do echo {params} > $each; done"