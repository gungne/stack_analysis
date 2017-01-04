function [ image_silh ] = imsilh(image_input,threshold)
% get a smooth silhoutte
image_bw= im2bw(image_input,threshold/256);
image_bw_rev = imreverse(image_bw);
image_temp=bwareaopen(image_bw_rev,10,8);  
image_silh =imerode(image_temp,ones(3,3)); 
end