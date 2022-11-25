% by Mai Iwasaki, August 2022
load('SpinalCord_String.mat'); 
%-100 to +900 total=1001 including value at zero or edge
ZeroOne290_1000=zeros(1001,290);% Let's make a mean raster of the first 290sec
ZeroOne60_1000=zeros(1001,60);% Let's make a mean raster of the second 60sec
hsize=[100,20];% hsize is a vector which defines the number of raws and columns

%% ChR2
for i=1:length(ChR2String)
    
ChR2ZeroOne290_1000{i,1}=ZeroOne290_1000;
for m=1:290
  for p=length(ChR2String{i,4}{m,1}):-1:1
      %SpikeList{n,4} is spikes during First 290 sec of ES
      ColumnIndex=ChR2String{i,4}{m,1}(p,1)+100;%+100 means,this raster is -100 to +900,spike at -100 becomes index 0.
      if isnan(ColumnIndex)==1 %1 means True, Nan. This is noise.
      ChR2ZeroOne290_1000{i,1}(:,m)=NaN;
      else
      ChR2ZeroOne290_1000{i,1}(1000-ColumnIndex+1,m)=1;%Flip data to Y axis  
      end
  end
end
ChR2Conv290_1000{i,1}=conv2(ChR2ZeroOne290_1000{i,1}, fspecial('gaussian',hsize,20), 'same');
% h = fspecial('gaussian', hsize, sigma) 
% hsize is a vector which defines the number of raws and columns
% sigma=standard deviation, 99.7 percent of data exist within 3 sigma.As
% this value becomes larger, the image becomes more blurry.

ChR2ZeroOne60_1000{i,1}=ZeroOne60_1000;
for m=1:60
  for p=length(ChR2String{i,5}{m,1}):-1:1
      %SpikeList{n,4} is spikes during First 290 sec of ES
      ColumnIndex=ChR2String{i,5}{m,1}(p,1)+100; %+100 means,this raster is -100 to +900,spike at -100 becomes index 0. 
      if isnan(ColumnIndex)==1 %1 means True, Nan. This is noise.
      ChR2ZeroOne60_1000{i,1}(:,m)=NaN;
      else
      ChR2ZeroOne60_1000{i,1}(1000-ColumnIndex+1,m)=1;%Flip data to Y axis  
      end
  end
end
ChR2Conv60_1000{i,1}=conv2(ChR2ZeroOne60_1000{i,1}, fspecial('gaussian',hsize,20), 'same');

end

%% WT
for i=1:length(WTString)
    
WTZeroOne290_1000{i,1}=ZeroOne290_1000;
for m=1:290
  for p=length(WTString{i,4}{m,1}):-1:1
      %SpikeList{n,4} is spikes during First 290 sec of ES
      ColumnIndex=WTString{i,4}{m,1}(p,1)+100;%+100 means,this raster is -100 to +900,spike at -100 becomes index 0.
      if isnan(ColumnIndex)==1 %1 means True, Nan. This is noise.
      WTZeroOne290_1000{i,1}(:,m)=NaN;
      else
      WTZeroOne290_1000{i,1}(1000-ColumnIndex+1,m)=1;%Flip data to Y axis  
      end
  end
end
WTConv290_1000{i,1}=conv2(WTZeroOne290_1000{i,1}, fspecial('gaussian',hsize,20), 'same');

WTZeroOne60_1000{i,1}=ZeroOne60_1000;
for m=1:60
  for p=length(WTString{i,5}{m,1}):-1:1
      %SpikeList{n,4} is spikes during First 290 sec of ES
      ColumnIndex=WTString{i,5}{m,1}(p,1)+100;%+100 means,this raster is -100 to +900,spike at -100 becomes index 0.
      if isnan(ColumnIndex)==1 %1 means True, Nan. This is noise.
      WTZeroOne60_1000{i,1}(:,m)=NaN;
      else
      WTZeroOne60_1000{i,1}(1000-ColumnIndex+1,m)=1;%Flip data to Y axis  
      end
  end
end
WTConv60_1000{i,1}=conv2(WTZeroOne60_1000{i,1}, fspecial('gaussian',hsize,20), 'same');

end

%% dOVT
for i=1:size(dOVTVhr2String,1)
    
dOVTZeroOne290_1000{i,1}=ZeroOne290_1000;
for m=1:290
  for p=length(dOVTVhr2String{i,4}{m,1}):-1:1
      %SpikeList{n,4} is spikes during First 290 sec of ES
      ColumnIndex=dOVTVhr2String{i,4}{m,1}(p,1)+100;%+100 means,this raster is -100 to +900,spike at -100 becomes index 0. 
      if isnan(ColumnIndex)==1 %1 means True, Nan. This is noise.
      dOVTZeroOne290_1000{i,1}(:,m)=NaN;
      else
      dOVTZeroOne290_1000{i,1}(1000-ColumnIndex+1,m)=1;%Flip data to Y axis 
      end
  end
end
dOVTConv290_1000{i,1}=conv2(dOVTZeroOne290_1000{i,1}, fspecial('gaussian',hsize,20), 'same');

dOVTZeroOne60_1000{i,1}=ZeroOne60_1000;
for m=1:60
  for p=length(dOVTVhr2String{i,5}{m,1}):-1:1
      %SpikeList{n,4} is spikes during First 290 sec of ES
      ColumnIndex=dOVTVhr2String{i,5}{m,1}(p,1)+100;%+100 means,this raster is -100 to +900,spike at -100 becomes index 0.
      if isnan(ColumnIndex)==1 %1 means True, Nan. This is noise.
      dOVTZeroOne60_1000{i,1}(:,m)=NaN;
      else
      dOVTZeroOne60_1000{i,1}(1000-ColumnIndex+1,m)=1;%Flip data to Y axis  
      end
  end
end
dOVTConv60_1000{i,1}=conv2(dOVTZeroOne60_1000{i,1}, fspecial('gaussian',hsize,20), 'same');

end