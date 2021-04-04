import os
import subprocess
import glob
import json

l = list(filter(lambda x:os.path.isdir(x), os.listdir(".")))

db_folder = None
for dirname in l:
    if dirname.endswith("_db"):
        db_folder = dirname
        break


output_folder = "output/"
result_folder = os.path.join(db_folder, "results")
bqrs_file = glob.glob(f"{result_folder}/**/*.bqrs", recursive=True)[0]

info_cmd = f"codeql bqrs info --format=json {bqrs_file}"
result = subprocess.run(info_cmd, stdout=subprocess.PIPE, shell=True)

result_sets = json.loads(result.stdout)
result_sets = result_sets["result-sets"]

for result_set in result_sets:
    predicate_name = result_set["name"]

    decode_cmd = f"codeql bqrs decode --format=csv --result-set={predicate_name} {bqrs_file}"
    result = subprocess.run(decode_cmd, stdout=subprocess.PIPE, shell=True)

    print(f"-------------{predicate_name}-------------")
    print(str(result.stdout, encoding='UTF-8'))
    print()

