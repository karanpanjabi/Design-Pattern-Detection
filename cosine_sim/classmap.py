#!/usr/bin/env python3


import os

import collections
import json


class OutputJSONDir:

    def __init__(self, path):

        if not path.endswith('/'):
            path = path + '/'
        self.path = path
        self.inverse_map = collections.defaultdict(list)

    def load(self):

        self.inverse_map = collections.defaultdict(list)
        self.reload()
        return self.inverse_map

    def reload(self):

        files = [self.path + p
                 for p in os.listdir(self.path)
                     if p.endswith('.json')]

        for fname in files:
            with open(fname) as f:
                obj = json.load(f)

            predicateName = fname.split('/')[-1][:-5]  # strip suffix '.json'

            for entity in obj['tuples']:
                className = entity[0]['label']
                self.inverse_map[className].append(predicateName)

        return self.inverse_map

    def __str__(self):
        return json.dumps(self.inverse_map, indent=2)


if __name__ == '__main__':

    import sys

    if not len(sys.argv) > 1:
        print('Provide directory with JSON files as the last argument',
              file=sys.stderr)
        sys.exit(1)

    json_path = sys.argv.pop()
    json_to_class_mapper = OutputJSONDir(json_path)

    json_to_class_mapper.load()
    print(json_to_class_mapper)
