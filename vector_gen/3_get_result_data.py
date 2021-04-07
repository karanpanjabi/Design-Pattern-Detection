#!/usr/bin/python3

import os, sys
import subprocess
import glob
import json
import util


def interpret_bqrs(project_path = os.getcwd(), output_folder = "output/"):
    output_folder = os.path.abspath(output_folder)
    project_path = os.path.abspath(project_path)

    os.system(f"rm -rf {output_folder}/*")
    os.system(f"mkdir -p {output_folder}")

    db_folder = util.get_db_folder(project_path) # searches the project folder for db

    result_folder = os.path.join(db_folder, "results")
    
    bqrs_file = glob.glob(f"{result_folder}/**/*.bqrs", recursive=True)[0]

    info_cmd = f"codeql bqrs info --format=json {bqrs_file}"
    result = subprocess.run(info_cmd, stdout=subprocess.PIPE, shell=True)

    result_sets = json.loads(result.stdout)
    result_sets = result_sets["result-sets"]

    for result_set in result_sets:
        predicate_name = result_set["name"]

        output_file = os.path.join(output_folder, f"{predicate_name}.json")

        decode_cmd = f"codeql bqrs decode --format=json --result-set={predicate_name} --output={output_file} {bqrs_file}"
        result = subprocess.run(decode_cmd, stdout=subprocess.PIPE, shell=True)

        print(f"-------------{predicate_name}-------------")
        print(str(result.stdout, encoding='UTF-8'))
        print()

if __name__ == '__main__':

    if len(sys.argv) == 1:
        print("parse_data.py [project_path] [output_folder]")
        exit(0)
    
    project_path = sys.argv[1] if 1 < len(sys.argv) else os.getcwd()
    output_path = sys.argv[2] if 2 < len(sys.argv) else "output/"

    interpret_bqrs(project_path, output_path)
