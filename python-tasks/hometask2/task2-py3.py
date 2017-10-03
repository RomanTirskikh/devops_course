#!usr/bin/python
# -*- coding: utf-8 -*-
"""создаем функцию проверки на палиндромность"""


def is_palindrome(string):
    """избавляемся от пробелов в строке"""
    string = string.lower().replace(' ', '')
    """для i равной целочисленной половине строки"""
    for i in range(len(string) // 2):
        """проверяем каджый i-тый знак сначала и конца строки на равенство"""
        if string[i] != string[-1-i]:
            """возвращаем Лож если не равны"""
            return False
    """возвращаем Правда если равны"""
    return True

"""присваиваем значение введенной строки преременной"""
my_str = input('Enter your palindrome string here: ')

"""печатем да если функция возвращает Правда, и нет если Лож"""
print('YES, it is palindrome! =)' if is_palindrome(
    my_str) else 'NO, it is not palindrome. =(')
