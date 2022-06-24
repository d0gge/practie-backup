matrix = randi([0, 100], [4, 4]);
% matrix = [1, 0, 0, 0; 2, 0, 1, 3; 1, 2, 3, 4; 8, 9, 2, 1];
instance = solution_methods();
rhs = [1,2,3, 4];
disp("Prolbem #1.") 
disp("Solving linear equations " + ...
    "system using invertible matrix.");
solution_set = solution_methods.SolveInvertible(instance, matrix, rhs);
disp("Solution set #1: ");
disp(solution_set);
disp("Prolbem #2.")
disp("Solving linear equations " + ...
    "system using Cramer's rule.");
solution_set = solution_methods.SolveCramer(instance, matrix, rhs);
disp("Solution set #2: ");
disp(solution_set);
disp("Prolbem #3.") 
disp("Solving linear equations " + ...
    "system using Gaussian eliminations.");
solution_set = solution_methods.SolveGauss(instance, matrix, rhs);
disp("Solution set #3: ");
disp(solution_set');