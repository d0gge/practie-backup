classdef solution_methods
    methods (Access = public)

        function minor = get_minor(self, matrix, bad_row, bad_col)
            [r, c] = size(matrix);
            minor = zeros(r-1, c-1);
            row = 1; col = 1;
            for i = 1:r
                for j = 1:c
                    if i ~= bad_row && j ~= bad_col
                        minor(row, col) = matrix(i, j);
                        col = col + 1;

                        if (col == c)
                            row = row + 1;
                            col = 1;
                        end
                    end
                end
            end
        end

        function determinant = det(self, mat)
            determinant = 0;
            [r, c] = size(mat);
            if r == 1 && c == 1
                determinant = mat(1, 1);
                return;
            end
            sign = 1;
            for col = 1:c
                minor = self.get_minor(mat, 1, col);
                determinant = determinant +...
                    sign * mat(1, col) * self.det(minor);
                sign = -sign;
            end
        end

        function adj = create_adjugate(self, mat)
            [r, c] = size(mat);
            if r == 1 && c == 1
                adj = [1];
                return;
            end
            adj = zeros(r, c);
            sign = 1;
            for i = 1:r
                for j = 1:c
                    minor = self.get_minor(mat, i, j);
                    if rem((i+j), 2) == 0
                        sign = 1;
                    else
                        sign = -1;
                    end
                    %interchanging rows and columns to transpose the matrix
                    adj(j, i) = sign * self.det(minor);
                end
            end
        end

        function [transformedMatrix, transformedRhs] =...
                selectAnoterRow(self, matrix, rhs, row, col)
            size = length(matrix);
            selectedElement = matrix(row, col);
            selected = row;
            
            for j = col:col
                for i = (col + 1):size
                    if abs(matrix(i, j)) > selectedElement
                        temp = matrix(selected, :);
                        matrix(selected, :) = matrix(i, :);
                        matrix(i, :) = temp;
                        temp = rhs(selected);
                        rhs(selected) = rhs(i);
                        rhs(i) = temp;
                    end
                end
            end
            transformedMatrix = matrix;
            transformedRhs = rhs;
        end

        function acknowledgement = isValid(self, matrix)
            acknowledgement = true;
            [row_size, col_size] = size(matrix);
            if col_size > row_size
                disp("The system is undetermined. There " + ...
                    "is infinite number of solutions.");
                acknowledgement = false;
            end
            if row_size > col_size
                disp("The system is overdetermined. " + ...
                    "There is no solution.");
                acknowledgement = false;
            end
        end
        
        function acknowledgement = isZeroMat(self, matrix)
            [row_size, col_size] = size(matrix);
            if row_size == 0 && col_size == 0
                acknowledgement = true;
                return;
            end
            acknowledgement = false;
;        end
    end


    methods (Static)

        function solution_set = SolveGauss(instance, matrix, rhs)
            [row_size, col_size] = size(matrix);
            solution_set = [];

            if ~instance.isValid(matrix)
                return;
            end

            if instance.isZeroMat(matrix)
                solution_set = [0];
                return;
            end

            if instance.det(matrix) == 0
                disp("Return message...");
                return;
            end
            if length(rhs) == 0
                rhs = zeros(length(matrix), 1);
            end

            for col = 1:col_size
                for row = (col + 1):row_size
                    if matrix(col, col) == 0
                        [matrix, rhs] = instance...
                            .selectAnoterRow(matrix, rhs, col, col);
                    end
                    if matrix(row, col) == 0
                        continue;
                    end
                    multiplier = matrix(row, col)/matrix(col, col);
                    matrix(row, :) = matrix(row, :)...
                        - multiplier*matrix(col, :);
                    rhs(row) = rhs(row) - multiplier*rhs(col);
                end
            end

            solution_set(row_size) =...
                rhs(row_size)/matrix(row_size, col_size);
            for i = (row_size-1):-1:1
                sum = 0;
                for j = col_size:-1:i
                    sum = sum + matrix(i, j)*solution_set(j);
                end
                solution_set(i) = (rhs(i)-sum)/matrix(i, i);
            end
        end
            
        function solution_set = SolveInvertible(instance, mat, rhs)
            [rr, rc] = size(rhs);
            
            if ~instance.isValid(mat)
                return;
            end

            if instance.isZeroMat(mat)
                solution_set = [0];
                return;
            end

            if instance.det(mat) ~= 0
                if length(rhs) == 0
                    rhs = zeros(1, length(mat));
                end
                
                if rc > rr
                    rhs = rhs';
                end
                inverted =...
                    1/instance.det(mat)*instance.create_adjugate(mat);
                solution_set = inverted * rhs;
            else
                disp("There is no solution i.e. determinant equals to 0.");
                solution_set = [];
            end
        end

        function solution_set = SolveCramer(instance, matrix, rhs)
            solution_set = [];
            [r, c] = size(matrix);
            
            if ~instance.isValid(matrix)
                return;
            end

            if instance.isZeroMat(matrix)
                solution_set = [0];
                return;
            end

            del = instance.det(matrix);
            if del == 0
                disp("There is no solution.");
                return;
            end
            solution_set = zeros(length(matrix), 1);
            if length(rhs) == 0
                rhs = length(matrix);
            end
            
            for i = 1:r
                temp = matrix(:, i);
                matrix(:, i) = rhs;
                deli = instance.det(matrix);
                solution_set(i) = deli/del;
                matrix(:, i) = temp;
            end
        end
    end
end