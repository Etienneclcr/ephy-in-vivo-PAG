% by Mai Iwasaki, August 2022
load('ToMakePAG_String.mat');

PAG_String{1,1}='PAG_rRat19_5328both_3B';
PAG_String{1,2}=PAG_rRat19_5328both_3B{1,1};

PAG_String{2,1}='PAG_rRat19_5328both_5D';
PAG_String{2,2}=PAG_rRat19_5328both_5D{1,1};

PAG_String{3,1}='PAG_rRat19_5328both_1C';
PAG_String{3,2}=PAG_rRat19_5328both_1C{1,1};

PAG_String{4,1}='PAG_Rat18_4252_7A';
PAG_String{4,2}=PAG_Rat18_4252_7A{1,1};

PAG_String{5,1}='PAG_rRat19_5419posi_4D';
PAG_String{5,2}=PAG_rRat19_5419posi_4D{1,1};

PAG_String{6,1}='PAG_Rat18_4644nega_2D';
PAG_String{6,2}=PAG_Rat18_4644nega_2D{1,1};

PAG_String{7,1}='PAG_rRat19_5419nega_2C';
PAG_String{7,2}=PAG_rRat19_5419nega_2C{1,1};

PAG_String{8,1}='PAG_rRat18_3398_3B';
PAG_String{8,2}=PAG_rRat18_3398_3B{1,1};

PAG_String{9,1}='PAG_rRat19_5328both_2D';
PAG_String{9,2}=PAG_rRat19_5328both_2D{1,1};

PAG_String{10,1}='PAG_Rat19_6328posi_2A';
PAG_String{10,2}=PAG_Rat19_6328posi_2A{1,1};

PAG_String{11,1}='PAG_Rat18_5243nega_3A';
PAG_String{11,2}=PAG_Rat18_5243nega_3A{1,1};

PAG_String{12,1}='PAG_Rat18_4133_3D';
PAG_String{12,2}=PAG_Rat18_4133_3D{1,1};

PAG_String{13,1}='PAG_Rat18_4133_2C';
PAG_String{13,2}=PAG_Rat18_4133_2C{1,1};

PAG_String{14,1}='PAG_Rat18_4133_4A';
PAG_String{14,2}=PAG_Rat18_4133_4A{1,1};

PAG_String{15,1}='PAG_Rat16_7000nega_1A';
PAG_String{15,2}=PAG_Rat16_7000nega_1A{1,1};

PAG_String{16,1}='PAG_Rat16_6500_1A';
PAG_String{16,2}=PAG_Rat16_6500_1A{1,1};

PAG_String{17,1}='PAG_Rat18_5243nega_2B';
PAG_String{17,2}=PAG_Rat18_5243nega_2B{1,1};

PAG_String{18,1}='PAG_rRat19_5328both_4D';
PAG_String{18,2}=PAG_rRat19_5328both_4D{1,1};

PAG_String{19,1}='PAG_rRat19_6822posi_1C';
PAG_String{19,2}=PAG_rRat19_6822posi_1C{1,1};

PAG_String{20,1}='PAG_Rat19_7367_1D';
PAG_String{20,2}=PAG_Rat19_7367_1D{1,1};

PAG_String{21,1}='PAG_Rat19_4983_2D';
PAG_String{21,2}=PAG_Rat19_4983_2D{1,1};

PAG_String{22,1}='PAG_Inhibit_Rat19_6328_1B';
PAG_String{22,2}=PAG_Inhibit_Rat19_6328_1B{1,1};

PAG_String{23,1}='PAG_Inhibit_Rat19_5064_1D';
PAG_String{23,2}=PAG_Inhibit_Rat19_5064_1D{1,1};

Spknbr=zeros(1,400);
for i=1:length(PAG_String)
for m=1:400
%The 1st histogram -100sec (-100000 msec)before BL.Binning by 1sec = 1000msec bin
histposi_st=-100000+1000*(m-1); 
histposi_ed=-100000+1000*m;
Spknbr(1,m)=numel(PAG_String{i,2}(PAG_String{i,2}<histposi_ed & PAG_String{i,2}>=histposi_st));
PAG_String{i,3}(1,m)=Spknbr(1,m);
end
end