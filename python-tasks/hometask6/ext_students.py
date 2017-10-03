#!/usr/bin/python
# -*- coding: utf-8 -*-
# import sys
import string
import re
from random import *
from datetime import datetime
# sys.path.append( "/home/worker/python-tasks/hometask5/" )
# from student__ import Student
from student import Student

# создаем новый класс с унаследованием класса Student


class ExtenderStudent(Student):

    def __init__(self, fn, ln, bd, sx, sg, sp, cn, lo, ps):
        super(ExtenderStudent, self).__init__(fn, ln, bd, sx, sg, sp, cn)
        self.setBdate(bd)
        self.__log = lo
        self.__pas = ps

# из-за изменения вида входных данных переопределяем формат проверки даты

    @property
    def bdate(self):
        return self.__bdate

    def setBdate(self, value):
        valid = True
        if len(value) != 10:
            valid = False
        else:
            try:
                datetime.strptime(value, '%Y-%m-%d')
            except:
                valid = False
        if valid:
            self.__bdate = value
        else:
            raise ValueError("Birth date input error")

# переопределяем формат разделителя и добавляем новые аргументы log и pas

    @staticmethod
    def makeExSt(args):
        args = args.split(':::')
        if args[3] == 'M':
            args[3] = 'Male'
        else:
            args[3] = 'Female'
        args[4] = int(args[4])
        args[6] = int(args[6])
        log = ('' + args[0][0] + args[1]).lower()
        allchar = string.ascii_letters + string.digits
        pas = ''.join(choice(allchar) for x in range(randint(6, 9)))
        return ExtenderStudent(args[0], args[1], args[2], args[3], args[4],
                               args[5], args[6], log, pas)

    @property
    def pas(self):
        return self.__pas

    @property
    def log(self):
        return self.__log

# формируем строку

    def __str__(self):
        res = "Студент: "
        res += self.fname + ' ' + self.lname + ' ' + self.bdate
        res += ' ' + self.sex + ' ' + str(self.grade) + ' ' + self.spec
        res += ' ' + str(self.cnum) + ' ' + self.log + ' ' + self.pas
        return res

# открываем файл и определяем список студентов

file_input = open("students.dat", "r")
student_list = []
for line in file_input.readlines():
    student_list.append(ExtenderStudent.makeExSt(line))

# проверяем полученный список студентов на совпадения логина и меняем последний

i = len(student_list)
y = 0
for y in range(y, i):
    res1 = str(student_list[y])
    rs1 = res1.split(' ')
    x = 0
    for x in range(x, i):
        res2 = str(student_list[x])
        rs2 = res2.split(' ')
        count = 0
        if x != y:
            count += 1
            if rs1[-2] == rs2[-2]:
                rs2[-2] = rs2[-2] + str(count)
                j = len(rs2)
                z = 1
                student_list[x] = str(rs2[0])
                for z in range(z, j):
                    student_list[x] += (' ' + rs2[z])
            else:
                pass

file_input.close()

# записываем получившийся список студентов в файл

file_output = open("ext_students.dat", "w")
for student in student_list:
    file_output.write(str(student) + '\n')
file_output.close()
