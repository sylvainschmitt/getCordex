rule reformat:
    input:
        "results/table/{driving_model}_{rcm_model}_{experiment}.joined.tsv"
    output:
        "results/table/{driving_model}_{rcm_model}_{experiment}.formatted.tsv"
    log:
        "results/logs/reformat_{driving_model}_{rcm_model}_{experiment}.log"
    benchmark:
        "results/benchmarks/reformat_{driving_model}_{rcm_model}_{experiment}.benchmark.txt"
    singularity: 
        "https://github.com/sylvainschmitt/singularity-troll/releases/download/0.0.1/sylvainschmitt-singularity-troll.latest.sif"
    threads: 1
    params:
        time_freq_hr=config["time_freq_hr"]
    script:
        "../scripts/reformat.R"
        