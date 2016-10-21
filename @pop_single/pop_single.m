classdef pop_single < handle
% =insert documentation here=


% Please report bugs and inquiries to:
%
% Name       : Rody P.S. Oldenhuis
% E-mail     : oldenhuis@gmail.com    (personal)
%              oldenhuis@luxspace.lu  (professional)
% Affiliation: LuxSpace sàrl
% Licence    : BSD


% If you find this work useful, please consider a donation:
% https://www.paypal.me/RodyO/3.5

    % all properties are public
    properties
        algorithm          % type of optimization algorithm used
        funfcn             % objective function(s)
        individuals        % members of the population
        fitnesses          % corresponding fitnesses
        size               % population size
        lb                 % lower bounds
        ub                 % upper bounds
        orig_size          % original size of the input
        dimensions         % dimensions
        funevals   = 0;    % number of function evaluations made
        iterations = 0;    % iterations so far performed
        options            % options structure (see function [set_options] for info)
        pop_data           % structure to store intermediate data
        % contents for single-objective optimization:
        %      pop_data.parent_population
        %      pop_data.offspring_population
        %      pop_data.function_values_parent
        %      pop_data.function_values_offspring
    end

    % public methods
    methods (Access = public)

        % Constructor
        function pop = pop_single(varargin)

            % (delegate to private method; improves file organisation)
            pop = pop.construct_pop(varargin{:});

        end % function (constructor)

        % single iteration
        iterate(pop, times, FE);


    end % methods

    methods (Access = private, Hidden)
        % constructor is sizeable; put it in its own function to keep the classdef small
        pop = construct_pop(pop, varargin);
    end

    % % protected/hidden methods
    methods (Access = protected, Hidden)

        % tournament selection (only for GA)
        pool = tournament_selection(pop, pool_size, tournament_size);

        % generate new generation
        create_offspring(pop, pool, times, FE);

        % selectively replace the parent population with members
        % from the offspring population (single-objective optimization)
        replace_parents(pop);

        % evaluate the objective function(s) correctly
        evaluate_function(pop);

        % check boundaries
        [newpop, newfit] = honor_bounds(pop, newpop, newfit);

        % initialize algorithms
        initialize_algorithms(pop);

    end % methods (protected)

end % classdef
