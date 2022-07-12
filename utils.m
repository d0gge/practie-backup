classdef utils
    methods (Access = public)
        function PrintSolution(self, solution, enum)
            if length(solution) ~= 0
                for i = 1:length(solution)
                    fprintf("x"+enum(i)+" = "+round(solution(i), 5)+"\n");
                end
            else
                fprintf("There is not solution\n");
            end
        end
    end
end
