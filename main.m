addpath('bfmatlab')
addpath('vis3d')
% GetOMEData('sample.czi')
time=1;
image_raw = ReadImage6D_single('Cid-GFP_nos-tub-mcherry-06.czi',time);
channel1=squeeze(image_raw{1}(1,1,24,1,:,:)/256);
channel2=squeeze(image_raw{1}(1,1,24,2,:,:)/256);
%series, timepoint, zplane, channel, x, y
channel1_new = threshold(channel1,30);
channel2_new = threshold(channel2,30);

[total_pixel, channel1_pixel, channel2_pixel,overlap] = overlap(channel1_new,channel2_new);

k1,k2 = kcoef(channel1_new,channel2_new);

% % disp(total_pixel, channel1_pixel, channel2_pixel,overlap);
k1,k2,k1*k2