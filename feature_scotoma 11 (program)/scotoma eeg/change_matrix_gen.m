%% change_matrix_gen.m

change.buffer_initial = [1,5]; % cb initial state numbers

% 1-4 (red inside, green outside) 1
% 5-8 (green inside, red outside) 2

% 1: r1 g1
% 2: r1 g2
% 3: r2 g1
% 4: r2 g2

                % kk rg r g
% change.array = [    1,4,3,2;
%                     2,3,4,1;
%                     3,2,1,4;
%                     4,1,2,3;
%                     ...
%                     5,8,7,6;
%                     6,7,8,5;
%                     7,6,5,8;
%                     8,5,6,7];


change.array = [1 3 2 4;
                2 4 1 3;
                3 1 4 2;
                4 2 3 1;
                5 7 6 8;
                6 8 5 7;
                7 5 8 6;
                8 6 7 5];

change.rate = unique( data(:, [column.freq1,column.freq2] ),'rows'); % flicker rates

for initial_state = 1:length( unique( data(:, column.peri_stim) ) ); % initial states for checkerboards (3 = green left inner - 9-12; 4 = red left inner - 13-16)
    
    change.buffer = change.buffer_initial( initial_state ); % checkerboard initial state

    for rate = 1:length(change.rate)
        
        frequency.count = [ frequency.frames( change.rate(rate,1) ), frequency.frames( change.rate(rate,2) ) ];
        
        frequency.nextCBflick = frequency.count + 1; % first frame to flick checkerboard
        
        frequency.display_nextflick = displays.frames.each*(displays.initial) + 1; % first frame to flick central display
        frequency.display_count = 0;

        % change_matrix(:,1) = kk
        % change_matrix(:,2) = display number
        % change_matrix(:,3) = checkerboard

        change.matrix{initial_state,rate}(:,1) = (1:displays.frames.total)';

        for kk = 1:displays.frames.total

            if frequency.display_nextflick == kk % time to change the display?
                frequency.display_count = frequency.display_count + 1;
                frequency.display_nextflick = frequency.display_nextflick + displays.frames.each;
            end

            change.matrix{initial_state,rate}(kk,2) = frequency.display_count;

            
            if kk == frequency.nextCBflick(1) && kk == frequency.nextCBflick(2) % time to change checkerboards?

                frequency.nextCBflick(1) = frequency.nextCBflick(1) + frequency.count(1);
                frequency.nextCBflick(2) = frequency.nextCBflick(2) + frequency.count(2);

                change.idx = 2;
                
            elseif kk == frequency.nextCBflick(1)
                
                frequency.nextCBflick(1) = frequency.nextCBflick(1) + frequency.count(1);

                change.idx = 3;
                
            elseif kk == frequency.nextCBflick(2)
                        
                frequency.nextCBflick(2) = frequency.nextCBflick(2) + frequency.count(2);
                
                change.idx = 4;    
            
            else
                change.idx = 1;
            end
                
            change.buffer = change.array(change.buffer, change.idx);
            change.matrix{initial_state, rate}(kk,3) = change.buffer;

        end 
    end
end

trig.frame_first = find(change.matrix{1,1}(:,2) == 3, 1, 'first');
trig.frame_last = find(change.matrix{1,1}(:,2) == 12, 1, 'last');