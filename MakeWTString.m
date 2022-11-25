% by Mai Iwasaki, August 2022
load(ToMakeWTstring2.mat);

WTString{1,1}='Rat2LscClus1';
WTString{1,2}=Rat2LscClus1;
WTString{1,3}=Rat2LscES2stIND;

WTString{2,1}='Rat2RscClus1';
WTString{2,2}=Rat2RscClus1;
WTString{2,3}=Rat2RscES2stIND;

WTString{3,1}='Rat7LscClus1';
WTString{3,2}=Rat7LscClus1;
WTString{3,3}=Rat7LscES2stIND;

WTString{4,1}='Rat7RscClus1';
WTString{4,2}=Rat7RscClus1;
WTString{4,3}=Rat7RscES2stIND;

WTString{5,1}='Rat8LscClus1';
WTString{5,2}=Rat8LscClus1;
WTString{5,3}=Rat8LscES2stIND;

WTString{6,1}='Rat8RscClus2';
WTString{6,2}=Rat8RscClus2;
WTString{6,3}=Rat8RscES2stIND;

WTString{7,1}='Rat10LscES2Rec1';
WTString{7,2}=Rat10LscES2Rec1;
WTString{7,3}=Rat10LscES2stIND1;

WTString{8,1}='Rat10RscClus4Rec2';
WTString{8,2}=Rat10RscClus4Rec2;
WTString{8,3}=Rat10RscES2stIND2;

% ES period of First290sec
for n=1:length(WTString)
WTString{n,4}=WTString{n,2}(1:290,1);
end

% ES period of Second60sec
for n=1:length(WTString)
WTString{n,5}=WTString{n,2}(WTString{n,3}+1:(WTString{n,3}+60),1);
end
