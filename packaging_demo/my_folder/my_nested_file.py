"""Module to demonstrate packaging."""

import sys

# print(sys.path)
sys.path.insert(0, "/home/himansys/repos")

from packaging_demo.my_other_file import CONSTANT as CONSTANT2

CONSTANT = "Hello!"

print(CONSTANT2)
