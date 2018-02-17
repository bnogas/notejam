#!/usr/bin/env python
# coding=utf-8

import os
import sys


def main():
    os.environ.setdefault(
        "DJANGO_SETTINGS_MODULE",
        "settings.docker",
    )
    from django.core.management import execute_from_command_line
    sys.argv[0] = os.path.dirname(__file__)
    execute_from_command_line(sys.argv)


if __name__ == "__main__":
    main()
