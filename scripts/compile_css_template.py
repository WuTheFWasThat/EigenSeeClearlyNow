import os
import sys

if len(sys.argv) < 3:
    print 'Usage: python %s <template_file> <out_file>' % sys.argv[0]
    sys.exit(1)

template_file = sys.argv[1]
out_file = sys.argv[2]
folder = os.path.dirname(template_file)
extension = template_file.split('.')[-1]

with open(template_file) as f:
    template_contents = f.read()
lines = template_contents.split('\n')

def crawl_dir(base_dir, extension, results = [], rel_path = ''):
    directory = os.path.join(base_dir, rel_path)
    for file in os.listdir(directory):
        full_path = os.path.join(directory, file)
        my_rel_path = os.path.join(rel_path, file)
        if os.path.isdir(full_path):
            crawl_dir(base_dir, extension, results, my_rel_path)
        else:
            if file.split('.')[-1] == extension:
                results.append(my_rel_path)
    return results

out_lines = []
for line in lines:
    if '@import_tree' in line:
        path = line.split('\'')[1]
        files = crawl_dir(folder, extension, [], path)
        for file in files:
            out_lines.append('@import \'%s\';' % file)
    else:
        out_lines.append(line)

out_contents = '\n'.join(out_lines)
with open(out_file, 'w') as f:
    f.write(out_contents)
