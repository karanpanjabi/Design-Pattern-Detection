#!/usr/bin/env python3


import sys
import os


import main


VEC_GEN_PATH = '../vector_gen'


def detect(project_path, out_file):

    if out_file == 'term':
        f = sys.stdout
    else:
        f = open(out_file, 'w')

    i = 0

    project_path = os.path.join(VEC_GEN_PATH, project_path)

    os.chdir(VEC_GEN_PATH)

    l = os.listdir(project_path)
    if '_db' not in l:
        db_path = os.path.join(project_path, '_db')
        os.system('rm -rf {}'.format(db_path))
    print('Creating CodeQL DB...')
    i = os.system('./1_create_db.py {}'.format(project_path))

    if i != 0:
        print('An error occurred. Exiting...')
        return 1

    patterns = (
        'singleton',
        'composite',
        'command',
        'observer',
        'strategy',
    )

    print('Searching for patterns...')
    for pat in patterns:
        qf = '../queries/query_' + pat + '.ql'

        i = os.system('./2_run_query.py {} {}'.format(qf, project_path))
        if i != 0:
            print('An error occurred. Exiting...')
            return 2

        i = os.system('./3_get_result_data.py {} 2>&1 > /dev/null'.format(project_path))
        if i != 0:
            print('An error occurred. Exiting...')
            return 3

        try:
            main.main(['', 'output', pat], f)
        except:
            return 4

    return 0


if __name__ == '__main__':

    if len(sys.argv) != 3:
        print('usage: {} <project path> <output file>'.format(argv[0]),
              file=sys.stderr)
        sys.exit(1)

    sys.exit(detect(sys.argv[1], sys.argv[2]))
