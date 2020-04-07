%% scotoma_eeg.m

track = '13 Danses des cygnes.wav';
pause_rest = 30000; % ms

%% response keys (to find ID numbers for each key, type getkeymap into the main MATLAB window)
keys.zero = 97; % left arrow
keys.one = 100; % down arrow
keys.two = 98; % right arrow
keys.escape = 52; % escape

keys.pause_on = 53; % minus
keys.pause_off = 54; % equals 


%% timing

% convert Hz values into frames
%frequency.desired = [5 20];
frequency.desired = [25/3 100/9]; % [5 20]; %  % desired frequencies (Hz) 1.2500    8.3333   11.1111
frequency.frames = round ( (1000./frequency.desired) / (1000/mon.rate) ); 

displays.initial = 1; % without search array
displays.number = 12; % number of search displays

displays.duration = (800)*options.speed; % 666.66 ms
displays.frames.each = round ( displays.duration / (1000/mon.rate) ); % frames
displays.frames.total = displays.frames.each*(displays.initial + displays.number);

duration.instruct = 1000*options.speed;
duration.feedback = 1000*options.speed;

displays.frames.instruct = round ( duration.instruct / (1000/mon.rate) ); % ms
displays.frames.feedback = round ( duration.feedback / (1000/mon.rate) ); % ms


%% data column numbers

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


%% search arrays

% ----- target settings

% pop out
letter.info{1} = [  001 001 001 001 001 002 002 002 002; % letter (1 = T, 2 = L)
                    001 002 002 002 002 002 002 002 002; % colour (1 = target, 2 = distractor)
                    000 000 090 180 270 000 090 180 270]; % rotation (1 = 0, 2 = 90, 3 = 180, 4 = 270)

% conjunction
letter.info{2} = [  001 001 001 001 001 001 001 001 002 002 002 002 002 002 002 002; % letter (1 = T, 2 = L)
                    001 001 001 001 002 002 002 002 001 001 001 001 002 002 002 002; % colour (1 = target, 2 = distractor)
                    000 090 180 270 000 090 180 270 000 090 180 270 000 090 180 270]; % rotation (1 = 0, 2 = 90, 3 = 180, 4 = 270)


% 1 = target, 2 = distractor; first position = left item; second position = right item, 12 pairs = 12 search arrays                

% pop out
letter.colours{1} = [2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2];

% conjunction
letter.colours{2} = [1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 2 1; 2 1; 2 1; 2 1; 2 1; 2 1];


%% build_block

build_block3; % get block
change_matrix_gen; % generate change matrix (with timings)
eeg_settings; % get EEG settings


%% begin experiment/trial routine

toc_loop = NaN(displays.frames.total, num_trials);

if options.triggers
eeg_trigger(trig.io_obj, trig.io_address, trig.exp, trig.length); % ----- EEG trigger experiment
end

for trial = 1:num_trials % numtrials
    
    %% initialise trial ( 6 ms  )
    
    present_row = find(trial_order(:,1) == trial); % find trial information
        
    trial_rate = data(present_row, [column.freq1, column.freq2] );
    rate = find(ismember(change.rate, trial_rate, 'rows'));
    
    disp( [ 'current trial = ' num2str(trial) ] ); % print current trial number to command window
    disp( [ 'trials remaining = ' num2str(num_trials-trial) ] ); % prints number of trials remaining to command window
    %disp( [ 'trigger no.: ' num2str( data(present_row, column.eeg) ) ] );
    
    % pre-trial displays
    C = find( colour.target( data(present_row, column.colour_target), :) ); % colour (1 = red, 2 = green)


    %% rest ( .005 ms to evaluate )
    
    if options.rest
    
    if ( (trial-1)/num_trials_block == round( (trial-1)/num_trials_block ) ) && options.speed == 1

        if C == 1 % red
            cgdrawsprite( 133, -R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
            cgdrawsprite( 133, +R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
        elseif C == 2 % green
            cgdrawsprite( 137, -R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
            cgdrawsprite( 137, +R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
        end
        
        cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
        cgflip(colour.background)
        
        cgsound('WavFilSND', 333, track)
        cgsound('play', 333)
        
        if options.practice == true
            wait( pause_rest/6 )
        else
            wait( pause_rest );
        end
        
        cgsound('stop', 333)
        waitkeydown(inf)
         
        % ----- EEG trigger rest
        if options.triggers
        eeg_trigger(trig.io_obj, trig.io_address, trig.rest, trig.length); % #################### EEG
        end
    end
    
    end
    
    % ----- cue (610 ms)
    for kk = 1:displays.frames.instruct 
   
        if C == 1 % red
            cgdrawsprite( 133, -R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
            cgdrawsprite( 133, +R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
        elseif C == 2 % green
            cgdrawsprite( 137, -R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
            cgdrawsprite( 137, +R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
        end
        
        cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
        cgflip(colour.background);
        
        if kk == 1 && options.triggers
            eeg_trigger(trig.io_obj, trig.io_address, trig.trial, trig.length); % #################### EEG
        end
    end
    
    % ----- fixation dot (610 ms)
    for kk = 1:displays.frames.instruct
        cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
        cgflip(colour.background);
    end


    %% main animation loop ( 3 ms maximum )
   
    for kk = 1:displays.frames.total

        TIC.loop = tic;
        
        % .2 ms (to  update displays - ready checkerboards and search arrays
        D = change.matrix{ data( present_row, column.peri_stim ), rate }(kk,2); % display
        
        
        change.buffer = change.matrix{ data( present_row, column.peri_stim ), rate }(kk,3); % checkerboard buffer
        
        cgdrawsprite( change.buffer, 0, 0, sizes.checkerboards, sizes.checkerboards*( mon.res(2)/mon.res(1) )*ry ) % draw checkerboards

        cgellipse( 0, 0, sizes.occ_cen, sizes.occ_cen*ry, colour.background, 'f') % central occluder
        cgellipse( -R(3), 0, sizes.occ_let, sizes.occ_let*ry, colour.background, 'f') % left occluder
        cgellipse( +R(3), 0, sizes.occ_let, sizes.occ_let*ry, colour.background, 'f') % right occluder

        cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
        
        
        
        if D ~= 0 % draw letters
            cgdrawsprite( stimulus.buffer{present_row}(D,1), -R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
            cgdrawsprite( stimulus.buffer{present_row}(D,2), +R(3), 0, sizes.letter(S), sizes.letter(S)*ry )
        end
        
        % .01 ms (to evaluate next three if statements)
        if options.display_info == true
            cgfont(font.name, font.height)
            cgpencol( colour.txt )
            cgtext( ['trial no.: ' num2str( trial ) ], 0, 10);
            cgtext( ['trigger no.: ' num2str( data(present_row, column.eeg) ) ], 0, 8);
            cgtext( ['search: ' num2str( data(present_row, column.search) ) ], 0, 6);
            cgtext( ['target col.: ' num2str( data(present_row, column.colour_target) ) ], 0, 4);
            cgtext( ['distractor col.: ' num2str( data(present_row, column.colour_distractor) ) ], 0, 2);
            cgtext( ['Hz 1: ' num2str( data(present_row, column.freq1) ) ], 0, 0);
            cgtext( ['Hz 2: ' num2str( data(present_row, column.freq2) ) ], 0, -2);
            cgtext( ['no. targets: ' num2str( data(present_row, column.targets) ) ], 0, -4);
            cgtext( ['peri. stim.: ' num2str( data(present_row, column.peri_stim) ) ], 0, -6);
            cgtext( ['frame no.: ' num2str( kk ) ], 0, -8);
        end
        

        % ----- EEG trigger ( 2 ms to run when sending the trigger )

        if kk == trig.frame_first || kk == trig.frame_last
            if options.triggers
                eeg_trigger(trig.io_obj, trig.io_address, data(present_row,column.eeg), trig.length); % #################### EEG   
            end
        end
        
        TOC.loop(kk,present_row) = toc(TIC.loop); % computations should be < 1e-002 s; to be safe, should be less than 6e-003 s
        
        cgflip(colour.background)
        
        if      options.pause == true && ...
                D > 0 && ...
                kk == find( change.matrix{ data( present_row, column.peri_stim ), rate }(:,2) == D, 1, 'first')
    
                response = waitkeydown(inf, [keys.pause_on, keys.pause_off] );
                
                if response == keys.pause_off
                    options.pause = false;
                end
        end

        if options.test_frames == true
            disp(kk)
        	waitkeydown(inf)
        end

    end

    if options.speed == 1 && options.wait_response == true


        %% response screen

        cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
        cgdrawsprite( txt.buffer(3), -R(3), 0, length( txt.word{3} )*txt.width*txt.spacing_factor, txt.height*ry ) % '012'
        cgdrawsprite( txt.buffer(3), +R(3), 0, length( txt.word{3} )*txt.width*txt.spacing_factor, txt.height*ry ) % '012'
        cgflip(colour.background);

        response = waitkeydown(inf, [keys.zero, keys.one, keys.two, keys.escape, keys.pause_on]);

        if length(response) > 1
            response = response(1);
        end

        data(present_row,column.response) = response;
        
        if response == keys.pause_on
        
            options.pause = true; % turn pause back on
            
        else
            
            if response == keys.zero && data(present_row, column.targets) == 0 || ...
               response == keys.one  && data(present_row, column.targets) == 1 || ...     
               response == keys.two  && data(present_row, column.targets) == 2 

                    data(present_row, column.accuracy) = 1;
                    txt.feedback = txt.buffer(4);
                    trig.response = trig.correct;
                    disp('correct')
            else
                    data(present_row,column.accuracy) = 0;
                    txt.feedback = txt.buffer(5);
                    trig.response = trig.incorrect;
                    disp('incorrect')
            end

            % ----- EEG trigger response; correct or incorrect?
            if ~exist('trig.response','var')
                trig.response = trig.incorrect;
            end

            if response == keys.escape
                break
            end


            %% feedback screen (610 ms)

            for kk = 1:displays.frames.feedback

                cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
                cgdrawsprite( txt.feedback, -R(3), 0, length( txt.word{ txt.feedback - 300 } )*txt.width*txt.spacing_factor, txt.height*ry ) % '012'
                cgdrawsprite( txt.feedback, +R(3), 0, length( txt.word{ txt.feedback - 300 } )*txt.width*txt.spacing_factor, txt.height*ry ) % '012'

                cgflip(colour.background);

                if kk == 1 && options.triggers
                    eeg_trigger(trig.io_obj, trig.io_address, trig.response, trig.length); % #################### EEG
                end

            end
            
        end
        
    end
end


%% display accuracy results

disp('Unique Feature Search - Accuracy (%)')
disp( mean( data( data(:,column.search) == 1, column.accuracy ) )*100 )
disp('Conjunction Search - Accuracy (%)')
disp( mean( data( data(:,column.search) == 2, column.accuracy ) )*100 )

%% shut down/save

cd( direct.exp );
save_run;
