function image_out = maximum_projection(image_stack)
image_out = image_stack(:,:,:,1);
[length,width,~,~] = size(image_stack);
for n = 1:length
    for m = 1:width
            image_out(n,m,1) = max(image_stack(n,m,1,:));
            image_out(n,m,2) = max(image_stack(n,m,2,:));
            image_out(n,m,3) = max(image_stack(n,m,3,:));
        
    end
end

end
