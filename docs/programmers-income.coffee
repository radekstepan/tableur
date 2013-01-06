# Currency multipliers.
currencies = {}
for key in [12...17] when A[key] and B[key]
  currencies[A[key]] = B[key]

# Convert amount into USD.
toDollars = (text) ->
  return 0 unless text # empties
  [ amount, currency ] = text.split(' ')
  amount * currencies[currency]

# Main runner.
calc = (col) ->
  # Salary in monthly USD.
  salary = toDollars(col[2]) / 12
  # Take tax from salary.
  tax = 1 - parseFloat(col[3]) / 100
  salary = salary * tax
  # Get child edu cost in USD.
  edu = toDollars(col[4])
  # Get personal and child expenses in USD.
  exp = toDollars(E[15]) + toDollars(E[16])
  # Adjust expenses by living costs.
  exp = exp * col[1]
  # Extra costs incurred?
  extra = toDollars(col[5])
  # Show result.
  col[7] = Math.floor salary - edu - exp - extra
  # Is it sustainable?
  col[8] = ''
  if col[7] < 0 then col[8] = 'Not enough!'
  # Add the currency.
  col[7] = col[7] + ' USD'

# Run the calc on these columns.
( calc(col) for col in [ B, C, D, E, F, G ] )