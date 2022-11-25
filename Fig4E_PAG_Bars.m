% by Mai Iwasaki, August 2022
load('PAG_Conv1_400_PAG_String.mat');
for i=1:21 % i=22 and 23 are inhibited neurons, so here I treat only excitatory!
 
%percentage activity; (value-base)/peak is stored in PAG_Conv1_400{:,9}
av_perc_act(i,1)=mean(PAG_Conv1_400{i,9}(1,1:100));%"average percentage ACTIVITY" of BASE line 100 sec period
ind=PAG_Conv1_400{i,6}(1,1); %index of the center of top or bottom extreme value is stored in PAG_Conv1_400{i,6}
if ind<390
av_perc_act(i,2)=mean(PAG_Conv1_400{i,9}(1,ind-10:ind+10));%"average percentage ACTIVITY" of PEAK  21 sec period
else
av_perc_act(i,2)=mean(PAG_Conv1_400{i,9}(1,380:400));
end

%spike rate is stored in PAG_String{i,3}
av_perc_act(i,3)=mean(PAG_String{i,3}(1,1:100)); %"average SPIKE RATE" of BASE line 100 sec period
if ind<390
av_perc_act(i,4)=mean(PAG_String{i,3}(1,ind-10:ind+10)); %"average SPIKE RATE" of PEAK  21 sec period
else
av_perc_act(i,4)=mean(PAG_String{i,3}(1,380:400));
end

end

% Percent Activity
av_perc_stat(1,1)=mean(av_perc_act(:,1));%average of mean BASE Activity
av_perc_stat(2,1)=std(av_perc_act(:,1))/sqrt(size(av_perc_act(:,1),1));%SEM of mean BASE Activity
av_perc_stat(1,2)=mean(av_perc_act(:,2));%average of mean PEAK Activity
av_perc_stat(2,2)=std(av_perc_act(:,2))/sqrt(size(av_perc_act(:,2),1));%SEM of mean PEAK Activity
% Spike Rate
av_perc_stat(1,3)=mean(av_perc_act(:,3));%average of mean BASE SpikeRate
av_perc_stat(2,3)=std(av_perc_act(:,3))/sqrt(size(av_perc_act(:,3),1));%SEM of mean BASE SpikeRate
av_perc_stat(1,4)=mean(av_perc_act(:,4));%average of mean PEAK SpikeRate
av_perc_stat(2,4)=std(av_perc_act(:,4))/sqrt(size(av_perc_act(:,4),1));%SEM of mean PEAK SpikeRate

[h1,p1]=lillietest(av_perc_act(:,3));%Is BASE SpikeRate activity distribution normal?
[h2,p2]=lillietest(av_perc_act(:,4));%Is PEAK SpikeRate activity distribution normal?
if h1==1 && h2==1 %let's go to parametric, paired ttest
[h_ttest,p_ttest]=ttest(av_perc_act(:,3), av_perc_act(:,4));% p=0.0133 significantly different on paired ttest
else
[p_srtest,h_srtest]=signrank(av_perc_act(:,3), av_perc_act(:,4));
end

figure
set(0,'defaultAxesLineWidth', 1.0);
for i=3:4
    if i==3
h=patch([i-2.25 i-2.25 i-1.75 i-1.75], [0 av_perc_stat(1,i) av_perc_stat(1,i) 0],[0.7 0.7 0.7],'FaceAlpha',0.8,'EdgeColor','none');
    elseif i==4
h=patch([i-2.25 i-2.25 i-1.75 i-1.75], [0 av_perc_stat(1,i) av_perc_stat(1,i) 0],[0.8 0 0],'FaceAlpha',0.8,'EdgeColor','none');    
    end
hold on
line([-2.05+i -1.95+i],[av_perc_stat(1,i)-av_perc_stat(2,i), av_perc_stat(1,i)-av_perc_stat(2,i)],'Color',[0,0,0]);
line([-2.05+i -1.95+i],[av_perc_stat(1,i)+av_perc_stat(2,i), av_perc_stat(1,i)+av_perc_stat(2,i)],'Color',[0,0,0]);
line([-2.0+i -2.0+i],[av_perc_stat(1,i)-av_perc_stat(2,i), av_perc_stat(1,i)+av_perc_stat(2,i)],'Color',[0,0,0]);
end
for j=1:21
plot([1 2],[av_perc_act(j,3),av_perc_act(j,4)],'-k','LineWidth',0.1);
plot([1 2],[av_perc_act(j,3),av_perc_act(j,4)],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',7);
end

ax=gca;
xlim(ax,[0 3]);
ylim(ax,[0 60]);% ylim(ax,[120 140]),for the outlier
set(ax,'xtick',[1 2]);
set(ax,'xticklabel',{'base','top'});
set(ax,'ytick',[-10 0 10 20 30 40 50 60 70 80 90 100 110 120 130]);
set(ax,'yticklabel',{'-10','0','10','20','30','40','50','60','70','80','90','100','110','120','130'});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
ylabel('spike rate (Hz)','Fontsize', 20); % y-axis label
% convert it to be transparent
% set(ax, 'XColor', [0 0 0]);
% set(ax, 'YColor', [0 0 0]);
% set(gcf,'Color','none');
% set(gcf,'InvertHardcopy','off');
hold off

% As for neurons whose activity decreasd after BL "average percentage SPIKE RATE" of PEAK 21 sec period
for i=22:23
av_perc_actNEGA(i-21,1)=mean(PAG_String{i,3}(1,1:100));%spike rate at base
ind=PAG_Conv1_400{i,6}(1,1);%nega peak index
av_perc_actNEGA(i-21,2)=mean(PAG_String{i,3}(1,ind-10:ind+10));%spike rate at nega peak
end