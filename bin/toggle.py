#!/usr/bin/python
from i3ipc import Connection

scratch = "scratch"


def get_cl(tree):
    w = tree.find_focused().workspace().name
    print(f"w={w}")
    if w == "1":
        return 'firefox-pierre'
    elif w == "2":
        return 'firefox-n2i'

N = 7

def main():
    i3 = Connection()
    tree = i3.get_tree()

    ffs = tree.find_classed(get_cl(tree))
    # print(ffs)
    # [ff, *_] = ffs
    for ff in ffs:
        w = ff.workspace()
        if w.name == scratch:
            print("scratch")
            ff.command("move workspace current")
            for i in range(N):
                ff.command("move left")
            ff.command("resize set 1300px")
            ff.command("focus")
        else:
            print("else")
            ff.command(f"move workspace {scratch}")
            ff.command("move left")

main()
