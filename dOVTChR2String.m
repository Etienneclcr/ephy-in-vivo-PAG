% by Mai Iwasaki, August 2022
load(ToMakedOVTChR2string.mat);

dOVTVhr2String{1,1}='Rat11RscClus3Rec2';
dOVTVhr2String{1,2}=Rat11RscClus3Rec2;
dOVTVhr2String{1,3}=Rat11RscES2stIND2;

dOVTVhr2String{2,1}='Rat12LscClus1Rec2';
dOVTVhr2String{2,2}=Rat12LscClus1Rec2;
dOVTVhr2String{2,3}=Rat12LscES2stIND2;

dOVTVhr2String{3,1}='Rat12RscClus2Rec2';
dOVTVhr2String{3,2}=Rat12RscClus2Rec2;
dOVTVhr2String{3,3}=Rat12RscES2stIND2;

dOVTVhr2String{4,1}='Rat14LscClus1Rec2';
dOVTVhr2String{4,2}=Rat14LscClus1Rec2;
dOVTVhr2String{4,3}=Rat14LscES2stIND2;

dOVTVhr2String{5,1}='Rat25RscClus1Rec2';
dOVTVhr2String{5,2}=Rat25RscClus1Rec2;
dOVTVhr2String{5,3}=Rat25RscClus1ES2stIND2;

dOVTVhr2String{6,1}='Rat26RscClus2Rec2';
dOVTVhr2String{6,2}=Rat26RscClus2Rec2;
dOVTVhr2String{6,3}=Rat26RscClus2ES2stIND2;

% ES period of First290sec
for n=1:length(dOVTVhr2String)
dOVTVhr2String{n,4}=dOVTVhr2String{n,2}(1:290,1);
end

% ES period of Second60sec
for n=1:length(dOVTVhr2String)
dOVTVhr2String{n,5}=dOVTVhr2String{n,2}(dOVTVhr2String{n,3}+1:(dOVTVhr2String{n,3}+60),1);
end
