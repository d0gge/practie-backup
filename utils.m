classdef utils
    methods (Access = public)
        function PrintSolution(self, solution, enum)
            if length(solution) ~= 0
                for i = 1:length(solution)
                    fprintf("x"+enum(i)+" = "+round(solution(i), 5)+"\n");
                end
            else
                disp(solution);
            end
        end
    end
end
