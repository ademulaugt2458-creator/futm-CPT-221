import sympy as sp


print("4a: Question: Define Numerical Computation and explain its importance in computer science")
print(
    "Answer: Numerical computation is the process of using algorithms and numerical methods to solve"
    " mathematical problems that are typically continuous in nature. It involves approximating solutions"
    " to equations, performing numerical integration and differentiation, and solving systems of equations, among other tasks.\n"
)
print(
    "Importance in computer science: Numerical computation is crucial in computer science as it enables the simulation "
    "and modeling of complex systems, optimization problems, and data analysis. "
    "It allows for the efficient handling of large datasets, solving real-world problems in engineering, physics, finance, "
    "and other fields. Additionally, numerical methods are foundational for developing algorithms"
    "that can be implemented on computers to provide accurate and reliable results."
)

print("\n\n4b:")
print("Newton-Raphson method for the function f(x) = x^2 - 5, starting with x0 = 2.\n")

# 1. Define the symbol and the function
x = sp.symbols('x')
f = x**2 - 5   # root of x^2 - 5 = 0

# 2. Automatically compute the first derivative f'(x)
f_prime = sp.diff(f, x)

# 3. Create the Newton-Raphson formula for a general step
x_n = sp.symbols('x_n')
newton_step = x_n - (f.subs(x, x_n) / f_prime.subs(x, x_n))

print("Function f(x):", f)
print("Derivative f'(x):", f_prime)
print("\nNewton-Raphson formula for this function:")
print(f"x_n1 = {newton_step}")

# Convert the SymPy formula into a fast numerical function
next_guess = sp.lambdify(x_n, newton_step)

# Run the iterations
guess = 2.0   # x0 = 2, as given in the question
print(f"\nIteration 0: x = {guess}")
for i in range(1, 4):
    guess = next_guess(guess)
    print(f"Iteration {i}: x = {guess:.10f}")

print(f"\nExact root sqrt(5) = {sp.sqrt(5).evalf(10)}")

print("4c:")
print("Runge-Kutta method for the ODE dy/dx = 2x + y with initial condition y(0) = 1, h=0.1, find y(0.3).\n")


def f(x, y):
    return 2*x + y


x = 0.0
y = 1.0
h = 0.1

for i in range(3):   # 3 steps: x = 0.1, 0.2, 0.3
    k1 = f(x, y)
    k2 = f(x + h/2, y + h/2*k1)
    k3 = f(x + h/2, y + h/2*k2)
    k4 = f(x + h,   y + h*k3)

    y_new = y + (h/6)*(k1 + 2*k2 + 2*k3 + k4)
    x_new = x + h

    print(f"x={x:.2f}  y={y:.4f}  k1={k1:.4f} k2={k2:.4f} k3={k3:.4f} k4={k4:.4f}")

    x, y = x_new, y_new

print(f"y({x:.1f}) = {y:.4f}")
