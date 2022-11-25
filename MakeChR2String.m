% by Mai Iwasaki, August 2022
load(ToMakeChR2string.mat);

ChR2String{1,1}='Rat1LscClus1';
ChR2String{1,2}=Rat1LscClus1;
ChR2String{1,3}=Rat1LscES2stIND;

ChR2String{2,1}='Rat1LscClus4';
ChR2String{2,2}=Rat1LscClus4;
ChR2String{2,3}=Rat1LscES2stIND;

ChR2String{3,1}='Rat3RscClus1';
ChR2String{3,2}=Rat3RscClus1;
ChR2String{3,3}=Rat3RscES2stIND;

ChR2String{4,1}='Rat3RscClus2';
ChR2String{4,2}=Rat3RscClus2;
ChR2String{4,3}=Rat3RscES2stIND;

ChR2String{5,1}='Rat5RscClus1';
ChR2String{5,2}=Rat5RscClus1;
ChR2String{5,3}=Rat5RscES2stIND;

ChR2String{6,1}='Rat5RscClus2';
ChR2String{6,2}=Rat5RscClus2;
ChR2String{6,3}=Rat5RscES2stIND;

ChR2String{7,1}='Rat5RscClus3';
ChR2String{7,2}=Rat5RscClus3;
ChR2String{7,3}=Rat5RscES2stIND;

ChR2String{8,1}='Rat9LscClus3';
ChR2String{8,2}=Rat9LscClus3;
ChR2String{8,3}=Rat9LscES2stIND;

ChR2String{9,1}='Rat9RscClus2';
ChR2String{9,2}=Rat9RscClus2;
ChR2String{9,3}=Rat9RscES2stIND;

ChR2String{10,1}='Rat11RscClus3Rec1';
ChR2String{10,2}=Rat11RscClus3Rec1;
ChR2String{10,3}=Rat11RscES2stIND1;

ChR2String{11,1}='Rat12LscClus1Rec1';
ChR2String{11,2}=Rat12LscClus1Rec1;
ChR2String{11,3}=Rat12LscES2stIND1;

ChR2String{12,1}='Rat12RscClus1Rec1';
ChR2String{12,2}=Rat12RscClus1Rec1;
ChR2String{12,3}=Rat12RscES2stIND1;

ChR2String{13,1}='Rat14LscClus1Rec1';
ChR2String{13,2}=Rat14LscClus1Rec1;
ChR2String{13,3}=Rat14LscES2stIND1;

ChR2String{14,1}='Rat26RscClus2Rec1';
ChR2String{14,2}=Rat26RscClus2Rec1;
ChR2String{14,3}=Rat26RscClus2ES2stIND1;

ChR2String{15,1}='Rat25RscClus1Rec1';
Rat25RscClus1Rec1=Rat25RscClus1Rec1_lack;
for i=288:290
Rat25RscClus1Rec1{i,1}=NaN;
end
ChR2String{15,2}=Rat25RscClus1Rec1;
ChR2String{15,3}=NaN;

% ES period of First290sec
for n=1:length(ChR2String)
ChR2String{n,4}=ChR2String{n,2}(1:290,1);
end

% ES period of Second60sec
for n=1:length(ChR2String)
    if n==15
    ChR2String{n,5}=NaN;
    else
ChR2String{n,5}=ChR2String{n,2}(ChR2String{n,3}+1:(ChR2String{n,3}+60),1);
    end
end