function  output_image = czi_prep(image_raw,timepoint,z_position) 
empty_ch =  zeros(size(squeeze(image_raw{1}(1,1,1,1,:,:))));
temp_image(:,:,2) = uint16(squeeze(image_raw{1}(1,timepoint,z_position,1,:,:)))*10;
temp_image(:,:,1) = uint16(squeeze(image_raw{1}(1,timepoint,z_position,2,:,:)))*5;
temp_image(:,:,3) = uint16(empty_ch);
output_image = temp_image;
