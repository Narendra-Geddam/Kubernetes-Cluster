[devtest_control_plane]
${devtest_control_plane}

[devtest_workers]
${devtest_worker_1}
${devtest_worker_2}

[production_control_plane]
${production_control_plane}

[production_workers]
${production_worker_1}
${production_worker_2}

[k8s_control_plane:children]
devtest_control_plane
production_control_plane

[k8s_workers:children]
devtest_workers
production_workers
