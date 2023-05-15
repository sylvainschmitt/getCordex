rule reformat:
    input:
        "results/table/{driving_model}_{rcm_model}_{experiment}.extrapolated.tsv"
    output:
        "results/table/{driving_model}_{rcm_model}_{experiment}.formatted.tsv"
    log:
        "results/logs/reformat_{driving_model}_{rcm_model}_{experiment}.log"
    benchmark:
        "results/benchmarks/reformat_{driving_model}_{rcm_model}_{experiment}.benchmark.txt"
    singularity: 
        config["troll"]
    threads: 1
    params:
        time_freq_hr=config["time_freq_hr"],
        tz=config["tz"]
    script:
        "../scripts/reformat.R"
        