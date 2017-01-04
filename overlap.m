function [total_pixel, channel1_pixel, channel2_pixel,overlap_pixel,total_intensity_ch1, total_intensity_ch2] = overlap(channel1,channel2) 

total_pixel = 0;
channel1_pixel = 0;
channel2_pixel = 0;
overlap_pixel = 0;
total_intensity_ch1 = 0; 
total_intensity_ch2 = 0;
for n = 1:max(size(channel1(:,1)))
    for m = 1:max(size(channel1(1,:)))
        total_intensity_ch1 = total_intensity_ch1 + int32(channel1(n,m)); 
        total_intensity_ch2 = total_intensity_ch2 + int32(channel2(n,m));
    end
end

for n = 1:max(size(channel1(:,1)))
    for m = 1:max(size(channel2(1,:)))
        if channel1(n,m)>0
            channel1_pixel = channel1_pixel+1;
        end
        if channel2(n,m)>0
            channel2_pixel = channel2_pixel+1;
        end
        if channel1(n,m)>0 || channel2(n,m)>0 
            total_pixel = total_pixel + 1;
        end
        if channel1(n,m)>0 && channel2(n,m)>0
            overlap_pixel =overlap_pixel +1;
        end
   
    end
end
end

