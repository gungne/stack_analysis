function [ch1_assoc,ch2_assoc,logic] = borderassoc(ch1_image_raw,ch2_image_raw, temp_silh)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
temp_perim = bwperim(imreverse(temp_silh));
border_dots = [];

try
border_dots = imperimaxes(temp_perim); 
end

if max(size(border_dots))<1
    logic = 0;
else
    logic = 1;
    ch1_image = ch1_image_raw .* double(imreverse(temp_silh));
    ch2_image = ch2_image_raw .* double(imreverse(temp_silh));


    [m,n] = size(ch1_image);
    ch1_assoc=[];
    ch2_assoc=[];
    counter_ch1 = 0 ;
    counter_ch2 = 0 ;
    for j=1:m
        for k=1:n
            if ch1_image(j,k)>0
                counter_ch1 = counter_ch1 +1;
                ch1_assoc(counter_ch1,1) = double(min(pdist2([j,k],border_dots)));
                ch1_assoc(counter_ch1,2) = ch1_image(j,k);
                ch1_assoc(counter_ch1,3) = double(min(pdist2([j,k],border_dots)) * double(ch1_image(j,k)));
            end
            if ch2_image(j,k)>0
                counter_ch2 = counter_ch2 +1;
                ch2_assoc(counter_ch2,1) = double(min(pdist2([j,k],border_dots)));
                ch2_assoc(counter_ch2,2) = ch2_image(j,k);
                ch2_assoc(counter_ch2,3) = double(min(pdist2([j,k],border_dots)) * double(ch2_image(j,k)));
            end
        end
    end

% ch1_assoc,ch2_assoc
end

