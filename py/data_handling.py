

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


### from: https://www.kaggle.com/avijitduttta/ubiquant-dnn-prediction?scriptVersionId=89428670&cellId=3
def reduce_mem_usage(df):
    """ iterate through all the columns of a dataframe and modify the data type
        to reduce memory usage.        
    """
    start_mem = df.memory_usage().sum() / 1024**2
    print('Memory usage of dataframe is {:.2f} MB'.format(start_mem))
    
    for col in df.columns:
        col_type = df[col].dtype
        
        if col_type != object:
            c_min = df[col].min()
            c_max = df[col].max()
            if str(col_type)[:3] == 'int':
                if c_min > np.iinfo(np.int8).min and c_max < np.iinfo(np.int8).max:
                    df[col] = df[col].astype(np.int8)
                elif c_min > np.iinfo(np.int16).min and c_max < np.iinfo(np.int16).max:
                    df[col] = df[col].astype(np.int16)
                elif c_min > np.iinfo(np.int32).min and c_max < np.iinfo(np.int32).max:
                    df[col] = df[col].astype(np.int32)
                elif c_min > np.iinfo(np.int64).min and c_max < np.iinfo(np.int64).max:
                    df[col] = df[col].astype(np.int64)  
            else:
                #if c_min > np.finfo(np.float16).min and c_max < np.finfo(np.float16).max:
                #    df[col] = df[col].astype(np.float16)
                #elif c_min > np.finfo(np.float32).min and c_max < np.finfo(np.float32).max:
                #    df[col] = df[col].astype(np.float32)
                #else:
                df[col] = df[col].astype(np.float16)
        else:
            df[col] = df[col].astype('category')

    end_mem = df.memory_usage().sum() / 1024**2
    print('Memory usage after optimization is: {:.2f} MB'.format(end_mem))
    print('Decreased by {:.1f}%'.format(100 * (start_mem - end_mem) / start_mem))
    
    return df
    



