configfile: "config/config_test.yml"

rule all:
   input:
         expand("results/table/{driving_model}_{rcm_model}_{experiment}.joined.tsv",
                 driving_model=config["driving_model"],
                 rcm_model=config["rcm_model"],
                 experiment=config["experiment"])
                
# Rules #
include: "rules/download.smk"
include: "rules/extract_var.smk"
include: "rules/join_exp.smk"
