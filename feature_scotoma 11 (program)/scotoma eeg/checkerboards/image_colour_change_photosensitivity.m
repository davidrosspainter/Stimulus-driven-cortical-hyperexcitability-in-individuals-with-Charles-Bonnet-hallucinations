%% image_colour_change_photosensitivty.m

tic

% replace colour values in image with new ones

clear
clc

close('all');

r1 = 255; % old
g1 = 119; % old
g2 = 126;

c1 = [0 119 0];
c2 = [255 0 0];


fname = dir('*.bmp');

    
for F = 1:length( fname )




        disp( ['file: ' num2str( fname(F).name ) ] );

        clear img

        img = imread( fname(F).name );

        % f1 = figure();
        % imshow(img);

        [r c z] = size(img);

        disp( 'red' )
        disp( unique( img(:,:,1) )' )
        disp( 'green' )
        disp( unique( img(:,:,2) )' )
        disp( 'blue' )
        disp( unique( img(:,:,3) )' )


%         for i=1:r
%             for j=1:c
% 
% 
% 
%                 if img(i,j,2) == g1 % remove green
%                     img(i,j,2) = g2;
% 
% 
%                 end
% 
% 
% 
% 
% 
%             end
%         end
% 
%     
%         imwrite(img, fname(F).name, 'bmp');
    

end
    
toc