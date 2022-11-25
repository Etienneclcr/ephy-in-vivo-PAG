% by Mai Iwasaki, August 2022
%This script refer to
%"EvtTS_secEs","EvtTS_secOp","nDatapoint","times_polytrode1.mat",and
%"Ttrd1V_Xyy_mm_dd_HH_MM.mat".

%% Prepare the information in "mlib"to run the mlib function "markvec2" and "mpsth2".
polytrode_number='1';
flnm='times_polytrode';
flext='.mat';
%Let's open the file which is the result of Do_clustering(1) of wave_clus;
load([flnm polytrode_number flext]); 

%% 
j=input('Input 1 or 2. dOVT with 2 recording files=2, Others with 1 recording file =1');
for k=1:j %1st or 2nd recording
mlib.eventtimingsOp{k,1}=EvtTS_secOp{k,1};%Let's make EVENT TIMINGS, Here, OptoLaser, EvtTS_secOp!
mlib.eventtimingsEs{k,1}=EvtTS_secEs{k,1};%Let's make EVENT TIMINGS, Here, Electric Shock, EvtTS_secEs!

%% Blue light period
%first spike timing within BL
BLstart(k,1)=min(EvtTS_secEs{k,1}(min(EvtTS_secOp{k,1})<EvtTS_secEs{k,1}));  
BLstIND(k,1)=find(EvtTS_secEs{k,1}==BLstart(k,1));
%last spike timing within BL
BLend(k,1)=max(EvtTS_secEs{k,1}(max(EvtTS_secOp{k,1})>EvtTS_secEs{k,1}));
BLedIND(k,1)=find(EvtTS_secEs{k,1}==BLend(k,1));
%Recovery from non ES period, start time point of the 2nd ES for 60sec
ES2start(k,1)=max(EvtTS_secEs{k,1}(310>EvtTS_secEs{k,1})); %Actually it is the time code of final ES during the first 290sec recording
ES2stIND(k,1)=find(EvtTS_secEs{k,1}==ES2start(k,1));
end
%%
for p=1:3
mlib.markers{p,1}=zeros(length(cluster_class(:,1)),4); %MARKERS
end
if j==2 % dOVT with 2 recording
    % Let's make TIMINGS where (timecode of spike in second, 1)
Rec1LastSec=nDatapoint(1)/25000; %Index of the final spikes of all clusters
Rec1LastmilliSec=Rec1LastSec*1000; % cluster_class(:,2)is saved in millisecond, so..
Rec1ClusLastInd=find(cluster_class(:,2)<=Rec1LastmilliSec, 1, 'last' );
mlib.timings{1,1}=0.001*cluster_class(1:Rec1ClusLastInd,2); %First recording, Let's convert the numerical unit from "millisecond" to "second"!
mlib.timings{2,1}=0.001*cluster_class(Rec1ClusLastInd+1:length(cluster_class),2)-Rec1LastSec; %Second recording
mlib.timings{3,1}=0.001*cluster_class(:,2); %1st and 2nd recording continuous
%Let's make MARKERS where (cluster class, 1)
mlib.markers{1,1}=cluster_class(1:Rec1ClusLastInd,1);
mlib.markers{2,1}=cluster_class(Rec1ClusLastInd+1:length(cluster_class),1);
mlib.markers{3,1}=cluster_class(:,1); %1st and 2nd recording continuous
else % Other than dOVT,only 1 recording
mlib.timings{1,1}=0.001*cluster_class(:,2); %TIMINGS for spike graph
mlib.timings{3,1}=mlib.timings{1,1}; %TIMINGS for spike quality check
mlib.markers{1,1}=cluster_class(:,1);%MARKERS for spike graph
mlib.markers{3,1}=mlib.markers{1,1};%MARKERS for spike quality check
end

%Let's save dtid as a .mat file
flnm2=input('input like SC_Rat#LR_Depth(um)_','s');
dtid=input('input like yy_mm_dd_HH_MM','s');% DATA_ID for saving as mlib converted file 
fl_title=[flnm2 'Ttrd1V_' dtid 'mlib' flext];
save(fl_title, 'mlib');

%% Spike quality check using  mcheck2, 
q=input('please input the total number of clusters you want to analyze');
channel=zeros(q,1);
for i=1:q
   r=input('please specify the clusterID of this cluster'); %for example, r=2&5
   channel(q)= input('the channel Alphabet (capital) where the signal is the most intense','s');
   
dtpt=60;% 25000 Hz,0.04ms per 1point, pre=20points=0.8ms. post=40points=1.6ms, total=60points
%Let's make ADC (Analog to Digital Conversion) matrix where (data points, #th spike)are described
if channel(q)=='A'
adc_bfr{q,1}=spikes(:,1:dtpt);
elseif channel(q)=='B'
adc_bfr{q,1}=spikes(:,dtpt+1:dtpt*2);
elseif channel(q)=='C'
adc_bfr{q,1}=spikes(:,dtpt*2+1:dtpt*3);
elseif channel(q)=='D'
adc_bfr{q,1}=spikes(:,dtpt*3+1:dtpt*4);
end
mlib.adc{q,1}=adc_bfr{q,1}.';
%Spike quality check for both 1st and 2nd recording or the entire recording
mcheck2(mlib.adc{q,1},'markvec',mlib.markers{3,1},'target',r,'timevec',mlib.timings{3,1},'tevents',EvtTS_secEs{3,1}); 

%% Show Filtered Wave of Each Cluster   
%Let's open the file which is the result of Do_clustering(1) of wave_clus;
load(['Ttrd1V_' channel(q) dtid flext]); %load('Ttrd1V_D17_05_01_02_51.mat');%cluster 1 was in channelD this time

% If the sampling rate is 25000Hz and the cut off frequency is 350Hz,its normalized cut off frequency is f=350/25000.
[b,a]=butter(2,350/25000,'high');
fltdt=filter(b,a,data);
figure(1); %Come back to the same figure
ax1=subplot(2*q,1,i);%ax1=subplot(4,1,1);%when total clusters are 2
plot(fltdt,'color','k');
ylim([-0.1 0.1]);
xlim([0 length(data)]);
ax=gca;
axticks2=0:250000:length(data); %My sampling rate is 25000Hz,Let's label the X axis every 10 seconds!
set(ax, 'XTick', axticks2);
set(ax, 'XTickLabel', 10*(0:length(axticks2)));

%% Show Raster for Each Cluster  
for k=1:j % j=input('Input 1 or 2. dOVT with 2 recording files=2, Others with 1 cording file =1');
%Let's make whole raster plots of each cluster, now cluster1
ax2=subplot(2*q,1,2*i);%ax2=subplot(4,1,2);%when total clusters are 2
spk_cls{k,1}{i,1}=mlib.timings{k,1}(mlib.markers{k,1}(:,1)==r); % k=1st or 2nd recording, i= #ith cluster out of q clusters
for k=1:length(spk_cls{k,1}{i,1})
    l1a=line([spk_cls{k,1}{i,1}(k) spk_cls{k,1}{i,1}(k)],[0.5 1.5],'color','b'); %l1a=line([spk_cls1(k) spk_cls1(k)],[0.5 1.5],'color','b');
end
 xlim([0 length(data)/25000]);

%% Raster for the spikes of each cluster
% mpsth2 uses pre=-100ms and post=900ms. "mlib.markers(:,1)==3" means that the 1st cluster is cluster number 3.
% k=1st or 2nd recording, i= #ith cluster out of q clusters
[psth{k,1}{i,1},trialspx1{k,1}{i,1}]=mpsth2(mlib.timings{k,1}(mlib.markers{k,1}(:,1)==r),EvtTS_secEs{k,1});
figure
for m=1:length(trialspx1{k,1}{i,1})
for n=1:length(trialspx1{k,1}{i,1}{m,1})
l1aR=line([trialspx1{k,1}{i,1}{m,1}(n,1) trialspx1{k,1}{i,1}{m,1}(n,1)],[m-1 m],'color','b');
end
end
ylim([0 350]);
line([0 0], [0 length(trialspx1{k,1}{i,1})], 'color','g');
line([20 20], [0 length(trialspx1{k,1}{i,1})], 'color','g');
line([90 90], [0 length(trialspx1{k,1}{i,1})], 'color','g');
line([300 300], [0 length(trialspx1{k,1}{i,1})], 'color','g');
line([800 800], [0 length(trialspx1{k,1}{i,1})], 'color','g');
line([-100 900], [BLstIND(k,1) BLstIND(k,1)], 'color','c');%first spike timing within BL
line([-100 900], [BLedIND(k,1) BLedIND(k,1)], 'color','c');%last spike timing within BL
line([-100 900], [ES2stIND(k,1) ES2stIND(k,1)], 'color','y');%Recovery from non ES period, start time point of the 2nd ES for 60sec

%% C pooled histogram
for m=1:length(EvtTS_secEs{k,1})
    Cpooled1{k,1}{m,i}=trialspx1{k,1}{i,1}{m,1}(90<trialspx1{k,1}{i,1}{m,1} & trialspx1{k,1}{i,1}{m,1}<=800);
    Cpooled1spknbr{k,1}(m,i)=numel(Cpooled1{k,1}{m,i});
end
%Let's normalize to the average of 5 stimulations before blue light =100%
Cpld1_bfrBL(k,i)=(Cpooled1spknbr{k,1}(BLstIND(k,1)-5,i)+Cpooled1spknbr{k,1}(BLstIND(k,1)-4,i)+Cpooled1spknbr{k,1}(BLstIND(k,1)-3,i)+Cpooled1spknbr{k,1}(BLstIND(k,1)-2,i)+Cpooled1spknbr{k,1}(BLstIND(k,1)-1,i))/5;
%Let's normalize 
Cpld1spknbr_norm{k,1}{i,1}=(Cpooled1spknbr{k,1}(:,i)/Cpld1_bfrBL(k,i))*100;
figure
bar(Cpld1spknbr_norm{k,1}{i,1});
xlim([0 length(EvtTS_secEs{k,1})+1]);
ylim([0 ,max(Cpld1spknbr_norm{k,1}{i,1})+10]);
line([BLstIND(k,1)-0.5 BLstIND(k,1)-0.5],[0 ,max(Cpld1spknbr_norm{k,1}{i,1})+10],'color','c');
line([BLedIND(k,1)+0.5 BLedIND(k,1)+0.5],[0 ,max(Cpld1spknbr_norm{k,1}{i,1})+10],'color','c');
line([ES2stIND(k,1)-0.5 ES2stIND(k,1)-0.5],[0 ,max(Cpld1spknbr_norm{k,1}{i,1})+10],'color','y');
ylabel(['100%=' num2str(Cpld1_bfrBL(k,i)) 'spks/shock']);
xlabel('Cpooled');

%% A pooled histogram
for m=1:length(EvtTS_secEs{k,1}) 
    Apooled1{k,1}{m,i}=trialspx1{k,1}{i,1}{m,1}(0<=trialspx1{k,1}{i,1}{m,1} & trialspx1{k,1}{i,1}{m,1}<=90);
    % Abeta1{k,1}{m,i}=trialspx1{k,1}{i,1}{m,1}(0<=trialspx1{k,1}{i,1}{m,1} & trialspx1{k,1}{i,1}{m,1}<=20);
    % Adelta1{k,1}{m,i}=trialspx1{k,1}{m,1}(20<trialspx1{k,1}{i,1}{m,1} & trialspx1{k,1}{i,1}{m,1}<=90);
    % C1{k,1}{m,i}=trialspx1{k,1}{m,1}(90<trialspx1{k,1}{i,1}{m,1} & trialspx1{k,1}{i,1}{m,1}<=300);
    % Cdis1{k,1}{m,i}=trialspx1{k,1}{m,1}(300<trialspx1{k,1}{i,1}{m,1} & trialspx1{k,1}{i,1}{m,1}<=800);
    Apooled1spknbr{k,1}(m,i)=numel(Apooled1{k,1}{m,i});
end
%Let's normalize to Cpld1_bfrBL
Apld1spknbr_normC{k,1}{i,1}=(Apooled1spknbr{k,1}(:,i)/Cpld1_bfrBL(k,i))*100;
figure
bar(Apld1spknbr_normC{k,1}{i,1});
xlim([0 length(EvtTS_secEs{k,1})+1]);
ylim([0 ,max(Cpld1spknbr_norm{k,1}{i,1})+10]);
line([BLstIND(k,1)-0.5 BLstIND(k,1)-0.5],[0 ,max(Cpld1spknbr_norm{k,1}{i,1})+10],'color','c');
line([BLedIND(k,1)+0.5 BLedIND(k,1)+0.5],[0 ,max(Cpld1spknbr_norm{k,1}{i,1})+10],'color','c');
line([ES2stIND(k,1)-0.5 ES2stIND(k,1)-0.5],[0 ,max(Cpld1spknbr_norm{k,1}{i,1})+10],'color','y');
ylabel(['100%=' num2str(Cpld1_bfrBL(k,i)) 'spks/shock']);
xlabel('Apooled');

end
end
%% Let's clean up inside the Workspace
%clearvars -except mlib