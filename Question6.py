import sympy as sp

print('6a:')
print(
    "Ordinary Differential Equations(ODEs): an equation relating a function of one "
    "independent variable to its derivatives(e.g., dy/dx=f(x, y)). 'Ordinary' "
    "distinguishes it from PDEs, which involve multiple independent variables."
)

print(
    "\n Nonlinear ODEs: ODEs where the unknown function or its derivatives appear in"
    "a nonlinear way(e.g., dy/dx=y², or involving sin(y), y·y', etc.). These generally"
    "can't be solved with simple algebraic techniques and rarely have closed-form solutions."
)

print(
    "\n Systems of nonlinear ODEs: multiple coupled nonlinear ODEs solved simultaneously"
    "(e.g., predator-prey models, chaotic systems like the Lorenz equations),"
    "where each equation's derivative depends on multiple unknown functions"
)

print(
    "\nImportance of Runge-Kutta Methods \n"
    "Numerical Approximation: Runge-Kutta methods compute step-by-step approximate solutions when formulas fail. \n"
    "Higher Accuracy: Instead of using just one slope like Euler's method, the popular fourth-order version (RK4) samples four slope estimates per step to mirror curved trajectories.\n"
    "Handling Nonlinearity: They solve complex nonlinear systems smoothly without needing higher-order analytical derivatives\n"
)


print('\n\n6b:')
X = [0, 1, 2]
Y = [1, 3, 7]
h = X[1] - X[0]

# Build forward difference table
n = len(Y)
diff_table = [Y[:]]
for level in range(1, n):
    prev = diff_table[-1]
    new_row = [prev[i+1] - prev[i] for i in range(len(prev)-1)]
    diff_table.append(new_row)

print("Forward difference table:")
for i, row in enumerate(diff_table):
    print(f"Order {i}: {row}")

# Newton Forward formula
x_val = sp.Rational(3, 2)  # 1.5
p = (x_val - X[0]) / h

y_interp = Y[0]
term = 1
for i in range(1, n):
    term = term * (p - (i-1)) / i
    y_interp += term * diff_table[i][0]

print(f"p = {p}")
print(f"y(1.5) = {sp.nsimplify(y_interp)} = {float(y_interp):.6f}")

print('\n\n6c:')

X = [0, 1, 2]
Y = [1, 3, 2]

x = sp.symbols('x')
n = len(X)

P = 0
for i in range(n):
    Li = 1
    for j in range(n):
        if j != i:
            Li *= (x - X[j]) / (X[i] - X[j])
    print(f"L_{i}(x) = {sp.simplify(Li)}")
    P += Y[i] * Li

P_expanded = sp.expand(P)
print(f"P(x) = {P_expanded}")

# Verify
for xi, yi in zip(X, Y):
    print(f"P({xi}) = {P_expanded.subs(x, xi)}  (expected {yi})")
