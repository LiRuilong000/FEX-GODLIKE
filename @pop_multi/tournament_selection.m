function pool = tournament_selection(pop, pool_size, tournament_size)

    % initialize mating pool
    pool = zeros(pool_size, 1);

    % fill the mating pool
    for i = 1:pool_size

        % select [tournament_size] individuals at random
        equal = true;
        while equal % make sure they're not equal
            inds  = round( rand(tournament_size, 1)*(pop.size-1) + 1); % random indices
            equal = numel(unique(inds)) ~= numel(inds);        % check if any are equal
        end

        % let them compete according to
        % (xj < yj) if (rank(xj) < rank(yj))
        %           or (rank(xj) == rank(yj) and distance(xj) > distance(yj)
        ranks     = pop.pop_data.front_number(inds);
        distances = pop.pop_data.crowding_distance(inds);
        for j = 1:tournament_size
            % compare ranks
            less_rank = ranks(j) < [ranks(1:j-1); ranks(j+1:end)];
            % rank is less than all others
            if all(less_rank), best = inds(j); break; end
            % compare distances and rank equality
            more_dist = ranks(j) == [ranks(1:j-1); ranks(j+1:end)] &...
                        distances(j) >= [distances(1:j-1); distances(j+1:end)];
            % rank is equal, but distance is less than all others
            if any(~less_rank & more_dist), best = inds(j); break; end
        end % for

        % insert the index of the best one in the pool
        pool(i) = best;

    end % for
end % function (tournament selection)