from math import exp, sqrt

from numpy import arange

from genetic_random_descent import genetic_random_descent

x = [round(num, 3) for num in arange(-5, 5, .02)]
y = [round(num, 3) for num in arange(-5, 5, .05)]
def f_test(var1, var2):
    return exp(var1 + var2) * var1**2 + var2**3 * (var1+var2)**5

new_population = genetic_random_descent(f_test, var1=x, var2=y)
print(new_population)