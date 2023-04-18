configfile: "config/config_test.yml"

rule all:
   input:
        expand("results/{project}/{product}/{domain}/{institute}/{driving_model}/{experiment}/{ensemble}/{rcm_model}/{downscaling}/{frequency}/{variable}/{version}/", 
                project=config["project"],
                product=config["product"],
                domain=config["domain"],
                institute=config["institute"],
                driving_model=config["driving_model"],
                experiment=config["experiment"],
                ensemble=config["ensemble"],
                rcm_model=config["rcm_model"],
                downscaling=config["downscaling"],
                frequency=config["frequency"],
                variable=config["variable"],
                version=config["version"])

# Rules #
include: "rules/download.smk"
