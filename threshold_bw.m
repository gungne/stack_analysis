function image_new = threshold_bw(image,value)

image_new = image;
for n = 1:max(size(image(:,1)))
    for m = 1:max(size(image(1,:)))
        if image(n,m)<=value
            image_new(n,m) = 0;
        else 
            image_new(n,m) = 1;
        end
    end
end

end

