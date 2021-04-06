import os
import sys

def create_db(project_path = os.getcwd(), db_folder = os.getcwd()):
    project_path = os.path.abspath(project_path)

    project_name = os.path.basename(project_path)

    db_path = os.path.join(project_path, "_db") # TODO: change to db_folder instead of project_path in future

    # cmd = print
    cmd = os.system

    cmd(f"rm -rf {db_path}")
    cmd(f"codeql database create -l=cpp -s={project_path} {db_path}")

if __name__ == '__main__':

    project_path = sys.argv[1]

    create_db(project_path)