clc;clear;
matrix = input("Enter a matrix: ");
rhs = input("Enter free coefficients: ");
methods = solution_methods();
utils = utils();
fprintf("Solving linear equations " + ...
    "system using Gaussian eliminations.\n\n");
[solution_set, enum] = methods.SolveGauss(matrix, rhs);
fprintf("Solution set:\n");
utils.PrintSolution(solution_set, enum);
