function [c] = imreverse(a)
%get the reverse bw 
[m,n]=size(a);
c=ones(m,n)-a;
end

