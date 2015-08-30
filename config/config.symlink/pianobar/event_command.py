#!/usr/bin/env python

import os
import sys
from os.path import expanduser, join

path = os.environ.get('XDG_CONFIG_HOME')
if not path:
    path = expanduser("~/.config")
else:
    path = expanduser(path)
fn = join(path, 'pianobar', 'current-song')

info = sys.stdin.readlines()
cmd = sys.argv[1]

if cmd == 'songstart':
    with open(fn, 'w') as f:
        title = info[1].split('=')[1].rstrip()
        artist = info[0].split('=')[1]
        song = title + " - " + artist
        truncateSong = info = song[:38] + (song[38:] and '..')

        f.write(truncateSong)
