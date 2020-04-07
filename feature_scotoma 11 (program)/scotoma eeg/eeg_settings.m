%% EEG TRIGGERS - config the io for eeg triggers

if options.triggers
    trig.io_obj = io32; % eeg trigger create an instance of the io32 object
    trig.status = io32(trig.io_obj); % eeg trigger initialise the inpout32.dll system driver
    trig.io_address = hex2dec('378'); % physical address of the destinatio I/O port; 378 is standard LPT1 output port address
    io32(trig.io_obj, trig.io_address, 0); % set the trigger port to 0 - i.e. no trigger
    trig.length = 2; % 2 ms long trigger
end

% ----- big data block triggers
trig.exp = 77; % start/end of experiment
trig.rest = 88; % start/end of rest
trig.trial = 99;

% ----- response triggers
trig.correct = 33;
trig.incorrect = 34;

% ----- conditions triggers
trig.one = 112; % pop, attend 1, ignore 2
trig.two = 121; % pop, attend 2, ignore 1
trig.three = 212; % con, attend 1, ignore 2
trig.four = 221; % con, attend 2, ignore 1

data(:, column.eeg) = NaN(num_trials,1);

for trial = 1:num_trials
    
    switch data(trial, column.search)
        case 1 % pop
    
            switch data(trial, column.colour_target) 
                case 1 % red
                    switch data(trial, column.freq1)
                        case 1
                            data(trial, column.eeg) = trig.one;
                        case 2
                            data(trial, column.eeg) = trig.two;
                    end
                case 2 % green
                    switch data(trial, column.freq2)
                        case 1
                            data(trial, column.eeg) = trig.one;
                        case 2
                            data(trial, column.eeg) = trig.two;
                    end
            end
            
            
        case 2 % con
            
            switch data(trial, column.colour_target) 
                case 1 % red
                    switch data(trial, column.freq1)
                        case 1
                            data(trial, column.eeg) = trig.three;
                        case 2
                            data(trial, column.eeg) = trig.four;
                    end
                case 2 % green
                    switch data(trial, column.freq2)
                        case 1
                            data(trial, column.eeg) = trig.three;
                        case 2
                            data(trial, column.eeg) = trig.four;
                    end
            end
            
            
    end
        
        
    
end