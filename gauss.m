clc;clear;
matrix = [3,-1,3;4,-1,5;2,-2,4];
rhs = [5, 4, 6];
methods = solution_methods();
utils = utils();
fprintf("Solving linear equations " + ...
    "system using Gaussian eliminations.\n\n");
[solution_set, enum] = methods.SolveGauss(matrix, rhs);
fprintf("Solution set #3\n");
utils.PrintSolution(solution_set, enum);
