rule download:
    input:
        "wget/{project}.{product}.{domain}.{institute}.{driving_model}.{experiment}.{ensemble}.{rcm_model}.{downscaling}.{frequency}.{variable}.{version}.sh"
    output:
        directory("results/{project}/{product}/{domain}/{institute}/{driving_model}/{experiment}/{ensemble}/{rcm_model}/{downscaling}/{frequency}/{variable}/{version}/")
    log:
        "results/logs/download_{project}_{product}_{domain}_{institute}_{driving_model}_{experiment}_{ensemble}_{rcm_model}_{downscaling}_{frequency}_{variable}_{version}.log"
    benchmark:
        "results/benchmarks/download_{project}_{product}_{domain}_{institute}_{driving_model}_{experiment}_{ensemble}_{rcm_model}_{downscaling}_{frequency}_{variable}_{version}.benchmark.txt"
    params:
        script="{project}.{product}.{domain}.{institute}.{driving_model}.{experiment}.{ensemble}.{rcm_model}.{downscaling}.{frequency}.{variable}.{version}.sh"
    threads: 1
    resources:
        mem_mb=1000
    shell:
        "mkdir {output} ; "
        "cp {input} {output} ; "
        "cd {output} ; "
        "bash {params.script} -u ; "
        "bash {params.script}"
        