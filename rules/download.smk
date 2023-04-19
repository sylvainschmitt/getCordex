rule download:
    input:
        "wget/{driving_model}.{experiment}.{rcm_model}.{variable}.sh"
    output:
        directory("results/{driving_model}_{rcm_model}/{experiment}/{variable}/")
    log:
        "results/logs/download_{driving_model}_{rcm_model}_{experiment}_{variable}.log"
    benchmark:
        "results/benchmarks/download_{driving_model}_{rcm_model}_{experiment}_{variable}.benchmark.txt"
    params:
        script="{driving_model}.{experiment}.{rcm_model}.{variable}.sh"
    threads: 1
    resources:
        mem_mb=1000
    shell:
        "mkdir -p {output} ; "
        "cp {input} {output} ; "
        "cd {output} ; "
        "bash {params.script} -u ; "
        "bash {params.script}"
        