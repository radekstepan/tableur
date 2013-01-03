fs = require 'fs'
cs = require 'coffee-script'

# Spreadsheet.
sheet = {}
sheet.a = [ 1, 2 ]
a = sheet.a # local ref

# User code.
code = """
sheet.a[2] = 5
sheet.b[3] = "oh my"
# tricky now
x = sheet.cgg # oh yeah
x[0] = 7
sheet['C'][0] = 1
sheet['db'][9] = 'possible?'
"""

# Dumb "parse" finding all refs to a sheet.
for match in code.match /sheet\.[\S]*|sheet\[(\"|\')[\S]*(\"|\')\]/gi
    match = match.replace /sheet/gi, ''
    if column = (match.match(/\w+/))[0]
        # Create the column?
        sheet[column] ?= []

# Compile CS to JS wo/ closure.
code = cs.compile code, 'bare': 'on'

# Eval.
try
    eval code
catch e
    console.log e

# Output "columns" now.
console.log sheet