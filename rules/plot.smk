rule plot:
    input:
        "results/table/{driving_model}_{rcm_model}_{experiment}.formatted.tsv"
    output:
        "results/figure/{driving_model}_{rcm_model}_{experiment}_{variable}.png"
    log:
        "results/logs/plot_{driving_model}_{rcm_model}_{experiment}_{variable}.log"
    benchmark:
        "results/benchmarks/plot_{driving_model}_{rcm_model}_{experiment}_{variable}.benchmark.txt"
    threads: 1
    params:
        var="{variable}",
        cordex="{driving_model}_{rcm_model}_{experiment}",
    script:
        "../scripts/plot.R"
        