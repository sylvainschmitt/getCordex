configfile: "config/config_all.yml"

rule all:
   input:
         expand("results/table/{driving_model}_{rcm_model}_{experiment}.formatted.tsv",
                 driving_model=config["driving_model"],
                 rcm_model=config["rcm_model"],
                 experiment=config["experiment"]),
         expand("results/figure/{driving_model}_{rcm_model}_{experiment}_{variable}.png",
                 driving_model=config["driving_model"],
                 rcm_model=config["rcm_model"],
                 experiment=config["experiment"],
                 variable=config["plot_variables"])
                
# Rules #
include: "rules/download.smk"
include: "rules/extract_var.smk"
include: "rules/join_exp.smk"
include: "rules/extrapolate.smk"
include: "rules/reformat.smk"
include: "rules/plot.smk"
