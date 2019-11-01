

# get asterix values for significant p-values
def getAsterix(pval):
    if pval is not None:
        pval = float(pval)
        mapper = {1: '', .1: ' .', .05: ' *', .01: ' **', .001: ' ***', .0001: ' ***', }
        possible_p = [.0001, .001, .01, .05, .1, 1]
        for p in possible_p:
            if pval <= p:
                return (mapper[p])
    return ''



# round and format to scientific annotation
def roundPvalue(pval):
    if pval is not None:
        if pval > 0.0001:
            return str(round(pval,5))
        else:
            return '{:0.3e}'.format(pval)
    return ''