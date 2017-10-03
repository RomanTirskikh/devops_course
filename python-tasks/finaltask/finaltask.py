#!/usr/bin/python
# -*- coding: utf-8 -*-

from random import randrange as rnd, choice
from random import *
import os.path


class Matrix(object):

    def __init__(self, M, N, table=None):
        self.width = M
        self.height = N
        if self.inic(table) == False:
            raise Exception(
                "The matrix does not correspond to a given dimension")

    def inic(self, mass):
        equal = True
        if mass is None:
            for i in range(self.height):
                for j in range(self.width):
                    mass[i][j] = 0
        else:
            if len(mass) == self.height:
                for row in mass:
                    if len(row) != self.width:
                        equal = False
            else:
                equal = False
            if equal:
                self.table = mass
        return equal

    def __str__(self):
        res = ''
        for row in self.table:
            for element in row:
                res += str(element) + ' '
            res += '\n'
        return res

    def is_identity(self):
        res = self.is_diagonal()
        for N in range(len(self.table)):
            for M in range(len(self.table[N])):
                if N == M:
                    if self.table[N][M] != 1:
                        res = False
                else:
                    if self.table[N][M] != 0:
                        res = False
        return res

    def is_square(self):
        res = False
        if self.width == self.height:
            res = True
        return res

    def is_zero(self):
        res = True
        for row in self.table:
            for element in row:
                if element != 0:
                    res = False
        return res

    def is_diagonal(self):
        res = self.is_square()
        if res:
            for N in range(len(self.table)):
                for M in range(len(self.table[N])):
                    if N != M:
                        if self.table[N][M] != 0:
                            res = False
        return res

    def transpose(self):
        self.table = list(zip(*self.table))
        temp = self.width
        self.width = self.height
        self.height = temp

    def __add__(self, other):
        res = None
        if (self.width == other.width) & (self.height == other.height):
            table = []
            for N in range(len(self.table)):
                table.append([])
                for M in range(len(self.table[N])):
                    table[N].append(self.table[N][M] + other.table[N][M])
            res = Matrix(self.width, self.height, table)
        else:
            raise Exception("Matrices of different sizes")
        return res

    def __sub__(self, other):
        res = None
        if (self.width == other.width) & (self.height == other.height):
            table = []
            for N in range(len(self.table)):
                table.append([])
                for M in range(len(self.table[N])):
                    table[N].append(self.table[N][M] - other.table[N][M])
            res = Matrix(self.width, self.height, table)
        else:
            raise Exception("Matrices of different sizes")
        return res

    def __mul__(self, other):
        res = None
        if self.height == other.width:
            table = []
            temp = []
            summ = 0
            for z in range(0, self.height):
                for j in range(0, other.width):
                    for i in range(0, self.width):
                        summ += self.table[z][i] * other.table[i][j]
                    temp.append(summ)
                    summ = 0
                table.append(temp)
                temp = []
            res = Matrix(self.height, self.height, table)
        else:
            raise Exception("Matrices of the wrong sizes")
        return res


class HorizontalVector(Matrix):

    def __init__(self, M, vector):
        self.height = 1
        self.width = M
        if self.inic(vector) == False:
            raise Exception(
                "The horizontal vector does not correspond to"
                " a given dimension")

    def is_identity(self):
        return False

    def is_square(self):
        return False

    def is_diagonal(self):
        return False


class VerticalVector(HorizontalVector):

    def __init__(self, N, vector):
        self.height = N
        self.width = 1
        if self.inic(vector) == False:
            raise Exception(
                "The vertical vector does not correspond to a given dimension")


def generateTable(x, y):
    a = []
    for h in range(y):
        a.append([])
        for l in range(x):
            a[h].append(rnd(0, 10))
    return a


def intcheck(a):
    res = True
    try:
        int(a)
    except:
        res = False
    return res


def executin(x, y):
    print "Создаем и инициализируем матрицу"
    table = generateTable(int(x), int(y))
    table1 = table
    file_output = open("matrix.dat", "w")
    for args in table1:
        file_output.write(str(args) + '\n')
    file_output.close()
    matr = Matrix(int(x), int(y), table)
    print str(matr)
    print "Единичная - " + str(matr.is_identity())
    print "Квадратная - " + str(matr.is_square())
    print "Нулевая - " + str(matr.is_zero())
    print "Диагональная - " + str(matr.is_diagonal()) + "\n"

    print "Транспонируем матрицу"
    matr.transpose()
    print str(matr)

    print "Создаем вторую матрницу"
    table = generateTable(int(y), int(x))
    table2 = table
    matr2 = Matrix(int(y), int(x), table)
    print str(matr2)

    print "Складываем:\n" + str(matr + matr2)

    print "Вычитаем:\n" + str(matr - matr2)

    print "Снова транспонируем первую матрицу"
    matr.transpose()
    print str(matr)

    print "Умножаем:\n" + str(matr * matr2)

    print "Создаем горизонтальный вектор матрицы 2"
    h_vector = HorizontalVector(len(table2[0]), [tuple(table2[0])])
    print str(h_vector)

    print "Создаем вертикальный вектор матрицы 1"
    rezul = []
    for i in range(len(table1)):
        rezul.append(str(table1[i][0]))
    v_vector = VerticalVector(len(table1), rezul)
    print str(v_vector)


def defSting(args):
    args = args.rstrip()
    args = args.replace(']', '').replace('[', '')
    args = args.split(', ')
    return args


def convint(string):
    for i in range(len(string)):
        for j in range(len(string[i])):
            if intcheck(string[i][j]):
                string[i][j] = int(string[i][j])
            else:
                print "can't convert value int"
                pass
    return string

cr_mtrx = raw_input(
    'Что-бы создать произвольную матрицу заданных размеров введите "1"\n'
    'Что-бы загрузить матрицу из файла введите "2"\n'
    'Внимание!\n'
    'Вторая матрица для операций будет сгенерированна автоматически\n'
    'на основании размеров выбранной из файла матрицы\n: ')

if intcheck(cr_mtrx):
    if int(cr_mtrx) == 1:
        x = raw_input('Введите длинну матрицы: ')
        y = raw_input('Введите высоту матрицы: ')
        if (intcheck(x)) & (intcheck(y)):
            executin(int(y), int(x))
        else:
            print "wrong input, end of program"
    elif int(cr_mtrx) == 2:
        path = raw_input('Введите путь к файлу матрицы: ')
        if os.path.exists(path):
            file_input = open(path, "r")
            mtrx_string = []
            for line in file_input.readlines():
                mtrx_string.append(defSting(line))
            print "Создаем и инициализируем матрицу из файла"
            mtrx_string = convint(mtrx_string)
            matr = Matrix(len(mtrx_string[0]), len(mtrx_string), mtrx_string)
            print str(matr)
            print "Единичная - " + str(matr.is_identity())
            print "Квадратная - " + str(matr.is_square())
            print "Нулевая - " + str(matr.is_zero())
            print "Диагональная - " + str(matr.is_diagonal()) + "\n"

            print "Транспонируем матрицу"
            matr.transpose()
            print str(matr)

            print "Создаем вторую матрницу"
            table = generateTable(len(mtrx_string), len(mtrx_string[0]))
            table2 = table
            matr2 = Matrix(len(mtrx_string), len(mtrx_string[0]), table2)
            print str(matr2)

            print "Складываем:\n" + str(matr + matr2)

            print "Вычитаем:\n" + str(matr - matr2)

            print "Снова транспонируем первую матрицу"
            matr.transpose()
            print str(matr)

            print "Умножаем:\n" + str(matr * matr2)

            print "Создаем горизонтальный вектор матрицы 2"
            h_vector = HorizontalVector(len(table2[0]), [tuple(table2[0])])
            print str(h_vector)

            print "Создаем вертикальный вектор матрицы 1"
            rezul = []
            for i in range(len(mtrx_string)):
                rezul.append(str(mtrx_string[i][0]))
            v_vector = VerticalVector(len(mtrx_string), rezul)
            print str(v_vector)
        else:
            print "Path not exist, end of program"
            pass
    else:
        pass
else:
    print "wrong input, end of program"
