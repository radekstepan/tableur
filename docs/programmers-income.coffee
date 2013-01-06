# Currency multipliers.
currencies = {}
for key in [12...19] when A[key] and B[key]
  currencies[A[key]] = B[key]

# Convert amount into USD.
to$ = (text) ->
  return 0 unless text # empties
  [ amount, currency ] = text.split(' ')
  amount * currencies[currency]

# Main runner.
calc = (col) ->
  # Salary in monthly USD.
  salary = to$(col[2]) / 12
  # Take tax from salary.
  tax1 = 1 - parseFloat(col[3]) / 100
  tax2 = 1 - parseFloat(col[4]) / 100
  salary1 = salary * tax1
  salary2 = salary * tax2
  # Get child edu cost in USD.
  edu = to$(col[5])
  # Get personal and child expenses in USD.
  exp1 = to$(E[16])
  exp2 = to$(E[15]) + to$(E[16])
  # Adjust expenses by living costs.
  exp1 = exp1 * col[1]
  exp2 = exp2 * col[1]
  # Extra costs incurred?
  xtra = to$(col[6])
  
  # Show result.
  col[8] = Math.floor(salary1 - exp1 - xtra)
  col[8] = col[8] + ' USD'
  col[9] = Math.floor(salary2 - exp2 - edu - xtra)
  col[9] = col[9] + ' USD'

# Run the calc on these columns.
( calc(col) for col in [ B, C, D, E, F, G, H ] )