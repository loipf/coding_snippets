

# flattens a list of lists, appropriate for strings
def flattenList(A):
    rt = []
    for i in A:
        if isinstance(i, list):
            rt.extend(flattenList(i))
        else:
            rt.append(i)
    return rt




# replace special characters [for anova]
def replaceSpecialChars(text):
    chars = "!@#$%^&*()[]{};,./<>?|`~-=+:~\ "
    for c in chars:
        text = text.replace(c, "_")
    return text



# converts str to boolean values
def str_to_bool(s):
    if s == 'True':
        return True
    elif s == 'False':
        return False
    else:
        raise ValueError("Cannot covert {} to a bool".format(s))


# converts str  to list e.g. "['ds', 'asf ']" to list of ['ds', 'asf ']
def str_to_list(l):
    if l == '[]':
        return list()
    else:
        l = l.strip('][').replace("', ", "',").replace("'", '').split(',')
        return list(l)


def str_to_dict(d):
    if d == '{}':
        return dict()
    else:
        return eval(d)




