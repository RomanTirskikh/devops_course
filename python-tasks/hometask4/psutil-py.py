#!usr/bin/python
# -*- coding: utf-8 -*-

import psutil
import datetime
import time
import configparser


class Get_info:
    def __init__(self):
        self.ps_info()

    def ps_info(self):
        self.now = ('Date & Time: ') + str(datetime.datetime.now().strftime(
            '%d %b %Y %H:%M:%S'))
        self.cpu = ('CPU usage: ') + str(
            psutil.cpu_percent(interval=1, percpu=False)) + ('%')
        self.mem = ('Memory available: ') + str(
            (psutil.virtual_memory().available) / 1024 / 1024) + ('Mb')
        self.dskr = ('Number of disk reads: ') + str(psutil.disk_io_counters(
            perdisk=False).read_count) + ('per/sec')
        self.dskw = ('Number of disk writs: ') + str(psutil.disk_io_counters(
            perdisk=False).write_count) + ('per/sec')
        self.nets = ('Shipped traffic: ') + str(psutil.net_io_counters(
            pernic=False).bytes_sent / 1024 / 1024) + ('Mb')
        self.netr = ('Received traffic: ') + str(psutil.net_io_counters(
            pernic=False).bytes_recv / 1024 / 1024) + ('Mb')


class Write_info(Get_info):
    def __init__(self):
        self.run()

    def wrt_info(self):
        f = open('workfile', 'a')
        f.write('\n' + self.now + '\n' + self.cpu + '\n' + self.mem + '\n' + (
            self.dskr + '\n' + self.dskw + '\n' + (
                self.nets + '\n' + self.netr + '\n')))
        f.close()

    def config(self):
        cfg = configparser.ConfigParser()
        cfg.read('confps.cfg')
        interval = cfg.get("interval", "interval")
        result = {"interval": interval}
        return result

    def run(self):
            while True:
                self.ps_info()
                self.wrt_info()
                time.sleep(int(self.config()["interval"]))

rn = Write_info()

# def intcheck(count):
#    try:
#        val = int(count)
#        print('YES, it is integer value! Operations are underway =)')
#        return val
#        return True
#    except:
#        return False

# my_count = raw_input('Enter numder of iteration repeat: ')

# if intcheck(my_count):
#    psinfo(val)
# else:
#    print('NO, it is not integer value =(')
