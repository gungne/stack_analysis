function  output_image = czi_prep(image_raw,timepoint,z_position) 
empty_ch =  zeros(size(squeeze(image_raw{1}(1,1,1,1,:,:))));
channelnumber = image_raw{1,2}.SizeC;
if channelnumber < 3
    for n= 1:channelnumber
        temp_image(:,:,n) = uint16(squeeze(image_raw{1}(1,timepoint,z_position,n,:,:)));
    end
    for m = channelnumber+1:3
        temp_image(:,:,n) = uint16(squeeze(empty_ch));
    end
else 
    if channelnumber >= 3
        for n= 1:3
        temp_image(:,:,n) = uint16(squeeze(image_raw{1}(1,timepoint,z_position,n,:,:)));
        end
    end
end
        
output_image = temp_image;
