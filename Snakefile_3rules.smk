configfile: "config.yaml"
workdir: config["WORKING_FOLDER"]
# shell.executable("/bin/bash")
# shell.prefix("source ~/.bashrc; ")

rule all:
    input:
        # "letters_and_numbers.txt",
        # "letters_and_numbers_python.txt",
        "comparison.txt"

rule generate_files:
    input: "Snakefile_3rules.smk" # dummy input
    output:
        letters = "letters.txt",
        numbers = "numbers.txt"
    shell:
        """
        for each in {{A..Z}}; do echo $each; done > {output.letters}
        for each in {{1..26}}; do echo $each; done > {output.numbers}
        """

rule join_files:
    input: rules.generate_files.output
    output: "letters_and_numbers.txt"
    shell: "paste {input} > {output}"

rule join_files_with_python:
    input:
        letters = rules.generate_files.output.letters,
        numbers = rules.generate_files.output.numbers
    output: "letters_and_numbers_python.txt"
    run:
        with open(input.letters, 'r') as file:
            letters = file.read().splitlines()
        with open(input.numbers, 'r') as file:
            numbers = file.read().splitlines()
        letters_and_numbers = [x + "\t" + y for x, y in zip(letters, numbers)]
        with open(output[0], 'w') as file:
            for each in letters_and_numbers:
                file.write(each + "\n")
        shell("echo testing")

rule compare_files:
    input: rules.join_files.output, rules.join_files_with_python.output
    output: "comparison.txt"
    shell: "if cmp {input}; then echo identical; else echo different; fi > {output}"



