classdef calcobj_RAP_CS_SBI < PROBLEM
% <2021> <multi> <binary> <large/none> <expensive/none> <sparse/none>
% The community detection problem
% dataNo --- 1 --- Number of dataset

%------------------------------- Reference --------------------------------
% Y. Tian, C. Lu, X. Zhang, K. C. Tan, and Y. Jin, Solving large-scale
% multi-objective optimization problems with sparse optimal solutions via
% unsupervised neural networks, IEEE Transactions on Cybernetics, 2021,
% 51(6): 3115-3128.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB Platform
% for Evolutionary Multi-Objective Optimization [Educational Forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    methods
    	%% Default settings of the problem
        function Setting(obj)
            global d;
            % Problem info
            obj.M = 2;
            obj.D = d;
            obj.lower    = [0*ones(1, obj.D)];
            obj.upper    = [255*ones(1, d/2),3*ones(1, d/2)];
            obj.encoding = [1 + zeros(1,d/2),2 + zeros(1,d/2)]; %half real, half integer
            % Maximum and minimum objective values for normalization
        end
        %% Random initialization
        function Population = Initialization(obj,N)
            global d;
        %Initialization - Generate multiple initial solutions.
        %
        %   P = obj.Initialization() randomly generates the decision
        %   variables of obj.N solutions and returns the SOLUTION objects.
        %
        %   P = obj.Initialization(N) generates N solutions.
        %
        %   This function is usually called at the beginning of algorithms.
        %
        %   Example:
        %       Population = Problem.Initialization()
        
            if nargin < 2
            	N = obj.N;
            end
            PopDec = zeros(N,obj.D);
            Type   = arrayfun(@(i)find(obj.encoding==i),1:5,'UniformOutput',false);
            if ~isempty(Type{1})        % Real variables
                PopDec(:,Type{1}) = unifrnd(repmat(obj.lower(Type{1}),N,1),repmat(obj.upper(Type{1}),N,1));
            end
            if ~isempty(Type{2})        % Integer variables
                PopDec(:,Type{2}) = round(unifrnd(repmat(obj.lower(Type{2}),N,1),repmat(obj.upper(Type{2}),N,1)));
            end
            if ~isempty(Type{3})        % Label variables
                PopDec(:,Type{3}) = round(unifrnd(repmat(obj.lower(Type{3}),N,1),repmat(obj.upper(Type{3}),N,1)));
            end
            if ~isempty(Type{4})        % Binary variables
                PopDec(:,Type{4})  = logical(randi([0,1],N,length(Type{4})));
                obj.lower(Type{4}) = 0;
                obj.upper(Type{4}) = 1;
            end
            if ~isempty(Type{5})        % Permutation variables
                [~,PopDec(:,Type{5})] = sort(rand(N,length(Type{5})),2);
                obj.lower(Type{5})    = 1;
                obj.upper(Type{5})    = length(Type{5});
            end
            %specialized SBI initialization
            [pop_size,~] = size(PopDec);
            m = d/2;
            X(1:m, 1:8, 1:pop_size) = 0;
            for individual = 1:pop_size
                for f = 1:m
                    for gene = 1:8
                        if rand(1) <= sqrt((individual-0.5)/pop_size)
                            g = 0;
                        else
                            g = 1;                
                        end
                        X(f, gene, individual) = g;
                    end
                end
            end
            for individual = 1:pop_size
               PopDec(individual,1:m) = sum(2.^(7:-1:0).*X(:,:,individual),2);
            end
            Population = obj.Evaluation(PopDec);
        end

        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            global archive_obj_vals archive_sols iter;
            iter = iter + 1;
            PopObj = zeros(size(PopDec,1),obj.M);
            for i = 1 : size(PopObj,1)
                C = PopDec(i,:);
                [temp1,temp2] = obj_true_CS(C);
                temp1 = -temp1; %maximization to minimization
                PopObj(i,1) = temp1;
                PopObj(i,2) = temp2;
            end
            archive_obj_vals{iter,:} = PopObj;
            archive_sols{iter,:} = PopDec;
        end
        %% Display a population in the decision space
    end
end
