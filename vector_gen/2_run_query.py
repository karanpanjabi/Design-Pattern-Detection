import os
import sys
import util

def run_query(query_file, project_path = os.getcwd()):
    query_file = os.path.abspath(query_file)
    project_path = os.path.abspath(project_path)


    db_folder = util.get_db_folder(project_path)

    cmd = print
    # cmd = os.system

    cmd(f"codeql database run-queries {db_folder} {query_file}")

if __name__ == '__main__':
    query_file = sys.argv[1]

    project_path = sys.argv[2] if 2 < len(sys.argv) else os.getcwd()

    run_query(query_file, project_path)