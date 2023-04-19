rule join_exp:
    input:
        expand("results/table/{driving_model}_{rcm_model}_{experiment}_{variable}.tsv",
                variable=config["variable"], allow_missing=True)
    output:
        "results/table/{driving_model}_{rcm_model}_{experiment}.joined.tsv"
    log:
        "results/logs/join_exp_{driving_model}_{rcm_model}_{experiment}.log"
    benchmark:
        "results/benchmarks/join_exp_{driving_model}_{rcm_model}_{experiment}.benchmark.txt"
    singularity: 
        "https://github.com/sylvainschmitt/singularity-r-bioinfo/releases/download/0.0.4/sylvainschmitt-singularity-r-bioinfo.latest.sif"
    threads: 1
    script:
        "../scripts/join_exp.R"
        