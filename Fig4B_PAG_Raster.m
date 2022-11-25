% by Mai Iwasaki, August 2022
% Let's make a normalized raster map of PAG
load('PAG_String.mat');

% Convolution across column dimention for PAG
hsize=[1,10]; % Some convolution.No convolution is %hsize=[1,1]; %
for i=1:length(PAG_String)
PAG_Conv1_400{i,1}=conv2(PAG_String{i,3}, fspecial('gaussian',hsize,5), 'same');
% h = fspecial('gaussian', hsize, sigma) 
% hsize is a vector which defines the number of raws and columns
% sigma=standard deviation, 99.7 percent of data exist within 3 sigma.
% As this value becomes larger, the image becomes more blurry.

PAG_Conv1_400{i,2}=mean(PAG_Conv1_400{i,1}(1,1:100));%Let's calculate the mean of the first 100sec Base line
PAG_Conv1_400{i,3}=PAG_Conv1_400{i,1}-PAG_Conv1_400{i,2};%Let's subtract base from all
PAG_Conv1_400{i,4}=smooth(PAG_Conv1_400{i,3},21,'moving');%search top value zone
PAG_Conv1_400{i,5}=max(abs(PAG_Conv1_400{i,4}(:,1)));%center of top or bottom extreme value, abs is absolute value
PAG_Conv1_400{i,6}=find(abs(PAG_Conv1_400{i,4})==PAG_Conv1_400{i,5});
ind=PAG_Conv1_400{i,6}(1,1);
if ind<390
PAG_Conv1_400{i,7}=PAG_Conv1_400{i,3}(1,ind-10:ind+10);% Let's make average of top or bottom period
else
PAG_Conv1_400{i,7}=PAG_Conv1_400{i,3}(1,380:400);
end
PAG_Conv1_400{i,8}=mean(PAG_Conv1_400{i,7},2);

for j=1:400
PAG_Conv1_400{i,9}(1,j)=100*PAG_Conv1_400{i,3}(1,j)/abs(PAG_Conv1_400{i,8}(1,1));  %percentage   
end

%re-ordering from more red to more blue
PAG_Conv1_400{i,10}=mean(PAG_Conv1_400{i,9}(1,101:400)>50);% mean of above abs 50% change after base line
A(i,1)=PAG_Conv1_400{i,10}(1,1);
end
[B,I]=sort(A,'descend');%[B,I]=sort(A); B=from small to big,I=index


for i=1:length(PAG_String) % Let's make a normalized raster map
for j=1:400
  PAG_percent_activity(i,j)=PAG_Conv1_400{I(i),9}(1,j);%percentage,re-ordering from more red to more blue
end
end

figure
set(0,'defaultAxesLineWidth', 1.0); 
imagesc(PAG_percent_activity);
 map=[0,0,0.5;0,0,0.55;0,0,0.6;0,0,0.65;0,0,0.7;0,0,0.75;0,0,0.8;0,0,0.85;0,0,0.9;0,0,0.95;0,0,1;
    0.05,0.05,1;0.1,0.1,1;0.15,0.15,1;0.2,0.2,1;0.25,0.25,1;0.3,0.3,1;0.35,0.35,1;0.4,0.4,1;
    0.45,0.45,1;0.5,0.5,1;0.55,0.55,1;0.6,0.6,1; 0.65,0.65,1; 0.7,0.7,1;
    0.75,0.75,1;0.8,0.8,1;0.85,0.85,1;0.9,0.9,1;0.95,0.95,1;1,1,1;1,0.95,0.95;1,0.9,0.9;
   1,0.85,0.85;1,0.8,0.8;1,0.75,0.75;1,0.7,0.7;1,0.65,0.65;1,0.6,0.6;1,0.55,0.55; 1,0.5,0.5; 1,0.45,0.45;
  1,0.4,0.4;1,0.35,0.35;1,0.3,0.3;1,0.25,0.25;1,0.2,0.2;1,0.15,0.15;1,0.1,0.1; 1,0.05,0.05;
  1,0,0;0.95,0,0;0.9,0,0;0.85,0,0;0.8,0,0;0.75,0,0;0.7,0,0;0.65,0,0;0.6,0,0;0.55,0,0;0.5,0,0];
colormap(map)
caxis([-100 100])

ax=gca;
set(ax,'xtick',[1 100 120 200 300 400]);
set(ax,'xticklabel',{'-100','0','20','100','200','300'});
set(ax,'ytick',[1 10 20]);
set(ax,'yticklabel',{'1','10','20'});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');

xlim(ax,[1 400]);
ylim(ax,[0.5 23.5]);
xlabel('Blue light onset (sec)','Fontsize', 20); % x-axis label
ylabel('Cell #','Fontsize', 20); % y-axis label

colorbar
h = colorbar;
set(h,'Visible','on');
ylabel(h, '(value-base)/peak(%)','Fontsize', 17);
set(h,'Fontsize', 12.5);
set(h,'ytick',[-100 -50 0 50 100]);
set(h,'yticklabel',{'-100','-50','0','50','100'});

set(ax, 'XColor', [0 0 0]);% convert it to be transparent
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');

line([100 100], [0 24], 'color','k','LineWidth',1,'LineStyle','--');
line([120 120], [0 24], 'color','k','LineWidth',1,'LineStyle','--');