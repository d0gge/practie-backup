clc;clear;
matrix = input("Enter a matrix: ");
rhs = input("Enter free coefficients: ");
methods = solution_methods();
utils = utils();
fprintf("Solving linear equations " + ...
    "system using invertible matrix.\n\n");
[solution_set, enum] = methods.SolveInvertible(matrix, rhs);
fprintf("Solution set:\n");
utils.PrintSolution(solution_set, enum);
