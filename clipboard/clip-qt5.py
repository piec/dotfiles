#!/usr/bin/env python3
from PyQt5.QtWidgets import QApplication
from PyQt5.QtGui import QClipboard, QImage
from PyQt5.QtCore import QTimer, QMimeData
from time import sleep
import signal
import sys

app = None
clipboard = None

f = None
if sys.stdin.isatty():
    f = open(sys.argv[1], "rb")
else:
    f = sys.stdin.buffer

def copy_image():
    img = QImage()
    img.loadFromData(f.read())

    data = QMimeData()
    data.setImageData(img)

    clipboard.setMimeData(data)
    print("ok")

def clipboard_changed(mode):
    if mode == QClipboard.Clipboard:
        if not clipboard.ownsClipboard():
            app.exit()

signal.signal(signal.SIGINT, signal.SIG_DFL)

app = QApplication([])
clipboard = app.clipboard()
clipboard.changed.connect(clipboard_changed)
QTimer.singleShot(0, copy_image)
app.exec_()

