rule download:
    input:
        "wget/{driving_model}_{rcm_model}.{experiment}.sh"
    output:
        temp(directory("results/{driving_model}_{rcm_model}/{experiment}/"))
    log:
        "results/logs/download_{driving_model}_{rcm_model}_{experiment}.log"
    benchmark:
        "results/benchmarks/download_{driving_model}_{rcm_model}_{experiment}.benchmark.txt"
    params:
        script="{driving_model}_{rcm_model}.{experiment}.sh"
    threads: 1
    resources:
        mem_mb=1000
    shell:
        "module load java ; " # only for muse, need to add a condition
        "ESG_HOME='.esg/' ; " # only for muse, need to add a condition
        "mkdir -p {output} ; "
        "cp {input} {output} ; "
        "cd {output} ; "
        "bash {params.script} -u ; "
        "bash {params.script}"
        