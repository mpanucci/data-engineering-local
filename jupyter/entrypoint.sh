#!/bin/bash

jupyter lab --LabApp.token='' \
    --ip=0.0.0.0 --allow-root \
    --NotebookApp.notebook_dir='./notebooks' \
    --NotebookApp.token='' \
    --NotebookApp.password=''
