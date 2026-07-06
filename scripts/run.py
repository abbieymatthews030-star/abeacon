import sys
from niow.core import Niow


def run():
    name = sys.argv[1] if len(sys.argv) > 1 else "niow"
    tool = Niow(name)
    print(tool.greet())

if __name__ == "__main__":
    run()
