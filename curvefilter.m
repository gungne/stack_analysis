function image_output = curvefilter(image_input)
dim = size(image_input);
image_temp = zeros(dim); 
image_output = zeros(dim);
for n=1:3
    image_temp(:,:,n) = wiener2(image_input(:,:,n),[2 2]);
    reference = max(max(image_input(:,:,n)));
    if  reference == 0
        continue 
    end
    
    for j = 1:dim(1)
        for k= 1:dim(2)
            image_temp(j,k,n) =  double(image_input(j,k,n)) /(1.6*double(reference)) * 65536; 
        end
    end
    image_temp(:,:,n) = wiener2(image_temp(:,:,n),[3 3]);
end

image_output = uint16(image_temp); 