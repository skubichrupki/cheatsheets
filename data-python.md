imports
```python
import pandas as pd
```

dataframe objects
```python
data.values # 2d NumPy array of values
data.columns # array/index of column names 
data.index # index of rows (row numbers/names)
```

pandas functions
```python
data.head() # top 5 rows
data.info() # data type info etc
data.describe() # basic statistics
data.shape # number of rows and columns
data.sort_values("created_at", ascending=False) # desc, can also pass an array on both arguments
data.sort_values(['name', 'age'], ascending=[True, False])
```
pandas where
```python
data[[created_at, updated_at]]
data[employee_id] > 50 # only returns true/false
data[data[employee_id] > 50]

isNew = data[created_at] > '2022-01-01'
isRed = data[color] = 'red'
data[isnew & isRed], data[isnew | isRed] # and, or

isNewStatus_id = data[status_id].isin([9,10,12])
isMewStatus_id_display = data[isNewStatus_id]

data
data[isNewStatus]
```


