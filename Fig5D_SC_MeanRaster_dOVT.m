% by Mai Iwasaki, August 2022
%% dOVT 1st recording
load('SpinalCord_Conv.mat');
% Let's normalize to the max value of dOVT, plateau of wind up
for i=1:size(dOVTVhr2String,1)
    for k=1:290
    dOVTwu_platlist290{i,1}(k,1)=length(dOVTVhr2String{i,4}{k,1});% number of spike for each second from -100 to +900
    end
 dOVTwu_platsmooth290{i,1}=smooth(dOVTwu_platlist290{i,1},21,'moving');% Window size=21sec
 dOVTwu_platmax290(i,1)=max(dOVTwu_platsmooth290{i,1}(1:130,1));% Peak should come before 130 sec 
dOVTwu_platmax290(i,2)=find(dOVTwu_platsmooth290{i,1}==dOVTwu_platmax290(i,1),1);% find(A,1) this 1 ,means the first answer of find
ind=dOVTwu_platmax290(i,2);
dOVTConv290plt{i,1}=dOVTConv290_1000{i,1}(:,ind-10:ind+10);% ind-10:ind+10 is -100 to +900 msec of peak 21 sec
dOVTConv290pltAv{i,1}=mean(dOVTConv290plt{i,1},2);% Let's make average convolution of the plateau phase for 20 sec

for j=1:1001
for k=1:290
    dOVTConv290norm{i,1}(j,k)=100*dOVTConv290_1000{i,1}(j,k)/dOVTConv290pltAv{i,1}(j,1);%normalization  
end
end

end

for i=1:size(dOVTVhr2String,1)
for j=1:1001
for k=1:290
bfrdOVTConv290normAv{j,k}(i,1)=dOVTConv290norm{i,1}(j,k);
end 
end
end
for j=1:1001
for k=1:290
dOVTConv290normAv(j,k)=nanmean(bfrdOVTConv290normAv{j,k}(:,1));% Average dOVT Horizontal first 290 sec
end 
end

figure
imagesc(dOVTConv290normAv);
set(0,'defaultAxesLineWidth', 2.0); 
map=[1,1,1;1,0.95,0.95;1,0.9,0.9;
   1,0.85,0.85;1,0.8,0.8;1,0.75,0.75;1,0.7,0.7;1,0.65,0.65;1,0.6,0.6;1,0.55,0.55; 1,0.5,0.5; 1,0.45,0.45;
  1,0.4,0.4;1,0.35,0.35;1,0.3,0.3;1,0.25,0.25;1,0.2,0.2;1,0.15,0.15;1,0.1,0.1; 1,0.05,0.05;
  1,0,0;0.95,0,0;0.9,0,0;0.85,0,0;0.8,0,0;0.75,0,0;0.7,0,0;0.65,0,0;0.6,0,0;0.55,0,0;0.5,0,0];
colormap(map)
caxis([40 100])

ax=gca;
set(ax,'xtick',[1 40 60 140 240]);
set(ax,'xticklabel',{'-40','0','20','100','200'});
set(ax,'ytick',[100 600 810 900]);
set(ax,'yticklabel',{'800','300','90','0'});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');

xlim(ax,[1 280]);
ylim(ax,[40 960]);% originally x was 290 and y was 0 to 1001 but to remove smoothing filter effect 1000x20
xlabel('# of shock (@1Hz)relative to BL','Fontsize', 20); % x-axis label
ylabel('time relative to shock (msec)','Fontsize', 20); % y-axis label

line([40 40], [0 1001], 'color',[0.5 1 1],'LineWidth',2,'LineStyle','--');
line([60 60], [0 1001], 'color',[0.5 1 1],'LineWidth',2,'LineStyle','--');
% colorbar
% h = colorbar;
% ylabel(h, '% to plateau spike rate','Fontsize', 17);
% set(h,'Fontsize', 12.5);
% set(h,'ytick',[0 50 100]);
% set(h,'yticklabel',{'0','50','100'});

set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none');  % transparent
set(gcf,'InvertHardcopy','off');

% h=gcf;
%  set(h,'PaperOrientation','landscape');
%  set(h,'PaperUnits','normalized');
%  set(h,'PaperPosition', [0 0 1 1]);
%  print(gcf, '-dpdf', 'rasterdOVT290.pdf');

%% dOVT 2nd recording
for i=1:size(dOVTVhr2String,1)
for j=1:1001
for k=1:60
    dOVTConv60norm{i,1}(j,k)=100*dOVTConv60_1000{i,1}(j,k)/dOVTConv290pltAv{i,1}(j,1); % Let's normalize to the max value of ChR2, plateau of wind up   
end
end
end

for i=1:size(dOVTVhr2String,1)
for j=1:1001
for k=1:60
bfrdOVTConv60normAv{j,k}(i,1)=dOVTConv60norm{i,1}(j,k);
end 
end
end
for j=1:1001
for k=1:60
dOVTConv60normAv(j,k)=nanmean(bfrdOVTConv60normAv{j,k}(:,1)); % Average dOVT Horizontal second 60 sec
end 
end

figure
imagesc(dOVTConv60normAv);
colormap(map)
caxis([40 100])
colorbar
ax=gca;
set(ax,'xtick',[1 40]);
set(ax,'xticklabel',{'1','40'});
set(ax,'ytick',[100 600 810 900]);
set(ax,'yticklabel',{'','','',''});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');

xlim(ax,[1 50]);
ylim(ax,[40 960]); % originally x was 60 and y was 0 to 1001 but to remove smoothing filter effect 1000x20
xlabel('','Fontsize', 20); % x-axis label
% ylabel('Time (msec)','Fontsize', 20); % y-axis label

h = colorbar;
ylabel(h, '% to plateau spike rate','Fontsize', 17);
set(h,'Fontsize', 12.5);
set(h,'ytick',[40 50 60 70 80 90 100]);
set(h,'yticklabel',{'40','50','60','70','80','90','100'});

set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none'); % transparent
set(gcf,'InvertHardcopy','off');

% h=gcf;
%  set(h,'PaperOrientation','landscape');
%  set(h,'PaperUnits','normalized');
%  set(h,'PaperPosition', [0 0 1 1]);
%  print(gcf, '-dpdf', 'rasterdOVT60.pdf');