import os
import shlex
import subprocess
import sys

def mkdirp(folder):
    subprocess.call(shlex.split('mkdir -p %s' % folder))

def symlink(source, dest_folder, dest_file = None):
    rel_source = os.path.relpath(source, dest_folder)
    if dest_file is None:
        dest_file = source.split('.')[-1]
    dest = os.path.join(dest_folder, dest_file)
    print 'symlinking source %s (%s) to %s' % (source, rel_source, dest)
    subprocess.call(shlex.split('ln -f -s %s %s' % (rel_source, dest)))
    #os.symlink(file_path, os.path.join(chapter_css_folder, file))

pages_folder = 'pages'
for chapter in os.listdir(pages_folder):
    chapter_folder = os.path.join(pages_folder, chapter)

    chapter_css_folder = os.path.join('assets/css', pages_folder, chapter)
    chapter_js_folder = os.path.join('assets/js', pages_folder, chapter)
    chapter_jade_folder = os.path.join('views', pages_folder, chapter)

    mkdirp(chapter_css_folder)
    mkdirp(chapter_js_folder)
    mkdirp(chapter_jade_folder)

    for section in os.listdir(chapter_folder):
        section_folder = os.path.join(chapter_folder, section)
        for file in os.listdir(section_folder):
            file_path = os.path.join(section_folder, file)
            ext = file.split('.')[-1]
            if ext == 'css' or ext == 'sass':
                symlink(file_path, chapter_css_folder, file)
            elif ext == 'js' or ext == 'coffee':
                symlink(file_path, chapter_js_folder, file)
            elif ext == 'jade':
                symlink(file_path, chapter_jade_folder, file)
