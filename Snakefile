configfile: "config/config_test.yml"

rule all:
   input:
        expand("results/{driving_model}_{rcm_model}/{experiment}/", 
                driving_model=config["driving_model"],
                rcm_model=config["rcm_model"],
                experiment=config["experiment"])

# Rules #
include: "rules/download.smk"
