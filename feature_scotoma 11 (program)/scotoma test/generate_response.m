%% generate_response.m

if rand > .5
    response = keys.absent;
    disp('response = absent')
else
    response = keys.present;
    disp('response = present')
end

data_trial(trial, column.response_present_absent) = response;

if response == keys.present && data_trial( trial, column.target_location) ~= 0 || ...
   response == keys.absent  && data_trial( trial, column.target_location) == 0
    data_trial(trial, column.accuracy_present) = 1;
else
    data_trial(trial,column.accuracy_present) = 0;
end

if data_trial(trial, column.accuracy_present) == 1
    disp('correct')
elseif data_trial(trial, column.accuracy_present) == 2
    disp('incorrect')
end

if response == keys.present
   
    if rand > .5
        response = keys.T;
        disp('response = T')
    else
        response = keys.L;
        disp('response = L')
    end
    
    data_trial(trial, column.response_identity) = response;

    if response == keys.T && data_trial( trial, column.target_identity) == 1 || ...
       response == keys.L  && data_trial( trial, column.target_identity) == 2
        data_trial(trial, column.accuracy_identity) = 1;
    else
        data_trial(trial,column.accuracy_identity) = 0;
    end


    if data_trial(trial, column.accuracy_identity) == 1
        disp('correct')
    elseif data_trial(trial, column.accuracy_identity) == 0
        disp('incorrect')
    end

end


if ~exist('P')
    
    P = 25;
    
    if rand > .25
        data_trial(trial,column.accuracy_present) = 1;
        data_trial(trial, column.accuracy_identity) = NaN;
    else
        data_trial(trial,column.accuracy_present) = 0;
        data_trial(trial,column.accuracy_present) = 0;
    end
end
    

if P <= 8
    
    if rand > .25
        data_trial(trial,column.accuracy_present) = 0;
        data_trial(trial, column.accuracy_identity) = 0;
    else
        data_trial(trial,column.accuracy_present) = 1;
        
        if rand > .25
            data_trial(trial, column.accuracy_identity) = 0;
        else
            data_trial(trial, column.accuracy_identity) = 1;
        end
        
    end
    
elseif P > 8 && P <= 16
    
    if rand > .50
        data_trial(trial,column.accuracy_present) = 0;
        data_trial(trial, column.accuracy_identity) = 0;
    else
        data_trial(trial,column.accuracy_present) = 1;
        
        if rand > .50
            data_trial(trial, column.accuracy_identity) = 0;
        else
            data_trial(trial, column.accuracy_identity) = 1;
        end
        
    end    
    
elseif P > 16 && P <= 24
    
    if rand > .75
        data_trial(trial,column.accuracy_present) = 0;
        data_trial(trial, column.accuracy_identity) = 0;
    else
        data_trial(trial,column.accuracy_present) = 1;
        
        if rand > .75
            data_trial(trial, column.accuracy_identity) = 0;
        else
            data_trial(trial, column.accuracy_identity) = 1;
        end
        
    end
    
end