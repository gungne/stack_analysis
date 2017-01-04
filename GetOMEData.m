function OMEData = GetOMEData(filename)

% Get OME Meta Information using BioFormats Library 5.1.8

% To access the file reader without loading all the data, use the low-level bfGetReader.m function:
reader = bfGetReader(filename);

% You can then access the OME metadata using the getMetadataStore() method:
omeMeta = reader.getMetadataStore();

% get ImageCount --> currently only reading one image is supported
imagecount = omeMeta.getImageCount();
imageID = imagecount - 1;

% get the actual metadata and store them in a structured array
[pathstr,name,ext] = fileparts(filename);
OMEData.FilePath = pathstr;
OMEData.Filename = strcat(name, ext);

% Get dimension order
OMEData.DimOrder = char(omeMeta.getPixelsDimensionOrder(imageID).getValue());

% Number of series inside the complete data set
OMEData.SeriesCount = reader.getSeriesCount();

% Dimension Sizes C - T - Z - X - Y
OMEData.SizeC = omeMeta.getPixelsSizeC(imageID).getValue();
OMEData.SizeT = omeMeta.getPixelsSizeT(imageID).getValue();
OMEData.SizeZ = omeMeta.getPixelsSizeZ(imageID).getValue();
OMEData.SizeX = omeMeta.getPixelsSizeX(imageID).getValue();
OMEData.SizeY = omeMeta.getPixelsSizeY(imageID).getValue();