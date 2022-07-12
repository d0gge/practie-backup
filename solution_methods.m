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

        function [transformedMatrix, transformedRhs, blank] =...
                selectAnotherRow(self, matrix, rhs, row, col)
            [row_size, col_size] = size(matrix);
            blank = true;
            selectedElement = matrix(row, col);
            selected = row;

            for j = col:col
                for i = (col + 1):row_size
                    for k = j:col_size
                        if matrix(i, k) ~= selectedElement;
                            if matrix(:, j) == zeros(1, row_size)
                                blank = true;
                            else
                                blank = false;
                            end
                            temp = matrix(selected, :);
                            matrix(selected, :) = matrix(i, :);
                            matrix(i, :) = temp;
                            temp = rhs(selected);
                            rhs(selected) = rhs(i);
                            rhs(i) = temp;
                            transformedMatrix = matrix;
                            transformedRhs = rhs;
                            return;
                        end
                    end
                end
            end
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
        end

        function [matrix, enum] = selectAnotherColumn(self, matrix, enum, column)
            [row_size, col_size] = size(matrix);
            temp = matrix(:, column);
            for col=col_size:-1:1
                for row =1:row_size
                    if matrix(row, col) ~= 0
                        matrix(:, column) = matrix(:, col);
                        matrix(:, col) = temp;
                        temp = enum(column);
                        enum(column) = enum(col);
                        enum(col) = temp;
                        return;
                    end
                end
            end
        end
    end


    methods (Access = public)

        function [solution_set, enum, successful] = SolveGauss(self, matrix, rhs)
            [row_size, col_size] = size(matrix);
            solution_set = [];
            enum = [1:1:col_size];
            blank = false;
            successful = false;

            if row_size > col_size
                fprintf("This system is overdetermined. There is no solution.");
                return;
            end

            if length(rhs) == 0
                rhs = zeros(length(matrix), 1);
            end
            solution_set = zeros(col_size, 1);

            % checking if there is zero row
            for row = 1:row_size
                if row > row_size
                    break;
                end
                if matrix(row, :) == zeros(1, col_size)
                    matrix(row, :) = [];
                    rhs(row) = [];
                    row_size = row_size - 1;
                end
            end

            for col = 1:col_size
                for row = (col + 1):row_size
                    if matrix(col, col) == 0
                        [matrix, rhs, blank] =self...
                            .selectAnotherRow(matrix, rhs, col, col);
                    end

                    if blank
                        [matrix, enum] = self...
                            .selectAnotherColumn(matrix, enum, col);
                        blank = false;
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

            if matrix(row_size, row_size) == 0
                [matrix, enum] = self...
                    .selectAnotherColumn(matrix, enum, row_size);
            end

            solution_set(row_size) =...
                rhs(row_size)/matrix(row_size, row_size);
            for i = (row_size-1):-1:1
                sum = 0;
                for j = row_size:-1:i
                    sum = sum + matrix(i, j)*solution_set(j);
                end
                solution_set(i) = (rhs(i)-sum)/matrix(i, i);
            end
            successful = true;
        end

        function [solution_set, enum, successful] = SolveInvertible(self, mat, rhs)
            [rr, rc] = size(rhs);
            solution_set = [];
            enum = [1:1:rc];
            successful = false;

            if ~self.isValid(mat)
                return;
            end

            if self.isZeroMat(mat)
                solution_set = [0];
                return;
            end

            if self.det(mat) ~= 0
                if length(rhs) == 0
                    rhs = zeros(1, length(mat));
                end

                if rc > rr
                    rhs = rhs';
                end
                inverted =...
                    1/self.det(mat)*self.create_adjugate(mat);
                solution_set = inverted * rhs;
                successful = true;
            else
                disp("There is no solution i.e. determinant equals to 0.");
                solution_set = [];
            end
        end

        function [solution_set, enum, successful] = SolveCramer(self, matrix, rhs)
            solution_set = [];
            [r, c] = size(matrix);
            enum = [1:1:c];
            successful = false;

            if ~self.isValid(matrix)
                return;
            end

            if self.isZeroMat(matrix)
                solution_set = [0];
                return;
            end

            del = self.det(matrix);
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
                deli = self.det(matrix);
                solution_set(i) = deli/del;
                matrix(:, i) = temp;
            end
            successful = true;
        end
    end
end
