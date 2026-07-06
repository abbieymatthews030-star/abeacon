import argparse
from .core import Niow


def main(argv=None):
    parser = argparse.ArgumentParser(prog="niow", description="niow CLI")
    parser.add_argument("--name", "-n", help="name", default="niow")
    args = parser.parse_args(argv)
    tool = Niow(args.name)
    print(tool.greet())


if __name__ == "__main__":
    main()
