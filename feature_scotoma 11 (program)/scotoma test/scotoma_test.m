%% scotoma_test.m


%% response keys (to find ID numbers for each key, type getkeymap into the main MATLAB window)
keys.absent = 1;
keys.present = 16;
keys.T = 20;
keys.L = 12;
keys.N = 14;

keys.escape = 52;



%% timing information
duration.pretrial = 1000*options.speed; % ms
duration.show = 200*options.speed;  % ms
duration.hide = 1000*options.speed;  % ms
duration.posttrial = 1000*options.speed;  % ms


%% data_trial column numbers
column.trial_number_present = 1;
column.trial_number = 2;
column.target_location = 3;
column.target_ring = 4;
column.target_angle = 5;
column.target_colour = 6;
column.target_identity = 7;
column.response_present_absent = 8;
column.response_identity = 9;
column.accuracy_present = 10;
column.accuracy_identity = 11;


%% get block

if options.practice == true
    data_trial1 = importdata('practice_scotoma.txt');
    data_trial = data_trial1.data();

    locs = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 0 0 0 0 0 0];
    locs = locs( randperm( length( locs ) ) );
    locs = locs( 1:12 )';
    
    data_trial( :, column.target_location ) = locs;
    
    idx = data_trial( :, column.target_location ) == 0;
    
    data_trial( idx, [column.target_ring column.target_angle column.target_colour column.target_identity ] ) = zeros( sum(idx), 4 );
    
else
	data_trial1 = importdata('test_scotoma.txt');
    data_trial = data_trial1.data();
end

[num_trials, not_used] = size(data_trial);

if options.random == true
    data_trial(:,column.trial_number_present) = randperm(num_trials)';
end


%% trial routine


for TRIAL = 1:num_trials % numtrials

    %% initialise trial ( 6 ms  )
    trial = find(data_trial(:,column.trial_number_present) == TRIAL);

    disp( '****************' )
    disp( [ 'current trial = ' num2str(TRIAL) ] ); % print current trial number to command window
    disp( [ 'trials remaining = ' num2str(num_trials-TRIAL) ] ); % prints number of trials remaining to command window

    cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
    cgflip(colour.background)
    wait(duration.pretrial)
    
    if data_trial( trial, column.target_location) ~= 0
    
        P = data_trial( trial, column.target_location); % position (1-24)
        
        if P <= 8 % size of stimulus
            S = 1;
        elseif P > 8 && P <= 16
            S = 2;
        elseif P > 16
            S = 3;
        end
        
        L = data_trial( trial, column.target_identity); % 1 = T, 2 = L
        C = data_trial( trial, column.target_colour); % colour (1 = red, 2 = green)
        A = 1; % upright letter
        
        buffer = find(  letter.sprites(:,1) == S & ...
                        letter.sprites(:,2) == L & ...
                        letter.sprites(:,3) == C & ...
                        letter.sprites(:,4) == A );

        cgdrawsprite( buffer + 100, pos.test(P,1), pos.test(P,2), sizes.letter(S), sizes.letter(S)*ry )
        
    end
    
    cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
    cgflip(colour.background);
    cgscrdmp
    
    cgsound('play', 333);
    wait(duration.show); % show target
    
    cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
    cgflip(colour.background);
    wait(duration.hide); % hide target
    
    if options.display_info == true

        disp( ['trial no.: ' num2str( TRIAL ) ] )
        disp( ['trial no. P: ' num2str( trial ) ] );
        disp( ['target location: ' num2str( data_trial(trial, column.target_location) ) ] );
        disp( ['target ring: ' num2str( data_trial(trial, column.target_ring) ) ] );
        disp( ['target angle: ' num2str( data_trial(trial, column.target_angle) ) ] );
        disp( ['target colour: ' num2str( data_trial(trial, column.target_colour) ) ] );
        disp( ['target identity: ' num2str( data_trial(trial, column.target_identity) ) ] );
       
    end

    
    if options.wait_response == true

        
        %% response screen
        
        disp('absent (a) or present (p)')
        
        cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
                
        if options.hide_response_screen == false
            cgdrawsprite( txt.buffer(1), -R(3), 0, length( txt.word{1} )*txt.width*txt.spacing_factor, txt.height*ry ) % 'P or A?'
            cgdrawsprite( txt.buffer(1), +R(3), 0, length( txt.word{1} )*txt.width*txt.spacing_factor, txt.height*ry ) % 'P or A?'
        end
        
        cgflip(colour.background)
        %cgscrdmp

        response = waitkeydown(inf, [keys.absent, keys.present, keys.escape]);

        if length(response) > 1
            response = response(1);
        end

        data_trial(trial, column.response_present_absent) = response;
        
        if response == keys.present && data_trial( trial, column.target_location) ~= 0 || ...
           response == keys.absent  && data_trial( trial, column.target_location) == 0
            data_trial(trial, column.accuracy_present) = 1;
        else
            data_trial(trial,column.accuracy_present) = 0;
        end
        
        if response == keys.present
            disp('response = present')
        elseif response == keys.present
            disp('response = absent')
        end
        
        if data_trial(trial, column.accuracy_present) == 1
            disp('correct')
        elseif data_trial(trial, column.accuracy_present) == 2
            disp('incorrect')
        end
        
        if response == keys.present
            
            cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation

            disp('t (t) or l (l)')
            
            if options.hide_response_screen == false
                cgdrawsprite( txt.buffer(2), -R(3), 0, length( txt.word{2} )*txt.width*txt.spacing_factor, txt.height*ry ) % 'T or L?'
                cgdrawsprite( txt.buffer(2), +R(3), 0, length( txt.word{2} )*txt.width*txt.spacing_factor, txt.height*ry ) % 'T or L?'
            end
            
            cgflip(colour.background)
            %cgscrdmp
        
            response = waitkeydown(inf, [keys.T, keys.L, keys.N, keys.escape]);

            if length(response) > 1
                response = response(1);
            end

            data_trial(trial, column.response_identity) = response;

            if response == keys.T && data_trial( trial, column.target_identity) == 1 || ...
               response == keys.L  && data_trial( trial, column.target_identity) == 2
                data_trial(trial, column.accuracy_identity) = 1;
            else
                data_trial(trial,column.accuracy_identity) = 0;
            end
            
            if response == keys.T
                disp('response = T')
            elseif response == keys.L
                disp('response = L')
            end

            if data_trial(trial, column.accuracy_identity) == 1
                disp('correct')
            elseif data_trial(trial, column.accuracy_identity) == 0
                disp('incorrect')
            end
            
        end

        if response == keys.escape
            break
        end
    else
        generate_response
    end
    
    cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
	cgflip(colour.background);
    wait(duration.posttrial); % hide target
    
    
    idx = data_trial( :, column.response_present_absent ) ~= 0;
    
    disp( [ 'Detection Accuracy (Overall): ' num2str( round( mean( data_trial( idx, column.accuracy_present ) )*100 ) ) '%' ] );
    
    idx = data_trial( :, column.response_identity ) ~= 0;
    
    disp( [ 'Identification Accuracy (Overall): ' num2str( round( mean( data_trial( idx, column.accuracy_identity ) )*100 ) ) '%' ] );
    

end


%% display results

if options.practice == false

    %     column.trial_number_present = 1;
    %     column.trial_number = 2;
    %     column.target_location = 3;
    %     column.target_ring = 4;
    %     column.target_angle = 5;
    %     column.target_colour = 6;
    %     column.target_identity = 7;
    %     column.response_present_absent = 8;
    %     column.response_identity = 9;
    %     column.accuracy_present = 10;
    %     column.accuracy_identity = 11;

    results = NaN(25,3);

    map = colormap('gray');

    sizes.detection = 1;
    sizes.identity = 2;
    colour.blue = [0 0 1];

    for P = 1:25 % position

        if P == 25
            idx = data_trial(:,column.target_location) == 0;
            results(P,1) = sum( idx );
            results(P,2) = sum( data_trial(idx,column.accuracy_present) )/results(P,1);
            results(P,3) = NaN;
        else    
            idx = data_trial(:,column.target_location) == P;
            results(P,1) = sum( idx );
            results(P,2) = sum( data_trial(idx,column.accuracy_present) )/results(P,1);
            results(P,3) = sum( data_trial(idx,column.accuracy_identity) )/sum( data_trial(idx,column.accuracy_present) );

            if isnan( results(P,3) )
                results(P,3) = 0;
            end
        end

        if round(results(P,2)*64) == 0
           colour.detection = [0 0 0];
        else
           colour.detection = map(round(results(P,2)*64),:);
        end

        if P < 25

            if round(results(P,3)*64) == 0
               colour.identity = [0 0 0];
            else
               colour.identity = map(round(results(P,3)*64),:);
            end

        end

        if P == 25
            cgpencol( colour.fix )
            cgellipse( 0, 0, sizes.detection, sizes.detection*ry, colour.detection, 'f')
            cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
        else


            cgellipse( pos.test(P,1), pos.test(P,2), sizes.identity, sizes.identity*ry, colour.identity, 'f')
            cgellipse( pos.test(P,1), pos.test(P,2), sizes.detection, sizes.detection*ry, colour.detection, 'f')

            cgpencol( colour.fix )
            cgpolygon( pos.fix(:,1), pos.fix(:,2), pos.test(P,1), pos.test(P,2)  ) % fixation



        end

    end

    cgflip( colour.background )

    temp = clock;
    fname = [ subject ' ' date ' ' num2str( temp(4) ) '-' num2str( temp(5) ) '-' num2str( round( temp(6) ) ) ];
    
    cd( direct.log );
    cgscrdmp( fname )
    
    
    %% save
    cd( direct.exp );
    save_run;

    waitkeydown( inf )

end
    

%% shut down
cgshut;
cgsound('shut');
cogstd('spriority','normal')





