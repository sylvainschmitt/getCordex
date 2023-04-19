configfile: "config/config_test.yml"

rule all:
   input:
        expand("results/{driving_model}_{rcm_model}/{experiment}/{variable}/", 
                driving_model=config["driving_model"],
                experiment=config["experiment"],
                rcm_model=config["rcm_model"],
                variable=config["variable"])

# Rules #
include: "rules/download.smk"
