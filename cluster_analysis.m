function [pixels_dist_mean,pixels_dist_var] = cluster_analysis(pixels_list) 
pixels_list = double(pixels_list);
z_ratio = 1/0.667 ;
centre_pixel(1,1) = double(sum(pixels_list(:,1).* pixels_list(:,4))/sum(pixels_list(:,4)));
centre_pixel(1,2) = double(sum(pixels_list(:,2).* pixels_list(:,4))/sum(pixels_list(:,4)));
centre_pixel(1,3) = double(sum(pixels_list(:,3).* pixels_list(:,4))/sum(pixels_list(:,4)));
% display(centre_pixel);
for m = 1:max(size(pixels_list))
    pixels_dist(m,1) = sqrt((pixels_list(m,1)- centre_pixel(1,1)).^2+(pixels_list(m,2)- centre_pixel(1,2)).^2+((pixels_list(m,3)- centre_pixel(1,3))*z_ratio).^2);
end
pixels_dist_mean = double(sum(pixels_dist(:,1).* pixels_list(:,4))/sum(pixels_list(:,4)));
pixels_dist_var = double(sqrt(sum((pixels_dist(:,1)- pixels_dist_mean).^2.* pixels_list(:,4))/mean(pixels_list(:,4))/(max(size(pixels_list))-1)));