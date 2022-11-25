% by Mai Iwasaki, August 2022
load('SpinalCord_String.mat');
%% Preparation for the mean curve of the 1st 290 sec
for j=1:3 % 1=WT, 2=ChR2, 3=dOVT
    if j==1
     Rawdata=WTString;
    elseif j==2
     Rawdata=ChR2String;
     elseif j==3
     Rawdata=dOVTVhr2String;
    end 
Cf290{1,j}=zeros(size(Rawdata,1),290);
for i=1:length(Rawdata)
    for k=1:290
    Cf290{1,j}(i,k)=numel(Rawdata{i,4}{k,1}(90<=Rawdata{i,4}{k,1} & Rawdata{i,4}{k,1}<800)); %First 290 sec C fiber series 90-800msec 
    %Cf290{1,j}(i,k)=numel(Rawdata{i,4}{k,1}(0<=Rawdata{i,4}{k,1} & Rawdata{i,4}{k,1}<20)); %Ab fiber
    %Cf290{1,j}(i,k)=numel(Rawdata{i,4}{k,1}(20<=Rawdata{i,4}{k,1} & Rawdata{i,4}{k,1}<90));%Ad fiber 
    end
% To find the highest c fiber derived activity percentage for each rat,
Cf290{2,j}{i,1}=smooth(Cf290{1,j}(i,:),21,'moving'); % window size 21
Cf290{3,j}(i,1)=max(Cf290{2,j}{i,1}(1:130,1)); % Peak should come before 130sec     
Cf290{3,j}(i,2)=find(Cf290{2,j}{i,1}(1:130,1)==Cf290{3,j}(i,1),1);
% percent Cf discharge
for k=1:290
     Cf290{4,j}(i,k)=Cf290{1,j}(i,k)*100/Cf290{3,j}(i,1); %original/smoothed
     Cf290{5,j}(i,k)=Cf290{2,j}{i,1}(k,1)*100/Cf290{3,j}(i,1);% smoothed/smoothed
end

%Lowest, 40:280 means to remove the low value before 40sec of wind up and
% smoothing cannot smooth at the last edge smaller than the half window size, 10.
Cf290{3,j}(i,3)=min(Cf290{2,j}{i,1}(40:280,1));   
% find(A,1) this 1 ,means the first answer of find, 
% but now index 1=index40 of WT290Cf_smooth{i,1},so have to plus 39
Cf290{3,j}(i,4)=find(Cf290{2,j}{i,1}(40:280,1)==Cf290{3,j}(i,3),1)+39; 

% half reduction
Cf290{3,j}(i,5)=(Cf290{3,j}(i,1)+Cf290{3,j}(i,3))/2;
% [IDX,D]=knnsearch(X,Y); Y's nearlest value in X, D=Y-X
% Cf290{3,j}(i,5) can be used as half reduction latency
% the latency should exist between peak latency; Cf290{3,j}(i,2) and lowest latency; Cf290{3,j}(i,4)
[Cf290{3,j}(i,6),Cf290{3,j}(i,7)]=knnsearch(Cf290{2,j}{i,1}(Cf290{3,j}(i,2):Cf290{3,j}(i,4),1),Cf290{3,j}(i,5));
% and to return to original index, have to plus  (WT290Cf_sm_maxmin(i,2)-1)
Cf290{3,j}(i,8)=Cf290{3,j}(i,6)+(Cf290{3,j}(i,2)-1);

% Generally lowest time period 140 to 180 sec=180 to 220 th data of smooth.
%dOVT drops the value after this period,and its value gets closer to ChR2.
Cf290{3,j}(i,9)=100*(1-(mean(Cf290{2,j}{i,1}(180:220,1))/Cf290{3,j}(i,1)));
% real lowest for each neuron
Cf290{3,j}(i,10)=100*(1-(Cf290{3,j}(i,3)/Cf290{3,j}(i,1)));

% In the 1st recording, generally highest time period -10 to +10 sec=30 to 50 th data of smooth
Cf290{3,j}(i,11)=100*(1-(mean(Cf290{2,j}{i,1}(30:50,1))/Cf290{3,j}(i,1)));
end
end

%% Mean Curve of the 1st recording
figure
set(0,'defaultAxesLineWidth', 1.0); 
for j=1:3
CfPerc_plot{1,j}=mean(Cf290{5,j},1);% Average value to plot
CfPerc_plot{2,j}=smooth(CfPerc_plot{1,j},21,'moving').' ;% transpose
CfPerc_plot{3,j}=std(Cf290{5,j},0,1)/sqrt(size(Cf290{5,j},1));% standard error of the mean, 0=normalize with N-1
CfPerc_plot{4,j}=smooth(CfPerc_plot{3,j},21,'moving').' ;% transpose
xfill=1:size(CfPerc_plot{1,j},2);%2=std to vertical direction for 290 data points
x = linspace(1,290,290);
if j==1
    h=fill([xfill fliplr(xfill)],[CfPerc_plot{2,j}+CfPerc_plot{4,j} fliplr(CfPerc_plot{2,j}-CfPerc_plot{4,j})],[0.5 0.5 0.5],'linestyle','none');
    set(h,'facealpha',.25);
    hold on
    plot(x,CfPerc_plot{2,j}(1,:),'LineWidth',1,'Color',[0.5 0.5 0.5]);
    elseif j==2
    h=fill([xfill fliplr(xfill)],[CfPerc_plot{2,j}+CfPerc_plot{4,j} fliplr(CfPerc_plot{2,j}-CfPerc_plot{4,j})],[0 0.5 1],'linestyle','none'); 
    set(h,'facealpha',.25);
    hold on
    plot(x,CfPerc_plot{2,j}(1,:),'LineWidth',1,'Color',[0 0.5 1]);
    elseif j==3
    h=fill([xfill fliplr(xfill)],[CfPerc_plot{2,j}+CfPerc_plot{4,j} fliplr(CfPerc_plot{2,j}-CfPerc_plot{4,j})],[1 0.2 0.2],'linestyle','none');   
    set(h,'facealpha',.25);
    hold on
    plot(x,CfPerc_plot{2,j}(1,:),'LineWidth',1,'Color',[1 0.2 0.2]);
end
end
Square_coloring([40 60],[100 100],0,[0.8 1 1]);

ax=gca;
xlim(ax,[0 290]);
ylim(ax,[0 100]);
set(ax,'xtick',[1 40 60 90 140 190 240 290]);
set(ax,'xticklabel',{'-40','0','20','50','100','150','200','250'});
set(ax,'ytick',[0 10 20 30 40 50 60 70 80 90 100]);
set(ax,'yticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
xlabel('# of shock (@1Hz)relative to BL','Fontsize', 20); % x-axis label
ylabel('% to plateau spike rate','Fontsize', 20); % y-axis label

% convert it to be transparent
set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(ax,'Color','none');
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');
hold off

%% Preparation for the mean curve of the 2nd 60 sec
for j=1:3 % 1=WT, 2=ChR2, 3=dOVT
    if j==1
     Rawdata=WTString;
    elseif j==2
     Rawdata=ChR2String(1:14,1:5);
     elseif j==3
     Rawdata=dOVTVhr2String;
    end 
Cf60{1,j}=zeros(size(Rawdata,1),60);
for i=1:length(Rawdata)
    for k=1:60
     Cf60{1,j}(i,k)=numel(Rawdata{i,5}{k,1}(90<=Rawdata{i,5}{k,1} & Rawdata{i,5}{k,1}<800));%Second 60 sec C fiber series 90-800msec 
    %Cf60{1,j}(i,k)=numel(Rawdata{i,5}{k,1}(0<=Rawdata{i,5}{k,1} & Rawdata{i,5}{k,1}<20)); %Ab fiber 
    %Cf60{1,j}(i,k)=numel(Rawdata{i,5}{k,1}(20<=Rawdata{i,5}{k,1} & Rawdata{i,5}{k,1}<90)); %Ad fiber 
    end
    %To find the highest c fiber derived activity percentage for each rat
    Cf60{2,j}{i,1}=smooth(Cf60{1,j}(i,:),21,'moving');%window size 21
    Cf60{3,j}(i,1)=max(Cf60{2,j}{i,1}(1:50,1)); %Peak should come before 60sec, Smoothing artifact might appear after 50sec.    
    Cf60{3,j}(i,2)=find(Cf60{2,j}{i,1}(1:50,1)==Cf60{3,j}(i,1),1);
% percent Cf discharge
for k=1:60
    %Max value is refererd to the first 290 sec of recording
     Cf60{4,j}(i,k)=Cf60{1,j}(i,k)*100/Cf290{3,j}(i,1);%original/smoothed
     Cf60{5,j}(i,k)=Cf60{2,j}{i,1}(k,1)*100/Cf290{3,j}(i,1);% smoothed/smoothed
end
% In the 2nd recording, generally highest time period -10 to +10 sec=30 to 50 th data of smooth
Cf60{3,j}(i,3)=100*(1-(mean(Cf60{2,j}{i,1}(30:50,1))/Cf290{3,j}(i,1)));
end
end

%% Mean Curve of the 2nd recording
figure
for j=1:3
CfPerc_plot60{1,j}=mean(Cf60{5,j},1);% Average value to plot
CfPerc_plot60{2,j}=smooth(CfPerc_plot60{1,j},21,'moving').' ;% transpose
CfPerc_plot60{3,j}=std(Cf60{5,j},0,1)/sqrt(size(Cf60{5,j},1));% standard error of the mean, 0=normalize with N-1
CfPerc_plot60{4,j}=smooth(CfPerc_plot60{3,j},21,'moving').' ;% transpose
xfill60=1:size(CfPerc_plot60{1,j},2);%2=std to vertical direction for 60 data points
x60 = linspace(1,60,60);
xfill60=1:size(CfPerc_plot60{1,j},2);%2=std to vertical direction for 60 data points
if j==1
    h60=fill([xfill60 fliplr(xfill60)],[CfPerc_plot60{2,j}+CfPerc_plot60{4,j} fliplr(CfPerc_plot60{2,j}-CfPerc_plot60{4,j})],[0.5 0.5 0.5],'linestyle','none');
    set(h60,'facealpha',.25);
    hold on
    plot(x60,CfPerc_plot60{2,j}(1,:),'LineWidth',1,'Color',[0.5 0.5 0.5]);
    elseif j==2
    h60=fill([xfill60 fliplr(xfill60)],[CfPerc_plot60{2,j}+CfPerc_plot60{4,j} fliplr(CfPerc_plot60{2,j}-CfPerc_plot60{4,j})],[0 0.5 1],'linestyle','none'); 
    set(h60,'facealpha',.25);
    hold on
    plot(x60,CfPerc_plot60{2,j}(1,:),'LineWidth',1,'Color',[0 0.5 1]);
    elseif j==3
    h60=fill([xfill60 fliplr(xfill60)],[CfPerc_plot60{2,j}+CfPerc_plot60{4,j} fliplr(CfPerc_plot60{2,j}-CfPerc_plot60{4,j})],[1 0.2 0.2],'linestyle','none');   
    set(h60,'facealpha',.25);
    hold on
    plot(x60,CfPerc_plot60{2,j}(1,:),'LineWidth',1,'Color',[1 0.2 0.2]);
end
end

ax=gca;
xlim(ax,[0 50]);
ylim(ax,[0 100]);
set(ax,'xtick',[1 40]);
set(ax,'xticklabel',{'1','40'});
set(ax,'ytick',[0 10 20 30 40 50 60 70 80 90 100]);
set(ax,'yticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');

% convert it to be transparent
set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(ax,'Color','none');
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');
hold off

%% Lowest in the 1st recording, bar graph
lillieWTlowact=lillietest(Cf290{3,1}(:,9)); %not normal distribbution
lillieChR2lowact=lillietest(Cf290{3,2}(:,9)); %not normal distribbution
lilliedOVTlowact=lillietest(Cf290{3,3}(:,9));%not normal distribbution
[pWCefct,hWCefct,statsWCefct] = ranksum(Cf290{3,1}(:,9),Cf290{3,2}(:,9));%nonparametric,WTvsChR2 ranksum p=0.0074 significant 
ChR2_of_dOVT=[Cf290{3,2}(10:13,9);Cf290{3,2}(15,9);Cf290{3,2}(14,9)];%To do paired test, pick up only ChR2 corresponding to dOVT
[pCDefct,hCDefct,statsCDefct] = signrank(ChR2_of_dOVT,Cf290{3,3}(:,9));%nonparametric,paired,dOVTvsChR2 signrank p=0.0313 significant

figure %Lowest bar graph
for j=1:3
SC_low(1,j)=mean(Cf290{3,j}(:,9));% mean of lowest activity percent
SC_low(2,j)=std(Cf290{3,j}(:,9))/sqrt(size(Cf290{3,j}(:,9),1));% SEM of lowest activity percent
set(0,'defaultAxesLineWidth', 2.0); % figure discharge reduction
    if j==1
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_low(1,j) SC_low(1,j) 0],[0.5 0.5 0.5],'FaceAlpha',0.8,'EdgeColor','none');
    Pl_posX=[0.97 1 1 1 1 1.03 1 1]; % Pl_posX=ones(length(Cf290{3,j}(:,9)),1)*j;
    elseif j==2
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_low(1,j) SC_low(1,j) 0],[0 0.5 1],'FaceAlpha',0.8,'EdgeColor','none');
Pl_posX=[1.97 2 2.03 2.03 1.97 1.97 2 2 2 1.97 2 2 2 2 2];
    elseif j==3
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_low(1,j) SC_low(1,j) 0],[1 0.2 0.2],'FaceAlpha',0.8,'EdgeColor','none');  
    Pl_posX=[2.97 3 3.03 2.97 3 3.03];
    end
hold on
line([-0.05+j 0.05+j],[SC_low(1,j)-SC_low(2,j), SC_low(1,j)-SC_low(2,j)],'Color',[0,0,0]);
line([-0.05+j 0.05+j],[SC_low(1,j)+SC_low(2,j), SC_low(1,j)+SC_low(2,j)],'Color',[0,0,0]);
line([j j],[SC_low(1,j)-SC_low(2,j), SC_low(1,j)+SC_low(2,j)],'Color',[0,0,0]);
Pl_posY=Cf290{3,j}(:,9);
plot(Pl_posX,Pl_posY,'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
end

ax=gca;
xlim(ax,[0.5 3.5]);
ylim(ax,[0 100]);
set(ax,'xtick',[1 2 3]);
set(ax,'xticklabel',{'WT','ChR2','dOVT'});
set(ax,'XAxisLocation','top' );
set(ax,'ytick',[0 10 20 30 40 50 60 70 80 90 100]);
set(ax,'yticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
set(ax,'YDir','reverse');
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
ylabel('reduction discharge(%)','Fontsize', 20); % y-axis label

% convert it to be transparent
set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');
hold off

%% Highest in the first recording, bar graph
lillieWThighact=lillietest(Cf290{3,1}(:,11)); %normal distribbution!
lillieChR2highact=lillietest(Cf290{3,2}(:,11)); %normal distribbution!
lilliedOVThighact=lillietest(Cf290{3,3}(:,11));%NOT normal distribbution
[hWCefctH,pWCefctH] = ttest2(Cf290{3,1}(:,11),Cf290{3,2}(:,11));%parametric, nonpaired ttest,WTvsChR2 unpaired t p=0.1493 NOT significant 
ChR2_of_dOVTH=[Cf290{3,2}(10:13,11);Cf290{3,2}(15,11);Cf290{3,2}(14,11)];%To do paired test, pick up only ChR2 corresponding to dOVT
[pCDefctH,hCDefctH,statsCDefctH] = signrank(ChR2_of_dOVTH,Cf290{3,3}(:,11));%nonparametric, paired, dOVTvsChR2 signrank p=0.6875 NOT significant

figure  %Highest in the first recording, bar graph
for j=1:3
SC_high(1,j)=mean(Cf290{3,j}(:,11));% mean of highest activity percent
SC_high(2,j)=std(Cf290{3,j}(:,11))/sqrt(size(Cf290{3,j}(:,11),1));% SEM of highest activity percent
set(0,'defaultAxesLineWidth', 2.0); % figure discharge reduction
    if j==1
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_high(1,j) SC_high(1,j) 0],[0.5 0.5 0.5],'FaceAlpha',0.8,'EdgeColor','none');
    Pl_posX=[0.97 1 1 1 1 1.03 1 1];% Pl_posX=ones(length(Cf290{3,j}(:,9)),1)*j;
    elseif j==2
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_high(1,j) SC_high(1,j) 0],[0 0.5 1],'FaceAlpha',0.8,'EdgeColor','none');
Pl_posX=[1.97 2 2.03 2.03 1.97 1.97 2 2 2 1.97 2 2 2 2 2];
    elseif j==3
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_high(1,j) SC_high(1,j) 0],[1 0.2 0.2],'FaceAlpha',0.8,'EdgeColor','none');  
    Pl_posX=[2.97 3 3.03 2.97 3 3.03];
    end
hold on
line([-0.05+j 0.05+j],[SC_high(1,j)-SC_high(2,j), SC_high(1,j)-SC_high(2,j)],'Color',[0,0,0]);
line([-0.05+j 0.05+j],[SC_high(1,j)+SC_high(2,j), SC_high(1,j)+SC_high(2,j)],'Color',[0,0,0]);
line([j j],[SC_high(1,j)-SC_high(2,j), SC_high(1,j)+SC_high(2,j)],'Color',[0,0,0]);
Pl_posY=Cf290{3,j}(:,11);
plot(Pl_posX,Pl_posY,'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
end

ax=gca;
xlim(ax,[0.5 3.5]);
ylim(ax,[0 100]);
set(ax,'xtick',[1 2 3]);
set(ax,'xticklabel',{'WT','ChR2','dOVT'});
set(ax,'XAxisLocation','top' );
set(ax,'ytick',[0 10 20 30 40 50 60 70 80 90 100]);
set(ax,'yticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
set(ax,'YDir','reverse');
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
ylabel('reduction discharge(%)','Fontsize', 20); % y-axis label

% convert it to be transparent
set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');
hold off

%% Highest in the 2nd recording, bar graph
lillieWThighact2=lillietest(Cf60{3,1}(:,3)); %NOT normal distribbution!
lillieChR2highact2=lillietest(Cf60{3,2}(:,3)); %NOT normal distribbution!
lilliedOVThighact2=lillietest(Cf60{3,3}(:,3));%NOT normal distribbution
[pWCefctH2,hWCefctH2,statsWCefctH2] = ranksum(Cf60{3,1}(:,3),Cf60{3,2}(:,3));%nonparametric,WTvsChR2 ranksum    p=0.1423 NOT significant 
ChR2_of_dOVTH2=[Cf60{3,2}(10:13,3);Cf60{3,2}(14,3)];%To do paired test, pick up only ChR2 corresponding to dOVT
dOVTH2=[Cf60{3,3}(1:4,3);Cf60{3,3}(6,3)];
[pCDefctH2,hCDefctH2,statsCDefctH2] = signrank(ChR2_of_dOVTH2,dOVTH2);%nonparametric, paired,dOVTvsChR2 signrank p=0.125  NOT significant

figure  %Highest in the 2nd recording, bar graph
for j=1:3
SC_high2(1,j)=mean(Cf60{3,j}(:,3));% mean of highest activity percent
SC_high2(2,j)=std(Cf60{3,j}(:,3))/sqrt(size(Cf60{3,j}(:,3),1));% SEM of highest activity percent
set(0,'defaultAxesLineWidth', 2.0); % figure discharge reduction
    if j==1
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_high2(1,j) SC_high2(1,j) 0],[0.5 0.5 0.5],'FaceAlpha',0.8,'EdgeColor','none');
    Pl_posX=[0.97 1 1 1 1 1.03 1 1];%     Pl_posX=ones(length(Cf60{3,j}(:,9)),1)*j;
    elseif j==2
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_high2(1,j) SC_high2(1,j) 0],[0 0.5 1],'FaceAlpha',0.8,'EdgeColor','none');
Pl_posX=[1.97 2 2.03 2.03 1.97 1.97 2 2 2 1.97 2 2 2 2];
    elseif j==3
h=patch([j-0.25 j-0.25 j+0.25 j+0.25], [0 SC_high2(1,j) SC_high2(1,j) 0],[1 0.2 0.2],'FaceAlpha',0.8,'EdgeColor','none');  
    Pl_posX=[2.97 3 3.03 2.97 3 3.03];
    end
hold on
line([-0.05+j 0.05+j],[SC_high2(1,j)-SC_high2(2,j), SC_high2(1,j)-SC_high2(2,j)],'Color',[0,0,0]);
line([-0.05+j 0.05+j],[SC_high2(1,j)+SC_high2(2,j), SC_high2(1,j)+SC_high2(2,j)],'Color',[0,0,0]);
line([j j],[SC_high2(1,j)-SC_high2(2,j), SC_high2(1,j)+SC_high2(2,j)],'Color',[0,0,0]);
Pl_posY=Cf60{3,j}(:,3);
plot(Pl_posX,Pl_posY,'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
end

ax=gca;
xlim(ax,[0.5 3.5]);
ylim(ax,[0 100]);
set(ax,'xtick',[1 2 3]);
set(ax,'xticklabel',{'WT','ChR2','dOVT'});
set(ax,'XAxisLocation','top' );
set(ax,'ytick',[0 10 20 30 40 50 60 70 80 90 100]);
set(ax,'yticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
set(ax,'YDir','reverse');
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
ylabel('reduction discharge(%)','Fontsize', 20); % y-axis label

% convert it to be transparent
set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');
hold off

%% Box Whisker Plot
figure
for j=1:2   % remove dOVT because its kinetics is affected by dOVT diffusion
%     plateau
halfred_stat(1,j)=max(Cf290{3,j}(:,2));% max 
halfred_stat(2,j)=min(Cf290{3,j}(:,2));% min 
halfred_stat(3,j)=median(Cf290{3,j}(:,2));% median
halfred_stat(4,j)=mean(Cf290{3,j}(:,2));% mean
halfred_stat(5,j)=quantile(Cf290{3,j}(:,2),0.25);% 1st quantile
halfred_stat(6,j)=quantile(Cf290{3,j}(:,2),0.75);% 3rd quantile
%     half
halfred_stat(7,j)=max(Cf290{3,j}(:,8));% max 
halfred_stat(8,j)=min(Cf290{3,j}(:,8));% min 
halfred_stat(9,j)=median(Cf290{3,j}(:,8));% median
halfred_stat(10,j)=mean(Cf290{3,j}(:,8));% mean
halfred_stat(11,j)=quantile(Cf290{3,j}(:,8),0.25);% 1st quantile
halfred_stat(12,j)=quantile(Cf290{3,j}(:,8),0.75);% 3rd quantile
%     bottom
halfred_stat(13,j)=max(Cf290{3,j}(:,4));% max 
halfred_stat(14,j)=min(Cf290{3,j}(:,4));% min 
halfred_stat(15,j)=median(Cf290{3,j}(:,4));% median
halfred_stat(16,j)=mean(Cf290{3,j}(:,4));% mean
halfred_stat(17,j)=quantile(Cf290{3,j}(:,4),0.25);% 1st quantile
halfred_stat(18,j)=quantile(Cf290{3,j}(:,4),0.75);% 3rd quantile

set(0,'defaultAxesLineWidth', 2.0); 
% patch of 1st and 3rd quantile
if j==1 % 1=WT, 2=ChR2,
h1=patch([halfred_stat(5,j)  halfred_stat(6,j) halfred_stat(6,j) halfred_stat(5,j)],[j-0.25 j-0.25 j+0.25 j+0.25] ,[0.5 0.5 0.5],'FaceAlpha',0.8,'EdgeColor','none'); %plateau
h2=patch([halfred_stat(11,j)  halfred_stat(12,j) halfred_stat(12,j) halfred_stat(11,j)],[j-0.25+2 j-0.25+2 j+0.25+2 j+0.25+2] ,[0.5 0.5 0.5],'FaceAlpha',0.8,'EdgeColor','none'); %half
h3=patch([halfred_stat(17,j)  halfred_stat(18,j) halfred_stat(18,j) halfred_stat(17,j)],[j-0.25+4 j-0.25+4 j+0.25+4 j+0.25+4] ,[0.5 0.5 0.5],'FaceAlpha',0.8,'EdgeColor','none'); %bottom  
elseif j==2
h1=patch([halfred_stat(5,j)  halfred_stat(6,j) halfred_stat(6,j) halfred_stat(5,j)],[j-0.25 j-0.25 j+0.25 j+0.25],[0 0.5 1],'FaceAlpha',0.8,'EdgeColor','none'); %plateau
h2=patch([halfred_stat(11,j)  halfred_stat(12,j) halfred_stat(12,j) halfred_stat(11,j)],[j-0.25+2 j-0.25+2 j+0.25+2 j+0.25+2] ,[0 0.5 1],'FaceAlpha',0.8,'EdgeColor','none'); %half  
h3=patch([halfred_stat(17,j)  halfred_stat(18,j) halfred_stat(18,j) halfred_stat(17,j)],[j-0.25+4 j-0.25+4 j+0.25+4 j+0.25+4] ,[0 0.5 1],'FaceAlpha',0.8,'EdgeColor','none'); %bottom  
end
hold on

%Plateau Lines
plot (halfred_stat(4,j),j,'+','LineWidth',0.1,'MarkerEdgeColor',[0 0 0],'MarkerSize',6);% mean
line([halfred_stat(3,j), halfred_stat(3,j)],[-0.25+j 0.25+j],'Color',[0,0,0]);% median
line([halfred_stat(1,j),halfred_stat(1,j)],[-0.05+j 0.05+j],'Color',[0,0,0]);% max end
line([halfred_stat(6,j),halfred_stat(1,j)],[j j],'Color',[0,0,0]);% 3rd quantile to max
line([halfred_stat(2,j),halfred_stat(2,j)],[-0.05+j 0.05+j],'Color',[0,0,0]);% min end
line([halfred_stat(5,j),halfred_stat(2,j)],[j j],'Color',[0,0,0]);% 1st quantile to min
%Plateau Dots
Pl_posX=Cf290{3,j}(:,2);
if j==1
Pl_posY=[0.97 1.03 0.97 1.03 1.03 1 1 1];% Pl_posY=ones(length(Pl_posX),1)*j;
elseif j==2
Pl_posY=[2 2.03 1.97 1.97 1.97 2 2 2 1.97 2.03 2 2 2.03 2 2.03 ];    
end
plot(Pl_posX,Pl_posY,'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);

%Half Lines
plot (halfred_stat(10,j),j+2,'+','LineWidth',0.1,'MarkerEdgeColor',[0 0 0],'MarkerSize',6);% mean
line([halfred_stat(9,j), halfred_stat(9,j)],[-0.25+j+2 0.25+j+2],'Color',[0,0,0]);% median
line([halfred_stat(7,j),halfred_stat(7,j)],[-0.05+j+2 0.05+j+2],'Color',[0,0,0]);% max end
line([halfred_stat(12,j),halfred_stat(7,j)],[j+2 j+2],'Color',[0,0,0]);% 3rd quantile to max
line([halfred_stat(8,j),halfred_stat(8,j)],[-0.05+j+2 0.05+j+2],'Color',[0,0,0]);% min end
line([halfred_stat(11,j),halfred_stat(8,j)],[j+2 j+2],'Color',[0,0,0]);% 1st quantile to min
%Half Dots
Pl_posX=Cf290{3,j}(:,8);
if j==1
Pl_posY=ones(length(Pl_posX),1)*(j+2);
elseif j==2
Pl_posY=[4 4 3.97 3.97 4.03 4 4 4 3.97 4 4.03 4 4 4.03 4];    
end
plot(Pl_posX,Pl_posY,'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);

%Bottom Lines
plot (halfred_stat(16,j),j+4,'+','LineWidth',0.1,'MarkerEdgeColor',[0 0 0],'MarkerSize',6);% mean
line([halfred_stat(15,j), halfred_stat(15,j)],[-0.25+j+4 0.25+j+4],'Color',[0,0,0]);% median
line([halfred_stat(13,j),halfred_stat(13,j)],[-0.05+j+4 0.05+j+4],'Color',[0,0,0]);% max end
line([halfred_stat(18,j),halfred_stat(13,j)],[j+4 j+4],'Color',[0,0,0]);% 3rd quantile to max
line([halfred_stat(14,j),halfred_stat(14,j)],[-0.05+j+4 0.05+j+4],'Color',[0,0,0]);% min end
line([halfred_stat(17,j),halfred_stat(14,j)],[j+4 j+4],'Color',[0,0,0]);% 1st quantile to min
%Bottom Dots
Pl_posX=Cf290{3,j}(:,4);
if j==1
Pl_posY=[4.97 5.03 5 5 5 5 5 5];% Pl_posY=ones(length(Pl_posX),1)*(j+4);
elseif j==2
Pl_posY=[6 6 5.97 5.97 6 6 6.03 6 6.03 6 6 6 5.97 6 6.03];    
end
plot(Pl_posX,Pl_posY,'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);

end

Square_coloring([40 60],[100 100],0,[0.8 1 1]);
ax=gca;
xlim(ax,[0 290]);
ylim(ax,[0.5 6.5]);
set(ax,'xtick',[1 40 60 90 140 190 240 290]);
set(ax,'xticklabel',{'-40','0','20','50','100','150','200','250'});
set(ax,'ytick',[1 2 3 4 5 6]);
set(ax,'yticklabel',{'WT_max','ChR2_max','WT_half','ChR2_half','WT_min','ChR2_min'});
set(ax,'xtick',[1 40 60 90 140 190 240 290]);
set(ax,'xticklabel',{'-40','0','20','50','100','150','200','250'});
set(ax,'YDir','reverse');
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
xlabel('latency (sec)','Fontsize', 20); % x-axis label

% convert it to be transparent
% set(ax, 'XColor', [0 0 0]);
% set(ax, 'YColor', [0 0 0]);

%To prove no difference between WT and ChR2
lillieWTmax=lillietest(Cf290{3,1}(:,2));
lilieChR2max=lillietest(Cf290{3,2}(:,2));
[pmax,hmax,statsmax] = ranksum(Cf290{3,1}(:,2),Cf290{3,2}(:,2));

lillieWThalf=lillietest(Cf290{3,1}(:,8));
lilieChR2half=lillietest(Cf290{3,2}(:,8));
[phalf,hhalf,statshalf] = ranksum(Cf290{3,1}(:,8),Cf290{3,2}(:,8));

lillieWTmin=lillietest(Cf290{3,1}(:,4));
lilieChR2min=lillietest(Cf290{3,2}(:,4));
[pmin,hmin,statsmin] = ranksum(Cf290{3,1}(:,4),Cf290{3,2}(:,4));