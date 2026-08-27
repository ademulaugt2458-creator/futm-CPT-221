print('5a:')
print(" Explicit Runge-kutta: Calculates each intermediate stage sequentially using only previously known values and derivative evaluations")
print(" Implicit Runge-kutta: Calculates each intermediate stage simultaneously, often requiring the solution of a system of equations at each step")

print('\n5b: Solving the System of equation using Guass seidel method')
print('''
10x +  y +  z = 12
2x + 10y +  z = 13
2x +  2y + 10z = 14
''')
x, y, z = 0.0, 0.0, 0.0
print("initial guess x(0)=0, y(0)=0, z(0)=0 ")

print(f"{0:<5}{x:<12.4f}{y:<12.4f}{z:<12.4f}")


for i in range(1, 5):
    x = (12 - y - z) / 10
    y = (13 - 2*x - z) / 10       # note: uses the NEW x just computed
    z = (14 - 2*x - 2*y) / 10     # uses the NEW x and y just computed
    print(f"{i:<5}{x:<12.4f}{y:<12.4f}{z:<12.4f}")

print(f"Approximate solution: x = {x:.4f}, y = {y:.4f}, z = {z:.4f}")


print('\n5c: Runge-Kutta method for the ODE dy/dx = x + y with initial condition y(0) = 1. find y(0.2).\n')


def f(x, y):
    return x + y


x = 0.0
y = 1.0
h = 0.1

for step in range(2):   # 2 steps of h=0.1 -> reach x=0.2
    k1 = f(x, y)
    k2 = f(x + h/2, y + h/2*k1)
    k3 = f(x + h/2, y + h/2*k2)
    k4 = f(x + h,   y + h*k3)

    y_new = y + (h/6)*(k1 + 2*k2 + 2*k3 + k4)
    x_new = x + h

    print(f"y({x_new:.1f}) = {y_new:.4f}")
    x, y = x_new, y_new

print(f"Final answer: y(0.2) = {y:.4f}")
