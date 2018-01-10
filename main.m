addpath('bfmatlab')
% addpath('vis3d')
% GetOMEData('sample.czi')
image_raw = ReadImage6D('Cid-GFP_nos-tub-mcherry-03.czi');
time = 7;
z_start = 14;
z_end = 24;

working_dir = pwd;

assoc_switch = 0;
% [upperPath, deepestFolder, ~] = fileparts(file_list{1})
for n = z_start:z_end
    temp_image = czi_prep(image_raw,time,n);

    total_pixel = 0;
    channel1_pixel = 0;
    channel2_pixel = 0;
    overlap_pixel = 0;
    k1_per = 0;
    k2_per = 0;
    ch1_assoc = 0;
    ch2_assoc = 0;

    if n == z_start
        if z_start == z_end
            [background,rect] = imcrop(temp_image);
           
        else
            overlay_ref = temp_image./(z_end-z_start);
            for m = z_start+1:z_end
                image_temp = czi_prep(image_raw,time,m);
                overlay_ref = overlay_ref + image_temp./(z_end-z_start);
            end
            [background,rect_noise] = imcrop(overlay_ref);
        end
        ch1_threshold = mean(background(:,:,1)) + 2 * std2(background(:,:,1));
        ch2_threshold = mean(background(:,:,2)) + 2 * std2(background(:,:,2));
     end
    
    
    if n == z_start
        if z_start == z_end
            [~,rect] = imcrop(temp_image);
           
        else
            overlay_ref =  temp_image./(z_end-z_start);
            for m = z_start+1:z_end
                image_temp =  czi_prep(image_raw,time, m);
                overlay_ref = overlay_ref + image_temp./(z_end-z_start);
            end
            [~,rect] = imcrop(overlay_ref);
        end
        close all
%         figure
%         hold on 
    end
    
    
    image_crop = imcrop(temp_image,rect);
    channel1=image_crop(:,:,1);
    channel2=image_crop(:,:,2);
    %series, timepoint, zplane, channel, x, y
    channel1_new = threshold(channel1,ch1_threshold);
    channel2_new = threshold(channel2,ch2_threshold);

    [total_pixel,channel1_pixel,channel2_pixel,overlap_pixel,total_intensity_ch1,total_intensity_ch2] = overlap(channel1_new,channel2_new);
    [~,~,channel2_pixel_raw,~,~,total_intensity_ch2_raw] = overlap(channel1_new,channel2_new);
    
    [k1_per,k2_per] = kcoef(double(channel1_new)./double(total_intensity_ch1),double(channel2_new)./double(total_intensity_ch2));
    
    %border association
    if assoc_switch ==1
        temp_silh = imsilh((channel1_new+channel2_new)/2,(ch1_threshold+ch2_threshold)/2);
        [ch1_assoc,ch2_assoc,logic]=borderassoc(double(channel1_new)./double(total_intensity_ch1),double(channel2_new)./double(total_intensity_ch2),temp_silh);
%         temp_hist1 = hist_binn(ch1_assoc,1);
%         temp_hist2 = hist_binn(ch2_assoc,1);
% %         temp_index = ones(max(size(temp_hist1)),1);
% %         temp_index(:)=n;
%         plot(temp_hist1(:,1),temp_hist1(:,2),'r');
% %         temp_index = ones(max(size(temp_hist2)),1);
% %         temp_index(:)=n;
%         plot(temp_hist2(:,1),temp_hist2(:,2),'g');
        if logic == 0
            continue
        else
% %             ch1_assoc_w = double(ch1_assoc) / double(total_intensity_ch1);
% %             ch2_assoc_w = double(ch2_assoc) / double(total_intensity_ch2);
% % 
% %             my_cell = strcat( 'A',num2str(n) );
% %             dlmwrite(strcat(deepestFolder,'.csv'),[total_pixel,channel1_pixel,channel2_pixel,overlap_pixel,k1_per,k2_per,k1_per*k2_per,sum(ch1_assoc(:,3))/sum(ch2_assoc(:,3)],'-append');
        end
    else
        my_cell = strcat( 'A',num2str(n) );
%         dlmwrite(strcat('timeseries','.csv'),[total_pixel,channel1_pixel,total_intensity_ch1,channel2_pixel,total_intensity_ch2,overlap_pixel,k1_per,k2_per,k1_per*k2_per],'-append');
        dlmwrite(strcat('timeseries_wraw2','.csv'),[channel2_pixel,total_intensity_ch2,channel2_pixel_raw,total_intensity_ch2_raw],'-append');
        
    end
end
dlmwrite(strcat('timeseries','.csv'),'-','-append')
chdir(working_dir)

% clear all
% channel1=squeeze(image_raw{1}(1,1,24,1,:,:)/256);
% channel2=squeeze(image_raw{1}(1,1,24,2,:,:)/256);
% %series, timepoint, zplane, channel, x, y
% channel1_new = threshold(channel1,30);
% channel2_new = threshold(channel2,30);
% 
% [total_pixel, channel1_pixel, channel2_pixel,overlap] = overlap(channel1_new,channel2_new);
% 
% k1,k2 = kcoef(channel1_new,channel2_new);
% 
% % % disp(total_pixel, channel1_pixel, channel2_pixel,overlap);
% k1,k2,k1*k2