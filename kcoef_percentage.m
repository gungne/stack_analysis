function [k1_per,k2_per] = kcoef_percentage(channel1,channel2,total_intensity_ch1,total_intensity_ch2)
% channel1_per = channel1./total_intensity_ch1;
% channel2_per = channel2./total_intensity_ch2;

k1_per = dot(channel1_per ,channel2_per) / dot(channel1_per,channel1_per);
k2_per = dot(channel1_per ,channel2_per) / dot(channel2_per,channel2_per);

end

