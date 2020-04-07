%% ----- run_scotoma.m

warning('restoring default path')
input('press enter to start')
clear; clc; close all; clear all; clear mex; restoredefaultpath

addpath 'E:\matlabToolboxes\Cogent2000v1.33\Toolbox'; cgshut

rand('twister', sum( 100*clock() ) ); %% needed for randomisation!
time_start = clock;


%% readme

% options.test = 2 - attention task; left arrow, down arrow right arrow -
% 0, 1 or 2 targets


%%

options.test = 1 % 1 = scotoma test, 2 = eeg, 3 = preview stimuli ******

options.triggers = false;
options.rest = false;


%% options for scotoma test and eeg

subject = ''; % e.g.
options.practice = false; % require button press to advance to next trial
options.pause = false; % pause the flicker on each new letter display



%% test settings
options.preview_stimuli = false; % set to true false or preview before experiment

if options.test == 3
    options.preview_stimuli = true;
end

options.random = true; % if ylou want the trial presentation to be random
options.speed = 1; % set to less than one if you want a quick view of the ex
options.wait_response = true; % require button press to advance to next trial
options.display_info = false; % print trial information to the screen/command window


%% options for scotoma_test
options.hide_response_screen = true; % set to true to hide AP/TL


%% options for eeg

options.all_conjunction = false; % set to true for only conjunction trials

options.test_frames = false; % require button press after each frame
options.print_frames = false; % save frames to bmp
options.test_displays = false; % saves display sequences before running the experiment

if options.test_frames == true
    options.display_info = true;
end


%% monitor

mon.num = 0; % Windows display settings **************************************************
mon.rate = 143; % Hz

% ---- resolution
mon.res_cg = 2; % integer
mon.res_list = [    640 480; % 1
                    800 600; % 2
                    1024 768 % 3
                    1152 864; % 4
                    1280 1024; % 5
                    1600 1200]; % 6

mon.res = mon.res_list( mon.res_cg,:);


% ---- model
options.mon = 2; % integer *********
options.mon_list = { 'Dell P793', 'Accusync 120', 'Dell 2407WFPB', 'BENQ ET-0025-N', 'acer' };

switch options.mon_list{ options.mon }
    case 'Accusync 120'
        xD = 37.2; % cm/degrees
        yD = 28.5; % cm/degrees
    case 'Dell P793'
        xD = 31.2; % cm/degrees
        yD = 23.4; % cm/degrees
	case 'Dell 2407WFPB'
        xD = 50.4; % cm/degrees
        yD = 32.2; % cm/degrees
    case 'BENQ ET-0025-N'
        xD = 40.8;
        yD = 22.9;
    case 'acer'
        xD = 33.0;
        yD = 20.6;
end

xS = mon.res(1)/xD; % pixels/degree
yS = mon.res(2)/yD; % pixels/degree

ry = yS/xS; % pixel height:width ratio


%% directories
direct.exp = cd; % experiment directory (current directory)

direct.checkerboards = [ direct.exp '\scotoma eeg\checkerboards\' ];

switch options.test
    case 1 % scotoma test
        direct.test = [ direct.exp '\scotoma test\' ];
        direct.log = [ direct.exp '\scotoma test\logfiles\' ];
        direct.screen = [ direct.exp '\scotoma test\screenshots\' ];
    case 2 % eeg
        direct.test = [ direct.exp '\scotoma eeg\' ];
        direct.log = [ direct.exp '\scotoma eeg\logfiles\' ];
        direct.screen = [ direct.exp '\scotoma eeg\screenshots\' ];
    case 3 % preview
        direct.screen = [ direct.exp '\screenshots\' ];
end


%% cortical magnification factor
CMF(1) = 4.16 + ( (3.08 - 4.16)/2 )*(4-3); % 4 degrees 
CMF(2) = 2.10 + ( (1.75 - 2.10)/3 )*(8-7); % 8 degrees
CMF(3) = 1.75 + ( (1.16 - 1.75)/5 )*(12-10); % 12 degrees


%% sizes
sizes.biggest = 3.7; % sizes of biggest letter

sizes.letter(1) = sizes.biggest*( CMF(3)/CMF(1) ); % at 4 degrees
sizes.letter(2) = sizes.biggest*( CMF(3)/CMF(2) ); % at 8 degrees
sizes.letter(3) = sizes.biggest; % at 12 degrees

sizes.checkerboards = 37.2; % degrees
sizes.pen = .1; % degrees
sizes.occ_cen = 16; % degrees
sizes.occ_let = 9; % degrees
sizes.fix = .2; % degrees


%% positions

% ----- scotoma test positions
R = [4 8 12]; % rings (distance in degrees)

pos.test = [ ... % inner
        +R(1)           0; % R 1
        +R(1)/sqrt(2)   +R(1)/sqrt(2); % RU 2
        0               +R(1); % U 3
        -R(1)/sqrt(2)   +R(1)/sqrt(2); % LU 4
        -R(1)           0; % L 5
        -R(1)/sqrt(2)   -R(1)/sqrt(2); % LD 6
        0               -R(1); % D 7
        +R(1)/sqrt(2)   -R(1)/sqrt(2); % RD 8
        ... % middle
        +R(2)           0; % R 9
        +R(2)/sqrt(2)   +R(2)/sqrt(2); % RU 10
        0               +R(2); % U 11
        -R(2)/sqrt(2)   +R(2)/sqrt(2); % LU 12
        -R(2)           0; % L 13
        -R(2)/sqrt(2)   -R(2)/sqrt(2); % LD 14
        0               -R(2); % D 15
        +R(2)/sqrt(2)   -R(2)/sqrt(2); % RD 16
        ... % outer
        +R(3)           0; % R 17
        +R(3)/sqrt(2)   +R(3)/sqrt(2); % RU 18
        0               +R(3); % U 19
        -R(3)/sqrt(2)   +R(3)/sqrt(2); % LU 20
        -R(3)           0; % L 21
        -R(3)/sqrt(2)   -R(3)/sqrt(2); % LD 22
        0               -R(3); % D 23
        +R(3)/sqrt(2)   -R(3)/sqrt(2)]; % RD 24


%%
pos.test(:,2) = pos.test(:,2)*ry; % scale y


%% letters

for L = 1:3 % three sizes

    p = sizes.letter(L)/3;

    pos.L{1,L} = [ ...
            -3/2*p -3/2*p
            -3/2*p +3/2*p
            -1/2*p +3/2*p
            -1/2*p -1/2*p
            +3/2*p -1/2*p
            +3/2*p -3/2*p];

    pos.T{1,L} = [ ...
            -1/2*p -3/2*p
            -1/2*p +1/2*p
            -3/2*p +1/2*p
            -3/2*p +3/2*p
            +3/2*p +3/2*p
            +3/2*p +1/2*p
            +1/2*p +1/2*p
            +1/2*p -3/2*p];

    anglesL = [0 2*pi pi/2 pi];
    anglesT = [0 pi/2 pi 3/2*pi];

    for A = 2:length(anglesL)

        rotL = [	-cos( anglesL(A) ) -sin( anglesL(A) );
                    -sin( anglesL(A) ) +cos( anglesL(A) )];

        rotT = [	-cos( anglesT(A) ) -sin( anglesT(A) );
                    -sin( anglesT(A) ) +cos( anglesT(A) )];

        pos.L{A,L} = pos.L{1,L}*rotL;
        pos.T{A,L} = pos.T{1,L}*rotT;
        
        pos.L{A,L}(:,2) = pos.L{A,L}(:,2)*ry; 
        pos.T{A,L}(:,2) = pos.T{A,L}(:,2)*ry;

    end
end

for L = 1:3
	pos.L{1,L}(:,2) = pos.L{1,L}(:,2)*ry; 
    pos.T{1,L}(:,2) = pos.T{1,L}(:,2)*ry;
end
 

%% fixation box
pos.fix = [ -1/2*sizes.fix -1/2*sizes.fix; % degrees
            -1/2*sizes.fix +1/2*sizes.fix; % degrees
            +1/2*sizes.fix +1/2*sizes.fix; % degrees
            +1/2*sizes.fix -1/2*sizes.fix]; % degrees

pos.fix(:,2) = pos.fix(:,2)*ry;


%% colours

colour.sprite = [0 0 0];

colour.background = [0 0 0];
colour.fix = [1 1 1];

colour.red = [255/255 0 0];
colour.green = [0 119/255 0];
colour.target(1,:) = colour.red; % colour.red
colour.target(2,:) = colour.green; % colour.green


%% font settings (scotoma test responses and scotoma eeg feedback)

% font for display info
font.name = 'Arial';
font.height = 2;

colour.txt = [1 1 1];

% dimensions of digits
h_hor = 0.3; % height of horizontal segments
w_hor = 1.0; % width of horizontal segments
h_ver = 1.0; % width of vertical segments
w_ver = 0.3; % height of horizontal segments

txt.width = 2*w_hor + w_ver;
txt.height = 2*h_ver + w_ver;

txt.spacing_factor = 1.1; % spacing between letters

% text to display
txt.off{1} = [ -0.5 +0.5 ];
txt.off{2} = [ -0.5 +0.5 ];
txt.off{3} = [ -1.0 0 +1.0 ];
txt.off{4} = 0;
txt.off{5} = 0;
txt.off{6} = [ -1.5 -0.5 +0.5 +1.5 ];

for T = 1:length( txt.off )
   txt.off{T} = txt.off{T}*txt.width*txt.spacing_factor;
end

txt.word{1} = 'ap';
txt.word{2} = 'tl';
txt.word{3} = '012';
txt.word{4} = 'y';
txt.word{5} = 'n';
txt.word{6} = 'rest';

txt.buffer(1) = 301;
txt.buffer(2) = 302;
txt.buffer(3) = 303;
txt.buffer(4) = 304;
txt.buffer(5) = 305;
txt.buffer(6) = 306;


%% start cogent

cgloadlib;
cogstd('spriority','high')

config_keyboard

cgopen(mon.res_cg, 0, mon.rate, mon.num)
cgpenwid( sizes.pen )
start_cogent_dp

cgscale(xD)


% cgscale(32) Sets visual angle co-ordinates with the screen width set to
% 32 degrees. cgscale(400,600) Sets visual angle co-ordinates with screen width 
% 400mm and observer distance 600mm.

% ----- check refresh rate
cogent = cggetdata('GPD');

% if round( data.cogent.RefRate100/100 ) ~= monitor.rate || ...
%    data.cogent.PixWidth ~= monitor.res(1) || ...
%    data.cogent.PixHeight ~= monitor.res(2)
% 	
%    error('Screen refresh rate or monitor.res set incorrectly.');
% end

%cgscrdmp('./screenshots/shot',1)
cgsound('open')

if options.test == 1
    
    cd( direct.test );
    
    % make tone
    tone.rate = 48000;
    tone.duration = .2;
    tone.frequency = 2000;

%    tone.wave = sinwav(tone.frequency, tone.duration, tone.rate);
%    cgsound('matrixSND', 333, tone.wave, tone.rate)

    tone.noise = wgn(1, 9600, 1);
    cgsound('matrixSND', 333, tone.noise, tone.rate)
    
    cd( direct.exp );
end


%% draw occluders

cgflip( colour.red )

if options.preview_stimuli == true
    
    cgflip( colour.red )
    
    cgellipse( 0, 0, sizes.occ_cen, sizes.occ_cen*ry, colour.background, 'f') % central occluder
    cgellipse( -R(3), 0, sizes.occ_let, sizes.occ_let*ry, colour.background, 'f') % left occluder
    cgellipse( +R(3), 0, sizes.occ_let, sizes.occ_let*ry, colour.background, 'f') % right occluder

    cgpencol( colour.fix )
    cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
    cgpolygon( pos.fix(:,1), pos.fix(:,2), -R(3), 0 ) % fixation (left)
    cgpolygon( pos.fix(:,1), pos.fix(:,2), +R(3), 0 ) % fixation (right)
    
    cgflip( colour.red )
    waitkeydown( inf )
    %cgscrdmp

end


%% draw letters

cgflip( colour.background )

if options.test == 1 % scotoma test
    sprites = [1 5 9 13 17 21 25 29 33 37 41 45]; % sprites to use
elseif options.test == 2 % eeg
    sprites = 33:48; % sprites to use
elseif options.test == 3 % previe
    sprites = 1:48;
end

letter.sprites = NaN(48,4);
% letter.sprites(:,1) = size (1 = small, 2 = medium, 3 = large)
% letter.sprites(:,2) = letter (1 = T, 2 = L)
% letter.sprites(:,3) = colour (1 = red, 2 = green)
% letter.sprites(:,4) = angle (1 = 0, 2 = 90, 3 = 180, 4 = 270)

buffer = 100;

for S = 1:3 % three sizes
    for L = 1:2 % two letters
        for C = 1:2 % two colours
            for A = 1:4 % four rotations

                buffer = buffer + 1;
                
                if any( ismember( sprites + 100, buffer ) ) % draw the letters needed
                
                    letter.sprites( buffer - 100, 1) = S;
                    letter.sprites( buffer - 100, 2) = L;
                    letter.sprites( buffer - 100, 3) = C;
                    letter.sprites( buffer - 100, 4) = A;

                    cgmakesprite( buffer, sizes.letter(S), sizes.letter(S)*ry, colour.sprite )
                    cgsetsprite(buffer)
                    cgtrncol(buffer, 'n') % set background to transparent

                    if C == 1
                        cgpencol( colour.red );
                    else
                        cgpencol( colour.green );
                    end

                    if L == 1
                        cgpolygon( pos.T{A,S}(:,1), pos.T{A,S}(:,2) );
                    else
                        cgpolygon( pos.L{A,S}(:,1), pos.L{A,S}(:,2) );
                    end

                    cgsetsprite(0)

                    if options.preview_stimuli == true
                        cgdrawsprite( buffer, 0, 0, sizes.letter(S), sizes.letter(S)*ry )
                        cgflip( colour.background )
                        waitkeydown( inf )
                        disp( [ 'buffer = ' num2str(buffer) ] )
                        %cgscrdmp
                    end
                    
                end
                
            end
        end
    end 
end
  

%% draw positions    

if options.preview_stimuli == true

    for P = 1:length(pos.test)

        cgpencol(colour.fix);
        cgpolygon( pos.fix(:,1), pos.fix(:,2), pos.test(P,1), pos.test(P,2)  ) % fixation

    end

    cgpolygon( pos.fix(:,1), pos.fix(:,2), 0, 0  ) % fixation

    cgflip( colour.background )
    %cgscrdmp
    waitkeydown(inf)


    for P = 1:length(pos.test)

        if P <= 8
            buffer = 101;
            S = 1;
        elseif P > 8 && P <= 16
            buffer = 117;
            S = 2;
        elseif P > 16
            buffer = 133;
            S = 3;
        end
        
        cgdrawsprite( buffer, pos.test(P,1), pos.test(P,2), sizes.letter(S), sizes.letter(S)*ry )

    end

    cgpolygon( pos.fix(:,1), pos.fix(:,2), 0, 0  ) % fixation

    cgflip( colour.background )
    %cgscrdmp
    waitkeydown(inf)
    
    
    
    for P = 1:length(pos.test)

        if P <= 8
            buffer = 109;
            S = 1;
        elseif P > 8 && P <= 16
            buffer = 125;
            S = 2;
        elseif P > 16
            buffer = 141;
            S = 3;
        end
        
        cgdrawsprite( buffer, pos.test(P,1), pos.test(P,2), sizes.letter(S), sizes.letter(S)*ry )

    end

    cgpolygon( pos.fix(:,1), pos.fix(:,2), 0, 0  ) % fixation

    cgflip( colour.background )
    %cgscrdmp
    waitkeydown(inf)
    

end


%% load checkerboads

fname = {'cb1.BMP', 'cb2.BMP', 'cb3.BMP', 'cb4.BMP', ...
         'cb5.BMP', 'cb6.BMP', 'cb7.BMP', 'cb8.BMP'}; 

cd( direct.checkerboards );

for C = 1:8 % 8 checkerboards
	cgloadbmp(C, fname{C});
    
    for G = 1:2
    
        if options.preview_stimuli == true
            cgdrawsprite( C, 0, 0, sizes.checkerboards, sizes.checkerboards*( mon.res(2)/mon.res(1) )*ry )

            
            if G == 2
                cgellipse( 0, 0, sizes.occ_cen, sizes.occ_cen*ry, colour.background, 'f') % central occluder
                cgellipse( -R(3), 0, sizes.occ_let, sizes.occ_let*ry, colour.background, 'f') % left occluder
                cgellipse( +R(3), 0, sizes.occ_let, sizes.occ_let*ry, colour.background, 'f') % right occluder
               	cgpencol(colour.fix)
                cgpolygon( pos.fix(:,1), pos.fix(:,2) ) % fixation
            end
            
            cgflip( colour.background )
            %cgscrdmp
            waitkeydown(inf)
            
        end
        
    end
    
end

cd(direct.exp);


%% text
digital_font2;


%% run experiment

cgpencol( colour.fix )

switch options.test
    case 1    
        cd( direct.test );
        scotoma_test;
    case 2
        cd( direct.test );
        scotoma_eeg;
    case 3
        cgshut
end