

### outputs pandas dataframe with format
# tab-separated (*.tsv);; comma-seperated (*.csv) ;; excel file (*.xlsx)
def save_df_file(df, path, file_format):
    if df is None:
        print('empty dataframe can not be saved')
    elif '.tsv' in file_format:
        if '.tsv' not in path:
            path = path + '.tsv'
        df.to_csv(path, index=False, sep='\t')
    elif '.csv' in file_format:
        if '.csv' not in path:
            path = path + '.csv'
        df.to_csv(path, index=False)
    elif '.xlsx' in file_format:
        if '.xlsx' not in path:
            path = path + '.xlsx'
        df.to_excel(path, index=False)