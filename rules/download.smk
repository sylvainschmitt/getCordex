rule download:
    input:
        "wget/{driving_model}_{rcm_model}.{experiment}.sh"
    output:
        directory("results/{driving_model}_{rcm_model}/{experiment}/")
    log:
        "results/logs/download_{driving_model}_{rcm_model}_{experiment}.log"
    benchmark:
        "results/benchmarks/download_{driving_model}_{rcm_model}_{experiment}.benchmark.txt"
    params:
        script="{driving_model}_{rcm_model}.{experiment}"
    threads: 1
    resources:
        mem_mb=1000
    shell:
        "mkdir -p {output} ; "
        "cp {input} {output} ; "
        "cd {output} ; "
        "bash {params.script} -u ; "
        "bash {params.script}"
        