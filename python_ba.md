# vanilla python #

# pandas #

<i>table = dataframe object</i>

import file with data

    file_path = 'path\\Results.csv'
    df = pandas.read_csv(file_path)

pandas functions/attributes

    df.head() - top 5 rows
    df.shape - number of rows, columns
    df.describe() - summary statistics
    df.values - values array
    df.columns - columns array
    df.info() - columns info, data types etc