import numpy as np
from scipy.linalg import lu
import math


Interpolation = '''
Interpolation is a mathematical method used to estimate 
unknown values that fall in between known data points.'''

Need_for_interpolation = '''
There are several reasons why interpolation is needed:
1. To estimate values at points where no data is available.
2. To smooth out data and reduce noise.
3. To predict future values based on existing data trends.
4. To create a continuous representation of discrete data points.'''

print('3a: Interpolation:', end=' ')
print(Interpolation, '\n')

print('Need for Interpolation:', end=' ')
print(Need_for_interpolation, '\n')

print('3b: Solving the following system of equations using fixed-point iteration:\n')


def g(x):
    return math.exp(-x)


print("initial guess: x(0) = 0.0")
x = 0.0
print(f"{'iter':<5}{'x_n':<15}")
print(f"{0:<5}{x:<15.4f}")

for i in range(1, 7):
    x = g(x)
    print(f"{i:<5}{x:<15.4f}")

print(f"Approximate root after 6 iterations: x = {x:.4f}")
print(f"Check: e^(-x) = {math.exp(-x):.4f}")


print('\n3c: Solving the following system of equations using LU decomposition:')
print('''
2x + 3y = 8
4x +  y = 10
''')
A = np.array([[2, 3],
              [4, 1]], dtype=float)
b = np.array([8, 10], dtype=float)

# Step 1: decompose A = P L U
P, L, U = lu(A)
print("P =\n", P)
print("L =\n", L)
print("U =\n", U)


# Step 2: forward substitution -> solve L*d = P^T*b
Pb = P.T @ b
d = np.linalg.solve(L, Pb)
print("d =", d)

# Step 3: back substitution -> solve U*x = d
sol = np.linalg.solve(U, d)
x, y = sol[0], sol[1]   # unpack into separate variables

print("\nFinal Answer:")
print(f"x = {x}")
print(f"y = {y}")
