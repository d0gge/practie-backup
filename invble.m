clc;clear;
matrix = [3,-1,3;4,-1,5;2,-2,4];
rhs = [5, 4, 6];
methods = solution_methods();
utils = utils();
fprintf("Solving linear equations " + ...
    "system using invertible matrix.\n\n");
[solution_set, enum] = methods.SolveInvertible(matrix, rhs);
disp("Solution set #1:");
utils.PrintSolution(solution_set,  enum);
