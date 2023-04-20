rule extract_var:
    input:
        "results/{driving_model}_{rcm_model}/{experiment}/"
    output:
        temp("results/table/{driving_model}_{rcm_model}_{experiment}_{variable}.tsv")
    log:
        "results/logs/extract_var_{driving_model}_{rcm_model}_{experiment}_{variable}.log"
    benchmark:
        "results/benchmarks/extract_var_{driving_model}_{rcm_model}_{experiment}_{variable}.benchmark.txt"
    singularity: 
        "https://github.com/sylvainschmitt/singularity-troll/releases/download/0.0.1/sylvainschmitt-singularity-troll.latest.sif"
    threads: 10
    params:
        var="{variable}",
        xutm=config["xutm"],
        ytum=config["yutm"]
    script:
        "../scripts/extract_var.R"
        