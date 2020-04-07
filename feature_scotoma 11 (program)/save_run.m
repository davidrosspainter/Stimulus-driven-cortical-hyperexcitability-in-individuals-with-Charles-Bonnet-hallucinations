%% save_run.m

if options.test ~= 1
    cgshut;
    cgsound('shut');
    cogstd('spriority','normal')
end

temp = clock;
fname = [ subject ' ' date ' ' num2str( temp(4) ) '-' num2str( temp(5) ) '-' num2str( round( temp(6) ) ) '.mat' ];

cd( direct.log );
save( fname );

cd( direct.exp );

time_stop = clock;