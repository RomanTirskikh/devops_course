import uuid
from setuptools import setup
import os
from pip.req import parse_requirements

setup(
    name='SimplePackage',
    version='0.1.0',
    author='Roman Tirskikh',
    author_email='roman_tirskikh@epam.com',
    url='http://pypi.python.org/pypi/SimplePackage/',
    packages=['simplepackage'],
    description='Just a simple package.',
)
