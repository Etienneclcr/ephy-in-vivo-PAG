% by Mai Iwasaki, August 2022
%% To use McMatlabDataools on MATLAB
%Pease download McsMatlabDataTools first from here
%https://github.com/multichannelsystems/McsMatlabDataTools
addpath C:\Users\Username\Documents\MATLAB\McsMatlabDataTools %Paste YOUR address where McsMatlabDataTools is stored
import McsHDF5.*
doc McsHDF5

%% Using McMatlabDatatools,let's extract the in vivo ephys raw data from HDF5 file
addpath D:\MC_Rack_Data %Paste YOUR address where the HDF5 file is stored
file_ext='.h5';
q=input('Input 1 or 2. dOVT with 2 recording files=2, Others with 1 cording file =1');
samplingrate=25000;

for i=1:q
mcname{i,1}=input('Copy & paste the data file name to load','s');
mcdata{i,1}=McsHDF5.McsData([mcname{i,1} file_ext]);
% Let's extract raw continuous voltage from the whole data! 
raw_cntn_nV{i,1}=mcdata{i,1}.Recording{1,1}.AnalogStream{1,2}.ChannelData;%In case the file has event time stamp for Opto Laser and/or Electric Shock as well
%raw_cntn_nV{i,1}=mcdata{i,1}.Recording{1,1}.AnalogStream{1,1}.ChannelData; %In case the file has ONLY ELECTRODE data

%How long does it take for 1st and 2nd recording in sec?
nDatapoint(i)=length(raw_cntn_nV{i,1});
RecSeC(i)=nDatapoint(i)/samplingrate;

%Let's extract event time stamp from the whole data! from microsec to sec and save them in the folder to made!
%%Both Opto Laser & Electric Shock
%Opto Laser
EvtTS_wholeOp{i,1}=mcdata{i,1}.Recording{1,1}.EventStream{1,1}.Events{1,1}(1,:);%Opto Laser Time Stamp
EvtTS_secOp{i,1}=0.000001*double(EvtTS_wholeOp{i,1}(1,:)).';%Convert from microsec to sec
% Electric Shock
EvtTS_wholeEs{i,1}=mcdata{i,1}.Recording{1,1}.EventStream{1,2}.Events{1,1}(1,:);%Electric Shock Time Stamp for electric shock plus opto
%EvtTS_wholeEs{i,1}=mcdata{i,1}.Recording{1,1}.EventStream{1,1}.Events{1,1}(1,:);%only electricshock
EvtTS_secEs{i,1}=0.000001*double(EvtTS_wholeEs{i,1}(1,:)).';%Convert from microsec to sec

if i==2
% combine 1st and 2nd recording Voltage
raw_cntn_nVcom=horzcat(raw_cntn_nV{1,1},raw_cntn_nV{2,1});

%Let's convert the time code of the 2nd recording to be continuous from the 1st recording
EvtTS_secOp2cont=RecSeC(1)+EvtTS_secOp{2,1};
%combine 1st and 2nd recording
EvtTS_secOp{3,1}=vertcat(EvtTS_secOp{1,1},EvtTS_secOp2cont);

% Let's convert the time code of the 2nd recording to be continuous from the 1st recording
EvtTS_secEs2cont=RecSeC(i)+EvtTS_secEs{2,1};
% combine 1st and 2nd recording
EvtTS_secEs{3,1}=vertcat(EvtTS_secEs{1,1},EvtTS_secEs2cont);

else
raw_cntn_nVcom=raw_cntn_nV{1,1};
EvtTS_secOp{3,1}=EvtTS_secOp{1,1};
EvtTS_secEs{3,1}=EvtTS_secEs{1,1};
end
end

%Let's convert the numerical unit from "nano volt" to "volt"!
raw_cntn_V=0.000000001*raw_cntn_nVcom;
%Save Opto Time Stamp in mat file
Path_fl_title=[dirname '/' 'EvtTS_secOp' '.mat']; 
save(Path_fl_title,'EvtTS_secOp');
%Save Electrick shock Time Stamp in mat file
Path_fl_title=[dirname '/' 'EvtTS_secEs' '.mat'];
save(Path_fl_title,'EvtTS_secEs'); %Save this in mat file

%% Which channel(A,B,C,D)is stored in which row (1,2,3,4) of raw_cntn_V ? We used neuronexus probe.
% https://www.neuronexus.com/files/probemapping/4-channel/Map-Qtrode.pdf
% Here to avoid confusion between channel ID# and row#, we call channel1=A,channel2=B,channel3=C,channel4=D

%In case of ACUTE Qtrode 4ch tetrode 
Ttrd_Cnl(1,1)=2; %A is in raw_cntn_V(2,:)
Ttrd_Cnl(2,1)=4; %B is in raw_cntn_V(4,:)
Ttrd_Cnl(3,1)=3; %C is in raw_cntn_V(3,:)
Ttrd_Cnl(4,1)=1; %D is in raw_cntn_V(1,:)

%% Let's devide raw_cntn_V into each independent tetrode!
%Label the data of tetrode#1
Ttrd_Cnl_Lbl{1,1}='Ttrd1V_A';
Ttrd_Cnl_Lbl{2,1}='Ttrd1V_B';
Ttrd_Cnl_Lbl{3,1}='Ttrd1V_C';
Ttrd_Cnl_Lbl{4,1}='Ttrd1V_D';

%% Let's make a folder to store the data files of each independent channels!
dateformat='yy_mm_dd_HH_MM';
date=datestr(now,dateformat);
dir_ID='TtrdV_';
dirname=[dir_ID date];
mkdir(dirname);

%% Let's save them as ".mat" file inside the folder which you made now!
[tate,yoko]=size(Ttrd_Cnl_Lbl);
fl_title=cell([tate, 1]);
for k=1:tate
    data=raw_cntn_V(Ttrd_Cnl(k,1),:);
    recordID=Ttrd_Cnl_Lbl{k,1};
    fl_title{k,1}=[recordID date];
    Path_fl_title=[dirname '/' fl_title{k,1} '.mat'];
    save(Path_fl_title,'data');
end

%% Let's make a text file for Wave_Clus!
textID=fopen('polytrode1.txt','w');
formatSpec='%s\r\n'; % "%s" means the data is text. "\r\n"means new line.
for k=1:4
    fprintf(textID,formatSpec,[fl_title{k,1} '.mat']);
end
fclose(textID);

%% Let's clean up inside the Workspace
clearvars -except mcdata EvtTS_secOp EvtTS_secEs nDatapoint