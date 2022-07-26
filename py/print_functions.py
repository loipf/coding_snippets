import time



def print_time(txt):
    # from datetime import datetime
    dateTimeObj = datetime.now()
    timestamp_str = dateTimeObj.strftime("%d-%m-%Y %H:%M:%S")
    print('### ' + timestamp_str + '   ' + txt)



def sec_to_timestamp(sec):
    return time.strftime('%H:%M:%S', time.gmtime(sec))



def print_dict(d):
    for i in d:
        print(i,': ',d[i])


