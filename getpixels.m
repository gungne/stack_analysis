function [image_new,pixel_list] = getpixels(image,value,z,pixel_list)

image_new = image;
for n = 1:max(size(image(:,1)))
    for m = 1:max(size(image(1,:)))
        if image(n,m)<=value
            image_new(n,m) = 0;
        else
            pixel_list = [pixel_list; n m z image_new(n,m);];
        end
    end
end

end
