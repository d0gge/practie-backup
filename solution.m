% matrix = randi([0, 100], [3, 5]);
% matrix = [1, 0, 0, 0; 2, 0, 1, 3; 1, 2, 3, 4; 8, 9, 2, 1];
% matrix = [0,-1,3,1,5;0,8,5,4,4;0,0,0,0,1]
% matrix = [0,0,0,0,0;0,8,5,4,4;0,0,0,0,1]
% matrix= [0 0 0 0 0;0,8,5,4,4;0 4 -2 4 2;0,0,0,0,0];
%matrix = [0, 0, 0, 0, 0; 0, 4, 4, 5, 8; 0, 2, 4, 2, 4; 0, 0, 0, 0, 0];

clc;
% matrix = [3,-1,3;4,-1,5;2,-2,4];
matrix = [ 0 27 0 75;
           0 52 0 92;
]
methods = solution_methods();
utils = utils();
% rhs = [1,2,3, 4];
% rhs = [5, 4, 6];
rhs = [1, 2];
% rhs = [0;2;3;0];
% fprintf("Prolbem #1.\n");
% fprintf("Solving linear equations " + ...
%     "system using invertible matrix.\n\n");
% [solution_set, enum] = methods.SolveInvertible(matrix, rhs);
% disp("Solution set #1:");
% utils.PrintSolution(solution_set,  enum);
%
% fprintf("\nProlbem #2.\n");
% fprintf("Solving linear equations " + ...
%     "system using Cramer's rule.\n\n");
% [solution_set, enum] = methods.SolveCramer(matrix, rhs);
% fprintf("Solution set #2:\n");
% utils.PrintSolution(solution_set, enum);
% fprintf("\nProlbem #3.\n");
% fprintf("Solving linear equations " + ...
%     "system using Gaussian eliminations.\n\n");
[solution_set, enum] = methods.SolveGauss(matrix, rhs);
fprintf("Solution set #3\n");
utils.PrintSolution(solution_set, enum);
