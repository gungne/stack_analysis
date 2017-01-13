function out = ReadImage6D_timepoint(filename,t_axis)

% Get OME Meta-Information
MetaData = GetOMEData(filename);

% The main inconvenience of the bfopen.m function is that it loads all the content of an image regardless of its size.
% Initialize BioFormats reader.
reader = bfGetReader(filename);

% Preallocate array with size (Series, SizeC, SizeZ, SizeT, SizeX, SizeY) 
image6d = zeros(MetaData.SeriesCount, 1, MetaData.SizeZ,  MetaData.SizeC, MetaData.SizeY, MetaData.SizeX);

for series = 1: MetaData.SeriesCount
    % set reader to current series
    reader.setSeries(series-1);
    
        for zplane = 1: MetaData.SizeZ
            for channel = 1: MetaData.SizeC
                % get linear index of the plane (1-based)
                iplane = loci.formats.FormatTools.getIndex(reader, zplane - 1, channel - 1, t_axis -1) + 1;
                % get frame for current series
                image6d(series, 1, zplane, channel, :, :) = bfGetPlane(reader, iplane);
            end
        end
   
end

% close BioFormats Reader
reader.close();

% store image data and meta information in cell array
out = {};
out{1} = image6d;
out{2} = MetaData;