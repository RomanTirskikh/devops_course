#!usr/bin/python
# -*- coding: utf-8 -*-

import psutil
import datetime
import time
import configparser


def ps_info():
    global now
    now = ('Date & Time: ') + str(datetime.datetime.now().strftime(
        '%d %b %Y %H:%M:%S'))
    global cpu
    cpu = ('CPU usage: ') + str(
        psutil.cpu_percent(interval=1, percpu=False)) + ('%')
    global mem
    mem = ('Memory available: ') + str(
        (psutil.virtual_memory().available) / 1024 / 1024) + ('Mb')
    global dskr
    dskr = ('Number of disk reads: ') + str(psutil.disk_io_counters(
        perdisk=False).read_count) + ('per/sec')
    global dskw
    dskw = ('Number of disk writs: ') + str(psutil.disk_io_counters(
        perdisk=False).write_count) + ('per/sec')
    global nets
    nets = ('Shipped traffic: ') + str(psutil.net_io_counters(
        pernic=False).bytes_sent / 1024 / 1024) + ('Mb')
    global netr
    netr = ('Received traffic: ') + str(psutil.net_io_counters(
        pernic=False).bytes_recv / 1024 / 1024) + ('Mb')

def wrt_info():
    ps_info()
    f = open('workfile', 'a')
    f.write('\n' + now + '\n' + cpu + '\n' + mem + '\n' + dskr + '\n' + (
        dskw + '\n' + nets + '\n' + netr + '\n'))
    f.close()

def config():
    cfg = configparser.ConfigParser()
    cfg.read('confps.cfg')
    interval = cfg.get("interval", "interval")
    result = {"interval": interval}
    return result


def main():
    while True:
        time.sleep(int(config()["interval"]))
        wrt_info()

main()

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
