from fractions import Fraction as F
import numpy as np

Characteristics_of_good_numerical_algorithms = '''
1. Accuracy
2. Stability
3. Efficiency
4. Robustness
5. Simplicity
6. Scalability
'''
print('\n2a: The following are the characteristics of good numerical algorithms:', end=' ')
print(Characteristics_of_good_numerical_algorithms, '\n')

print('2b: Solving the following system of equations using Elimination method:\n')

print('''
2x + y - z = 8    (1)
x - y + 2z = 3    (2)
3x + 2y + z = 13  (3)

Eliminate y using (1) and (2): (1)+(2) -> 3x + z = 11   ...(A)
Eliminate y using (1) and (3): 2*(1) - (3) -> x - 3z = 3 ...(B)
Solve (A),(B): from (A) z = 11-3x, sub into (B): 10x = 36 -> x = 18/5
''')

x = F(36, 10)
z = 11 - 3*x
y = 8 - 2*x + z

print(f"x = {x} = {float(x)}")
print(f"y = {y} = {float(y)}")
print(f"z = {z} = {float(z)}")

print("2x+y-z  (=8) :", 2*x + y - z)
print("x-y+2z  (=3) :", x - y + 2*z)
print("3x+2y+z (=13):", 3*x + 2*y + z)

A = np.array([[2, 1, -1], [1, -1, 2], [3, 2, 1]], dtype=float)
b = np.array([8, 3, 13], dtype=float)
solution = np.linalg.solve(A, b)
print("numpy [x,y,z] =", [f"{value:.2f}" for value in solution])

print('\n2c:')
print(
    'Solving the system of equation using bisection method \nfor the function'
    'f(x) = x^3 - 4, with initial interval [1,2] and performing 5 iterations:\n')


def f(x):
    return x**3 - 4


a, b = 1, 2
print(f"f({a}) = {f(a)},  f({b}) = {f(b)}")

for i in range(1, 6):
    c = (a + b) / 2
    fc = f(c)
    if f(a) * fc < 0:
        b = c
    else:
        a = c
    print(f"iter {i}: c = {c:.4f}, f(c) = {fc:.4f}, new interval = [{a}, {b}]")

print(f"Approximate root after 5 iterations: {(a+b)/2:.4f}")
print(f"Actual root: {4**(1/3):.4f}")
