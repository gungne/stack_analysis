addpath('bfmatlab')
% addpath('vis3d')
% GetOMEData('sample.czi')
t_axis = 1;
z_start = 1;
z_end = 18;


image_raw = ReadImage6D_timepoint('pro and telo2.czi',t_axis);

time = 1;

working_dir = pwd;
hardstack = 0;
image_adjust = [0.01,0.2];
rect_bg_cell = {};

assoc_switch = 0;
% [upperPath, deepestFolder, ~] = fileparts(file_list{1})
count = 1;
for m = z_start:z_end
  image_stack(:,:,:,count) = czi_prep(image_raw,time,m);  
  count= count +1;
end
% clear image_raw

if z_start == z_end
       [background,rect] = imcrop(imadjust(squeeze(image_stack),image_adjust,[]));
        ch1_threshold = mean(background(:,:,1)) + 2 * std2(background(:,:,1));
        ch2_threshold = mean(background(:,:,2)) + 2 * std2(background(:,:,2));    
else
        

        if hardstack ==0
            overlay_ref = maximum_projection(image_stack) ;
            [bg_ref,rect_bg] = imcrop(imadjust(overlay_ref,image_adjust,[]));
            ch1_dots = [];
            ch2_dots = [];
            count = 1;
            for m = z_start:z_end
                ch1_dots = [ch1_dots ; reshape(imcrop(squeeze(image_stack(:,:,1,count)),rect_bg),[],1)];
                ch2_dots = [ch2_dots ; reshape(imcrop(squeeze(image_stack(:,:,2,count)),rect_bg),[],1)];
                count= count +1;
            end
            ch1_threshold = mean(ch1_dots) + 2 * std2(ch1_dots);
            ch2_threshold = mean(ch2_dots) + 2 * std2(ch2_dots);               
        else
            count = 1;
            for m = z_start:z_end
                [~,rect_bg_cell{count}] = imcrop(imadjust(squeeze(image_stack(:,:,:,count)),image_adjust,[]));
                
                count= count +1;
            end
            
            ch1_dots = [];
            ch2_dots = [];
            count = 1;
            for m = z_start:z_end
                ch1_dots = [ch1_dots ; reshape(imcrop(squeeze(image_stack(:,:,1,count)),rect_bg_cell{count}),[],1)];
                ch2_dots = [ch2_dots ; reshape(imcrop(squeeze(image_stack(:,:,2,count)),rect_bg_cell{count}),[],1)];
                count= count +1;
            end
            ch1_threshold = mean(ch1_dots) + 2 * std2(ch1_dots);
            ch2_threshold = mean(ch2_dots) + 2 * std2(ch2_dots);  
        end
        

end
close(gcf)
clear ch1_dots ch2_dots

pixels_list_ch2 = [];
thres_stack_ch2 = [];  
totalz_pixels_ch2 = 0;
totalz_intensity_ch2 = 0; 

 for n = 1:count-1 
    total_pixel = 0;
    channel1_pixel = 0;
    channel2_pixel = 0;
    overlap_pixel = 0;
    k1_per = 0;
    k2_per = 0;
    ch1_assoc = 0;
    ch2_assoc = 0;
    temp_image = squeeze(image_stack(:,:,:,n));
    if hardstack ==0
        image_crop = imcrop(temp_image,rect_bg);
    else
        image_crop_temp = imcrop(temp_image,rect_bg_cell{n});
        image_crop = uint16(zeros(size(temp_image)));
        image_crop(rect_bg_cell{n}(1):rect_bg_cell{n}(1)+rect_bg_cell{n}(4),rect_bg_cell{n}(2):rect_bg_cell{n}(2)+rect_bg_cell{n}(3),:) =  image_crop_temp;
    end


    channel1=image_crop(:,:,1);
    channel2=image_crop(:,:,2);
    %series, timepoint, zplane, channel, x, y
%     channel1_new = threshold(channel1,ch1_threshold);
    [channel2_new,pixels_list_ch2] = getpixels(channel2,ch2_threshold,n,pixels_list_ch2);
%     thres_stack_ch2(:,:,n) = threshold_bw(channel2_new,ch2_threshold);
    


    totalz_pixels_ch2 = totalz_pixels_ch2 + channel2_pixel;
    totalz_intensity_ch2 = totalz_intensity_ch2 + total_intensity_ch2;
    
    
    overlap_option = 0;
    if coef_option ==1
    [total_pixel,channel1_pixel,channel2_pixel,overlap_pixel,total_intensity_ch1,total_intensity_ch2] = overlap(channel1_new,channel2_new);
    [k1_per,k2_per] = kcoef(double(channel1_new)./double(total_intensity_ch1),double(channel2_new)./double(total_intensity_ch2));
    end 
    
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
%         my_cell = strcat( 'A',num2str(n) );
    end
 end

cluster_option = 0;
if cluster_option ==1
    [pixels_dist_mean,pixels_dist_var] = cluster_analysis(pixels_list_ch2); 
end
% dlmwrite(strcat('timeseries','.csv'),[total_pixel,channel1_pixel,total_intensity_ch1,channel2_pixel,total_intensity_ch2,overlap_pixel,k1_per,k2_per,k1_per*k2_per],'-append');
% dlmwrite(strcat('result','.csv'),[totalz_pixels_ch2,totalz_intensity_ch2,t_axis],'-append','precision',5);
% dlmwrite(strcat('result','.csv'),[pixels_dist_mean,pixels_dist_var,t_axis],'-append','precision',5);



chdir(working_dir)
clear all