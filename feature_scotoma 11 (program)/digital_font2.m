%% digital_font2.m

%  __   __
% 
% | \ | / |
%  __   __
%
% | / | \ |
%  __   __

% 1 2
% 3 4 5 6 7
% 8 9
% 10 11 12 13 14
% 15 16

% target segments
targets(01,1:16) = [001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016]; % mask
targets(02,1:16) = [001 002 003 NaN NaN 006 007 NaN NaN 010 011 NaN NaN 014 015 016]; % 0
targets(03,1:16) = [NaN NaN NaN NaN 005 NaN NaN NaN NaN NaN NaN 012 NaN NaN NaN NaN]; % 1
targets(04,1:16) = [001 002 NaN NaN NaN NaN 007 008 009 010 NaN NaN NaN NaN 015 016]; % 2
targets(05,1:16) = [001 002 NaN NaN NaN NaN 007 008 009 NaN NaN NaN NaN 014 015 016]; % 3
targets(06,1:16) = [NaN NaN 003 NaN NaN NaN 007 008 009 NaN NaN NaN NaN 014 NaN NaN]; % 4
targets(07,1:16) = [001 002 003 NaN NaN NaN NaN 008 NaN NaN NaN NaN 013 NaN 015 016]; % 5
targets(08,1:16) = [001 002 003 NaN NaN NaN NaN 008 009 010 NaN NaN NaN 014 015 016]; % 6
targets(09,1:16) = [001 002 NaN NaN NaN NaN 007 NaN NaN NaN NaN NaN NaN 014 NaN NaN]; % 7
targets(10,1:16) = [001 002 003 NaN NaN NaN 007 008 009 010 NaN NaN NaN 014 015 016]; % 8
targets(11,1:16) = [001 002 003 NaN NaN NaN 007 008 009 NaN NaN NaN NaN 014 015 016]; % 9
targets(12,1:16) = [001 002 003 NaN NaN NaN 007 008 009 010 NaN NaN NaN 014 NaN NaN]; % A
targets(13,1:16) = [001 002 NaN NaN 005 NaN 007 NaN 009 NaN NaN 012 NaN 014 015 016]; % B
targets(14,1:16) = [001 002 003 NaN NaN NaN NaN NaN NaN 010 NaN NaN NaN NaN 015 016]; % C
targets(15,1:16) = [001 002 NaN NaN 005 NaN 007 NaN NaN NaN NaN 012 NaN 014 015 016]; % D
targets(16,1:16) = [001 002 003 NaN NaN NaN NaN 008 009 010 NaN NaN NaN NaN 015 016]; % E
targets(17,1:16) = [001 002 003 NaN NaN NaN NaN 008 009 010 NaN NaN NaN NaN NaN NaN]; % F
targets(18,1:16) = [001 002 003 NaN NaN NaN NaN NaN 009 010 NaN NaN NaN 014 015 016]; % G
targets(19,1:16) = [NaN NaN 003 NaN NaN NaN 007 008 009 010 NaN NaN NaN 014 NaN NaN]; % H 
targets(20,1:16) = [001 002 NaN NaN 005 NaN NaN NaN NaN NaN NaN 012 NaN NaN 015 016]; % I
targets(21,1:16) = [NaN NaN NaN NaN NaN NaN 007 NaN NaN 010 NaN NaN NaN 014 015 016]; % J
targets(22,1:16) = [NaN NaN 003 NaN NaN 006 NaN 008 NaN 010 NaN NaN 013 NaN NaN NaN]; % K
targets(23,1:16) = [NaN NaN 003 NaN NaN NaN NaN NaN NaN 010 NaN NaN NaN NaN 015 016]; % L
targets(24,1:16) = [NaN NaN 003 004 NaN 006 007 NaN NaN 010 NaN NaN NaN 014 NaN NaN]; % M
targets(25,1:16) = [NaN NaN 003 004 NaN NaN 007 NaN NaN 010 NaN NaN 013 014 NaN NaN]; % N
targets(26,1:16) = [001 002 003 NaN NaN NaN 007 NaN NaN 010 NaN NaN NaN 014 015 016]; % O
targets(27,1:16) = [001 002 003 NaN NaN NaN 007 008 009 010 NaN NaN NaN NaN NaN NaN]; % P
targets(28,1:16) = [001 002 003 NaN NaN NaN 007 NaN NaN 010 NaN NaN 013 014 015 016]; % Q
targets(29,1:16) = [001 002 003 NaN NaN NaN 007 008 009 010 NaN NaN 013 NaN NaN NaN]; % R
targets(30,1:16) = [001 002 003 NaN NaN NaN NaN 008 009 NaN NaN NaN NaN 014 015 016]; % S
targets(31,1:16) = [001 002 NaN NaN 005 NaN NaN NaN NaN NaN NaN 012 NaN NaN NaN NaN]; % T
targets(32,1:16) = [NaN NaN 003 NaN NaN NaN 007 NaN NaN 010 NaN NaN NaN 014 015 016]; % U
targets(33,1:16) = [NaN NaN 003 NaN NaN 006 NaN NaN NaN 010 011 NaN NaN NaN NaN NaN]; % V
targets(34,1:16) = [NaN NaN 003 NaN NaN NaN 007 NaN NaN 010 011 NaN 013 014 NaN NaN]; % W
targets(35,1:16) = [NaN NaN NaN 004 NaN 006 NaN NaN NaN NaN 011 NaN 013 NaN NaN NaN]; % X
targets(36,1:16) = [NaN NaN 003 NaN NaN NaN 007 008 009 NaN NaN 012 NaN NaN NaN NaN]; % Y
targets(37,1:16) = [001 002 NaN NaN NaN 006 NaN NaN NaN NaN 011 NaN NaN NaN 015 016]; % Z
targets(38,1:16) = [001 002 NaN NaN NaN NaN 007 NaN 009 NaN NaN 012 NaN NaN NaN NaN]; % ?

list = '*0123456789abcdefghijklmnopqrstuvwxyz?';

[no_targets, no_segs] = size( targets );

colour.segments = NaN(no_targets, no_segs); % colour
colour.segments( ~isnan(targets) ) = 1;
colour.segments( isnan(targets) ) = 0;

% measurements
hhhor = 0.5 * h_hor;
hwhor = 0.5 * w_hor;
hhver = 0.5 * h_ver; 
hwver = 0.5 * w_ver;

origin = 0;

twhor = w_hor - hhhor;
thver = h_ver - hwver;

hveho = h_ver - h_hor;
whove = w_hor - w_ver;

vehoh = hveho - h_hor;
hovev = whove - hwver;


% offsets for segments
%            01     02     03     04     05    06     07     08     09     10    11   12   13   14   15   16
x_off = [-w_hor origin -w_hor -hwver origin	hwver +w_hor -w_hor origin -w_hor -twhor origin +twhor +w_hor -w_hor origin];
y_off = [+h_ver +h_ver origin +hhhor origin	hhhor origin origin origin -h_ver -thver -h_ver -thver -h_ver -h_ver -h_ver];

y_off = y_off*ry;

% shapes of segments (coordinates) for each segment type
x_hor = [origin +hhhor +twhor +w_hor +twhor +hhhor];
y_hor = [origin +hhhor +hhhor origin -hhhor -hhhor];

x_ver = [origin -hwver -hwver origin +hwver +hwver];
y_ver = [origin +hwver +thver +h_ver +thver +hwver];

x_di1 = [origin origin -hovev -whove -whove -hwver];
y_di1 = [origin +h_hor +hveho +hveho +vehoh origin];

x_di2 = [origin origin +hovev +whove +whove +hwver];
y_di2 = [origin +h_hor +hveho +hveho +vehoh origin];

% shapes of segments for each segment
pos.segment{01} = [x_hor; y_hor]; 
pos.segment{02} = [x_hor; y_hor];
pos.segment{03} = [x_ver; y_ver];
pos.segment{04} = [x_di1; y_di1];
pos.segment{05} = [x_ver; y_ver];
pos.segment{06} = [x_di2; y_di2];
pos.segment{07} = [x_ver; y_ver];
pos.segment{08} = [x_hor; y_hor];
pos.segment{09} = [x_hor; y_hor];
pos.segment{10} = [x_ver; y_ver];
pos.segment{11} = [x_di2; y_di2];
pos.segment{12} = [x_ver; y_ver];
pos.segment{13} = [x_di1; y_di2];
pos.segment{14} = [x_ver; y_ver];
pos.segment{15} = [x_hor; y_hor];
pos.segment{16} = [x_hor; y_hor];

% scale y aspect to make square
for S = 1:16
    pos.segment{S}(2,:) = pos.segment{S}(2,:)*ry;
end


%% show digital font characters

% for T = 1:no_targets
%     
% 
%         for S = 1:16
%         
%             if colour.segments(T,S) == 1
%                 cgpencol( colour.txt )
%             elseif colour.segments(T,S) == 0
%                 cgpencol( colour.background )
%             end
%             
%             cgpolygon( pos.segment{S}(1,:), pos.segment{S}(2,:), x_off(S), y_off(S) ) %01
%             
%         end
% 
%     if options.preview_stimuli == true
%         cgflip( colour.background )
%         waitkeydown(inf)
%     end 
%         
% end


%% make sprites for text

for T = 1:length( txt.word ) % text to create
    
    cgmakesprite( txt.buffer(T), length( txt.word{T} )*txt.width*txt.spacing_factor, txt.height*ry, colour.sprite )
    cgsetsprite( txt.buffer(T) )
    cgtrncol( txt.buffer(T), 'n' ) % set background to transparent

    for L = 1:length(txt.word{T})

        C = find( ismember( list, txt.word{T}(L) ) ); % character to draw

        for S = 1:16 % segment to draw

            if colour.segments(C,S) == 1
                cgpencol( colour.txt )
            elseif colour.segments(C,S) == 0
                cgpencol( colour.background )
            end

            cgpolygon( pos.segment{S}(1,:), pos.segment{S}(2,:), x_off(S) + txt.off{T}(L), y_off(S) ) %01

        end

    end
    
    cgsetsprite(0)

    if options.preview_stimuli == true
        cgdrawsprite( txt.buffer(T), 0, 0, length( txt.word{T} )*txt.width*txt.spacing_factor, txt.height*ry )
        cgflip( colour.background )
        waitkeydown( inf )
    end

end
