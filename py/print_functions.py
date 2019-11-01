import time



def print_time(text):
    print('### ' + time.strftime("%c") + '   ' + text)



def sec_to_timestamp(sec):
    return time.strftime('%H:%M:%S', time.gmtime(sec))



def print_dict(d):
    for i in d:
        print(i,': ',d[i])


