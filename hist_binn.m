function  hist_binned= hist_binn(dataset,binning)

temp_dataset = sort(dataset,1);

if floor(max(temp_dataset)) == max(temp_dataset)
    max_edge = max(temp_dataset);
else
    max_edge = floor(max(temp_dataset))+1;
end

hist_binned = [];
count = 0;
for n=0:binning:max_edge
    count= count+1;
    hist_binned(count,1) = n;
    hist_binned(count,2) = 0;
    for m =1:max(size(temp_dataset))
        if temp_dataset(m,1) < n+1 && temp_dataset(m,1) >= n
            hist_binned(count,2) = hist_binned(count,2) +temp_dataset(m,2);
        end
    end
    
end