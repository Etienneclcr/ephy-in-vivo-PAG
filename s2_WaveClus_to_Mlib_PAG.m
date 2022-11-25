% by Mai Iwasaki, August 2022
%This script refer to "EvtTS_secOp" and "times_polytrode1.mat".
NbrBLs=floor(length(EvtTS_secOp{1,1})/600); %Repeat of BL stimulation.600points corresponding to 20sec of 30Hz BL
BLstartList=zeros(NbrBLs,1);
for n=1:NbrBLs
  BLstartList(n,1)=EvtTS_secOp{1,1}((n-1)*600+1); %Time code of Blue light period's start.
end

%% Prepare the information in "mlib"to run the mlib function "markvec2" and "mpsth11".
polytrode_number='1';
flnm='times_polytrode';
flext='.mat';
%Let's open the file which is the result of Do_clustering(1) of wave_clus;
load([flnm polytrode_number flext]); 

%Let's make MARKERS (a list of cluster IDs of each single spike)where (cluster class, 1). 
markers=zeros(length(cluster_class(:,1)),4);
markers(:,1)=cluster_class(:,1);
mlib.markers=markers;

%Let's make TIMINGS where (timecode of spike in second, 1)
timings=cluster_class(:,2);
%Let's convert the numerical unit from "millisecond" to "second"!
mlib.timings=0.001*timings;

% %Let's make EVENT TIMINGS, Here, OptoLaser, EvtTS_secOp!
mlib.eventtimings1=EvtTS_secOp{1,1};
% %Let's make EVENT MARKERS,
mlib.eventmarkers1=ones(length(EvtTS_secOp{1,1}),1);

% %Let's make EVENT TIMINGS, Here, Electric Shock, EvtTS_secEs!
% mlib.eventtimings2=EvtTS_secEs;
% %Let's make EVENT MARKERS,
% mlib.eventmarkers2=ones(length(EvtTS_secEs),1);

%Let's save dtid as a .mat file
dtid=input('input like PAG_Rat#_DEPTHum_TtrdV_yy_mm_dd_HH_MM','s');% DATA_ID for saving as mlib converted file  
fl_title=[dtid 'mlib' flext];
save(fl_title, 'mlib');

%% Spike quality check using  mcheck2
q=input('please input the total number of clusters you want to analyze');
channel=zeros(q,1);
for i=1:q
   r=input('please specify the clusterID of this cluster');
   channel(q)= input('the channel alphabet where the signal is the most intense','s');
   
dtpt=60;% 25000 Hz,0.04ms per 1point, pre=20points=0.8ms. post=40points=1.6ms, total=60points
%Let's make ADC (Analog to Digital Conversion) matrix where (data points, #th spike)are described
if channel(q)=='a'
adc_bfr{q,1}=spikes(:,1:dtpt);
elseif channel(q)=='b'
adc_bfr{q,1}=spikes(:,dtpt+1:dtpt*2);
elseif channel(q)=='c'
adc_bfr{q,1}=spikes(:,dtpt*2+1:dtpt*3);
elseif channel(q)=='d'
adc_bfr{q,1}=spikes(:,dtpt*3+1:dtpt*4);
end
mlib.adc{q,1}=adc_bfr{q,1}.';

mcheck2(mlib.adc{q,1},'markvec',mlib.markers,'target',r,'timevec',mlib.timings); %Spike quality check

%% Count spikes per 1 bin between  -100 to +300sec 
for n=1:NbrBLs
%mpsth11 uses pre=-100000ms(-100sec) and post=300000ms(BL20sec+post580sec=10min)
% trialspxHist is the time code of spike between the defined time period
[psth, trialspxHist{n,i}]=mpsth11(mlib.timings(mlib.markers(:,1)==r),BLstartList(n,1));

Spknbr{n,i}=zeros(1,400);%Histogram #spk/sec from -100 to +300sec relative to BLstart timing
for m=1:400
%   1sec bin= 1000msec (1sec) bin for 400 times
histposi_st=-100000+1000*(m-1); %FIRST HISTGRAM IS -100SEC before BL
histposi_ed=-100000+1000*m;
Spknbr{n,i}(1,m)=numel(trialspxHist{n,i}(trialspxHist{n,i}<histposi_ed & trialspxHist{n,i}>=histposi_st));%Spknbr(1,m)=numel(trialspxHist{1,1}(trialspxHist{1,1}<histposi_ed & trialspxHist{1,1}>=histposi_st));
end

%% Put Blue Color in the period of BL in the histogram
figure
%for n=1:NbrBLs
 if n==1
    Square_coloring([100,120],[max(max(Spknbr{n,i})) max(max(Spknbr{n,i}))],0,[0.8 1 1]); 
     hold on
 else 
     sqcol_st=100+(BLstartList(n,1)-BLstartList(n-1,1));
     sqcol_ed=sqcol_st+20;
     Square_coloring([sqcol_st,sqcol_ed],[max(max(Spknbr{n,i})) max(max(Spknbr{n,i}))],0,[0.8 1 1]); 
    hold on
 end
%end

%% Draw the Histogram
bar(Spknbr{n,i},0.8, 'FaceColor', [0 0.5 1],'EdgeColor',[0 0.5 1],'LineWidth',0.1);%0.8 percent of full widths bin
set(0,'DefaultAxesLineWidth', 2); % axis width
xlim([0 400]);
ylim([0 max(max(Spknbr{n,i}))]);   

ax=gca;
set(ax,'xtick',[0 100 120 200 300 400]);
set(ax,'xticklabel',{'-100','0','20','100','200','300'});
set(ax,'ytick',[5 10 20 30]);
xlabel('Time (sec)','Fontsize', 35); % x-axis label
ylabel('Frequency (Hz)','Fontsize', 35) % y-axis label

set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(ax, 'Fontsize', 20); 
set(ax,'Ticklength',[0.02 0]);
set(ax,'TickDir', 'out');
hold off
end
end
