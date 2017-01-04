function dot_axes = imperimaxes(perim)

[m,n] = size(perim);
count = 1;
for j = 1:m
    for k=1:n
        if perim(j,k) == 1
            dot_axes(count,1) = j;
            dot_axes(count,2) = k;
            count = count+1;
        end
    end
end

