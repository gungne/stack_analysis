
function [k1,k2] = kcoef(channel1,channel2)

k1 = sum(channel1 .*channel2) / sum(channel1.*channel1);
k2 = sum(channel1 .*channel2) / sum(channel2.*channel2);

end

