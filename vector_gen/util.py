import os


def get_db_folder(project_path=os.getcwd()):
    """
    Gets the 'projectxyz_db' folder in a given project folder.
    If `project_path` is default it scans the pwd
    """
    project_path = os.path.abspath(project_path)
    l = list(filter(lambda x: os.path.isdir(
        os.path.join(project_path, x)), os.listdir(project_path)))
    l = [os.path.join(project_path, x) for x in l]
    
    db_folder = ""
    for dirname in l:
        if dirname.endswith("_db"):
            db_folder = dirname
            break

    if db_folder != "":
        db_folder = os.path.abspath(db_folder)
    return db_folder
