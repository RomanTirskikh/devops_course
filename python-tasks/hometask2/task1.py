#!usr/bin/python
# -*- coding: utf-8 -*-

"""задаем два списка (первый длиннее второго)"""
a = ['Mary', 'had', 'a', 'little', 'lamb', 'torn', 'lost', 'John']
b = [2, 3, 5, 6, 7, 8, 6]
"""создаем словарь"""
dictab = dict(zip(a, b + [None] * (len(a) - len(b))))
"""печетаем словарь"""
print(dictab)
