import os
import sys

l = list(filter(lambda x:os.path.isdir(x), os.listdir(".")))

db_folder = None
for dirname in l:
    if dirname.endswith("_db"):
        db_folder = dirname
        break

query_file = sys.argv[1]

os.system(f"codeql database run-queries {db_folder} {query_file}")