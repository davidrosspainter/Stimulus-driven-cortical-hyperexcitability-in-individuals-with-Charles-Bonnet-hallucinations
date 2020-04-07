%% build_block3.m

% column numbers
column.trial_all = 1;
column.trial_block = 2;
column.block_num = 3;
column.search = 4;
column.colour_target = 5;
column.colour_distractor = 6;
column.freq1 = 7;
column.freq2 = 8;
column.peri_stim = 9;
column.targets = 10;
column.response = 11;
column.accuracy = 12;
column.eeg = 13;

if options.practice == true
    data1 = importdata('practice_eeg.txt');
    
    data = data1.data();
    [num_trials, not_used] = size(data);

	peri = [1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2]';
    peri = peri( randperm( length( peri ) ) );
    data(:,column.peri_stim) = peri;
    
else
	data1 = importdata('test_eeg.txt');
    
    data = data1.data();
    [num_trials, not_used] = size(data);
end

if options.all_conjunction == true
    data(:,column.search) = 2*ones(num_trials,1);
end

num_blocks = max( data(:,column.block_num) );
num_trials_block = max( data(:,column.trial_block) );

if options.random == false
    data_present(:,1) = 1:num_trials;
end


%% ----- trial_order
% trial_order(:,1) = trial number all
% trial_order(:,2) = trial number mini block
% trial_order(:,3) = block number

if options.practice == false
    block_order = randperm(num_blocks);
else
    block_order = 1:num_blocks;
end

temp1 = [];
temp2 = [];

for block = 1:num_blocks

    temp1 = [temp1; randperm(num_trials_block)'];
    temp2 = [temp2; block_order(block)*ones(num_trials_block,1)];

end

trial_order(:,2) = temp1;
trial_order(:,3) = temp2;

T = 0; % trial

for B = 1:num_blocks % block
    
    for trial = 1:num_trials_block
        
        T = T + 1;

        trial_order(   trial_order(:,2) == trial & ...
                        trial_order(:,3) == B, 1) = T; 
    end

end


%% stimuli
stimulus.displays = cell( num_trials, 1 );
stimulus.colours = cell( num_trials, 1 );
stimulus.letters = cell( num_trials, 1 );
stimulus.rotation = cell( num_trials, 1 );
stimulus.buffer = cell( num_trials, 1 );

epoch{1} = 3:12; % target displays (one target trials)
epoch{2} = 3:10; % first target displays (two target trials)
epoch{3} = 11:12; % second target displays (two target trials)

for T = 1:num_trials


    % ----- work out which displays will contain targets

    stimulus.displays{T}(:,1) = zeros(displays.number,1); % no targets
    
    if data(T, column.targets) == 1 % one target
        
        D = epoch{1}( randperm( length ( epoch{1} ) ) );
        D = D(1);
        stimulus.displays{T}(D) = 1;
    
    elseif data(T, column.targets) == 2 % two targets

        find_epoch = true;

        while find_epoch == true

            D1 = epoch{2}( randperm( length(epoch{2} ) ) );
            D1 = D1(1); % first target display

            D2 = epoch{3}( randperm( length(epoch{3} ) ) );
            D2 = D2(1); % second target display

            if D1 == 10 && D2 == 11
               % try again 
            else
                find_epoch = false;
            end
        
        end
        
        stimulus.displays{T}(D1) = 1;
        stimulus.displays{T}(D2) = 1;
        
    end

    % ----- randomise colour positions

    if data(T,column.search) == 1 % unique feature

                                   %L R (1 = target colour, 2 = distractor colour)
        stimulus.colours{T} =   [	2 2;
                                    2 2;
                                    2 2;
                                    2 2;
                                    2 2;
                                    2 2;
                                    2 2;
                                    2 2;
                                    2 2;
                                    2 2;
                                    2 2;
                                    2 2];

    elseif data(T,column.search) % conjunction

        stimulus.colours{T} = [   1 2;
                                    1 2;
                                    1 2;
                                    1 2;
                                    1 2;
                                    1 2;
                                    2 1;
                                    2 1;
                                    2 1;
                                    2 1;
                                    2 1;
                                    2 1];

        stimulus.colours{T} = stimulus.colours{T}( randperm( length( stimulus.colours{T} ) ), : ); % shuffle rows

    end


    % ----- put in target letters

    stimulus.letters{T} = NaN( displays.number, 2 );     
    stimulus.rotation{T} = NaN( displays.number, 2 );
    
    idx = find( stimulus.displays{T}(:,1) == 1 ); % find displays in which target appears

    % find position (left/right) of target
    
    for target = 1:length(idx) % target 

        if data(T,column.search) == 1 % unique feature

            if rand > .5
                P = 1; % left position
            else
                P = 2; % right position
            end

            stimulus.colours{T}( idx(target), P ) = 1; % target colour
            
        elseif data(T,column.search) == 2 % conjunction
            
           P = find( stimulus.colours{T}( idx(target),: ) == 1 ); % find target colour
           
        end
        
        stimulus.letters{T}( idx(target), P ) = 1; % T
        stimulus.rotation{T}( idx(target), P ) = 0; % upright

    end


    % work out which letters and rotations to present

    for D = 1:12  % display

        for P = 1:2 % position (1 = left, 2 = right)

            if isnan( stimulus.letters{T}(D,P) ) % if letter not already defined (as T)

                if rand < .5 % 50% probability
                    stimulus.letters{T}(D,P) = 1; % T
                else    
                    stimulus.letters{T}(D,P) = 2; % L
                end

            end

            find_rotation = true;

            while find_rotation == true

                if      stimulus.letters{T}(D,P) == 1 && ... % T
                        stimulus.colours{T}(D,P) == 1 && ... % target colour
                        stimulus.rotation{T}(D,P) == 0 % upright

                    find_rotation = false; % suitable rotation has been found

                elseif  stimulus.letters{T}(D,P) == 1 && ... % T
                        stimulus.colours{T}(D,P) == 1 && ... % target colour
                        stimulus.rotation{T}(D,P) ~= 0 % NOT upright

                        rot = [90 180 270]; % possible rotations
                        rot = rot( randperm( length( rot ) ) );
                        rot = rot(1); % random rotation

                elseif  stimulus.letters{T}(D,P) == 1 && ... % T
                        stimulus.colours{T}(D,P) == 2  % distractor colour

                        rot = [0 90 180 270]; % possible rotations
                        rot = rot( randperm( length( rot ) ) );
                        rot = rot(1); % random rotation

                elseif stimulus.letters{T}(D,P) == 2 % L

                    rot = [0 90 180 270]; % possible rotations
                    rot = rot( randperm( length( rot ) ) );
                    rot = rot(1); % random rotation

                end
                
                if find_rotation == false
                    break
                end
                
                stimulus.rotation{T}(D,P) = rot;

                if D > 1 && ... % current position contains same letter in same rotation in current and previous displays
                    stimulus.letters{T}(D,P) == stimulus.letters{T}(D-1,P) && ...
                    stimulus.rotation{T}(D,P) == stimulus.rotation{T}(D-1,P)

                else
                    find_rotation = false; % suitable rotation has been found 
                end

            end

        end

    end
    
    
    % work out buffers
    
    stimulus.buffer{T} = NaN( displays.number, 1 );
 
    for D = 1:displays.number
        for P = 1:2 % 1 = left, 2 = right

            S = 3; % (1 = small, 2 = medium, 3 = large)
            L = stimulus.letters{T}(D,P); % letter (1 = T, 2 = L)
            
            switch stimulus.colours{T}(D,P) % 40 us (colour)
                case 1 % target
                    C = colour.target( data(T, column.colour_target), :);                            
                case 2 % distractor
                    C = colour.target( data(T, column.colour_distractor), :);
            end
            
            C = find(C); % colour (1 = red, 2 = green)
            
            A = stimulus.rotation{T}(D,P); % rotation (1 = 0, 2 = 90, 3 = 180, 4 = 270)
            
            switch A
                case 0
                    A = 1;
                case 90
                    A = 2;
                case 180
                    A = 3;
                case 270
                    A = 4;
            end
            
            stimulus.buffer{T}(D,P) = find(     letter.sprites(:,1) == S & ...
                                                letter.sprites(:,2) == L & ...
                                                letter.sprites(:,3) == C & ...
                                                letter.sprites(:,4) == A );
        end
    end
    
    stimulus.buffer{T} = stimulus.buffer{T} + 100;
    
end



%% test_displays

if options.test_displays == true

    x = [	-0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75;
            -0.75 +0.75];

    y = [   +8.5 +8.5;
            +7.0 +7.0;
            +5.5 +5.5;
            +4.0 +4.0;
            +2.5 +2.5;
            +1.0 +1.0;
            -1.0 -1.0;
            -2.5 -2.5;
            -4.0 -4.0;
            -5.5 -5.5;
            -7.0 -7.0;
            -8.5 -8.5];

    x2 = [ -2.25 +2.25];
    y2 = [ 0 0 ];


    for T = 1:num_trials

        for D = 1:displays.number
            for P = 1:2
                cgdrawsprite( stimulus.buffer{T}(D,P), x(D,P), y(D,P)*ry, sizes.letter(S)/3, sizes.letter(S)*ry/3 )
            end
        end

        C = find( colour.target( data(T, column.colour_target), :) ); % colour (1 = red, 2 = green)

        if C == 1 % red
            cgdrawsprite( 133, x2(1), y2(1), sizes.letter(S)/3, sizes.letter(S)*ry/3 )
            cgdrawsprite( 133, x2(2), y2(2), sizes.letter(S)/3, sizes.letter(S)*ry/3 )
        elseif C == 2 % green
            cgdrawsprite( 137, x2(1), y2(1), sizes.letter(S)/3, sizes.letter(S)*ry/3 )
            cgdrawsprite( 137, x2(2), y2(2), sizes.letter(S)/3, sizes.letter(S)*ry/3 )
        end

        cgflip(colour.background)
        cgscrdmp

    end

end