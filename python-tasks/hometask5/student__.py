#!usr/bin/python
# -*- coding: utf-8 -*-

from datetime import datetime


class Student(object):

    def __init__(self, fn, ln, bd, sx, sg, sp, cn):
        self.setFname(fn)
        self.setLname(ln)
        self.setBdate(bd)
        self.setSex(sx)
        self.grade = sg
        self.spec = sp
        self.cnum = cn

    @property
    def fname(self):
        return self.__fname

    @property
    def lname(self):
        return self.__lname

    @property
    def bdate(self):
        return self.__bdate

    @property
    def sex(self):
        return self.__sex

    @property
    def grade(self):
        return self.__grade

    @grade.setter
    def grade(self, value):
        self.setGrade(value)

    @property
    def spec(self):
        return self.__spec

    @spec.setter
    def spec(self, value):
        self.setSpec(value)

    @property
    def cnum(self):
        return self.__cnum

    @cnum.setter
    def cnum(self, value):
        self.setCnum(value)

    def setFname(self, value):
        if isinstance(value, str):
            if len(value) <= 25:
                self.__fname = value
            else:
                raise ValueError("First name input error")
        else:
            raise ValueError("First name input error")

    def setLname(self, value):
        if isinstance(value, str):
            if len(value) <= 25:
                self.__lname = value
            else:
                raise ValueError("Last name input error")
        else:
            raise ValueError("Last name input error")

    def setBdate(self, value):
        valid = True
        if len(value) != 10:
            valid = False
        else:
            try:
                datetime.strptime(value, '%d.%m.%Y')
            except:
                valid = False
        if valid:
            self.__bdate = value
        else:
            raise ValueError("Birth date input error")

    def setSex(self, value):
        if (value == 'Male') | (value == 'Female'):
            self.__sex = value
        else:
            raise ValueError("Gender input error")

    def setGrade(self, value):
        if isinstance(value, int):
            if value in range(0, 11):
                self.__grade = value
            else:
                raise ValueError("Grade input error")
        else:
            raise ValueError("Grade input error")

    def setSpec(self, value):
        if isinstance(value, str):
            if len(value) <= 50:
                self.__spec = value
            else:
                raise ValueError("Specialty input error")
        else:
            raise ValueError("Specialty input error")

    def setCnum(self, value):
        if isinstance(value, int):
            if value in range(0, 6):
                self.__cnum = value
            else:
                raise ValueError("Course number input error")
        else:
            raise ValueError("Course number input error")

    def __str__(self):
#        res = "Студент: Дата рождения: Пол: Ср.балл: Специальность: Курс:\n"
        res = self.fname + ' ' + self.lname + ' ' + self.bdate + ' '
        res += self.sex + ' ' + str(self.grade) + ' ' + self.spec + ' ' + str(
            self.cnum)
        return res

    @staticmethod
    def defSt(string):
        args = string.split(':')
        if args[3] == 'M':
            args[3] = 'Male'
        else:
            args[3] = 'Female'
        args[4] = int(args[4])
        args[6] = int(args[6])
        return Student(
            args[0], args[1], args[2], args[3], args[4], args[5], args[6])


#student = Student(
#    "Ivan", "Ivanov", "30.05.1982", "Male", 8, "Math-analisys", 3)


#print student
#student = Student.defSt("Sergey:Ivanov:12.12.1983:M:8:Net-security:2")
#print student
