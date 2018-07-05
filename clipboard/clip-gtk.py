#!/usr/bin/env python3
import gi
import sys
import os

gi.require_version('Gtk', '3.0')
gi.require_version('Gdk', '3.0')
gi.require_version('GdkPixbuf', '2.0')

from gi.repository import Gtk, Gdk, GdkPixbuf

daemonize = True
f = None
if sys.stdin.isatty():
    f = open(sys.argv[1], "rb")
else:
    f = sys.stdin.buffer

b = f.read()
f.close()

loader = GdkPixbuf.PixbufLoader.new()
loader.write(b)
loader.close()
pixbuf = loader.get_pixbuf()

clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD) # type: Gtk.Clipboard
clipboard.set_image(pixbuf)
clipboard.store()
clipboard.wait_is_image_available()
print("ok")

n = 0
def owner_change(clip, event):
    global n
    n += 1

    if daemonize and n == 1:
        pid = os.fork()
        if pid == 0:
            os.setsid()
        else:
            os._exit(0)

    if n >= 2:
        Gtk.main_quit()

clipboard.connect('owner-change', owner_change)

Gtk.main()
