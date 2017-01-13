% addpath('bfmatlab')
% addpath('vis3d')
% GetOMEData('sample.czi')
% time=1;
working_dir = pwd;
fig_dir = uigetdir();
[upperPath, deepestFolder, ~] = fileparts(fig_dir);
file_list= getAllFiles(fig_dir);
assoc_switch = 0;
% [upperPath, deepestFolder, ~] = fileparts(file_list{1})
for n = 1:max(size(file_list)) 
    total_pixel = 0;
    channel1_pixel = 0;
    channel2_pixel = 0;
    overlap_pixel = 0;
    k1_per = 0;
    k2_per = 0;
    ch1_assoc = 0;
    ch2_assoc = 0;
    
     if n == 1
        if max(size(file_list))==1
            [background,rect] = imcrop(imread(char(file_list(1))));
           
        else
            overlay_ref =  uint8(zeros(size(imread(char(file_list(1))))));
            for m = 1:max(size(file_list))
                image_temp = imread(char(file_list(m)));
                overlay_ref = overlay_ref + image_temp./max(size(file_list));
            end
            [background,rect] = imcrop(overlay_ref);
        end
        ch1_threshold = max(max(background(:,:,1)).*1.5);
        ch2_threshold = max(max(background(:,:,2)).*1.5);
     end
    
    
    if n == 1
        if max(size(file_list))==1
            [~,rect] = imcrop(imread(char(file_list(1))));
           
        else
            overlay_ref =  uint8(zeros(size(imread(char(file_list(1))))));
            for m = 1:max(size(file_list))
                image_temp = imread(char(file_list(m)));
                overlay_ref = overlay_ref + image_temp./max(size(file_list));
            end
            [~,rect] = imcrop(overlay_ref);
        end
        close all
%         figure
%         hold on 
    end
    
    image_raw = imread(char(file_list(n)));
    image_crop = imcrop(image_raw,rect);
    channel1=image_crop(:,:,1);
    channel2=image_crop(:,:,2);
    %series, timepoint, zplane, channel, x, y
    channel1_new = threshold(channel1,ch1_threshold);
    channel2_new = threshold(channel2,ch2_threshold);

    [total_pixel,channel1_pixel,channel2_pixel,overlap_pixel,total_intensity_ch1,total_intensity_ch2] = overlap(channel1_new,channel2_new);
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
        dlmwrite(strcat(deepestFolder,'.csv'),[total_pixel,channel1_pixel,channel2_pixel,overlap_pixel,k1_per,k2_per,k1_per*k2_per],'-append');
        
    end
end

chdir(working_dir)

% clear all