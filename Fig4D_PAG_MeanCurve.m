% by Mai Iwasaki, August 2022
load('PAG_percent_activity.mat');% 23 cells of PAG percent activity is stored in PAG_square_percent

PAG_percact{1,1}=PAG_square_percent(1:21,:);% Remove supressed neuron 
for j=1:length(PAG_percact{1,1}(1,:))
PAG_percact{2,1}(1,j)=mean(PAG_percact{1,1}(:,j));% average activity across neurons 
end
for j=1:length(PAG_percact{1,1}(1,:))
PAG_percact{3,1}(1,j)=std(PAG_percact{1,1}(:,j))/sqrt(size(PAG_percact{1,1}(:,j),1));% SEM across neurons 
end

figure
set(0,'defaultAxesLineWidth', 1.0); 
Square_coloring([90 130],[60 60],-10,[0.8 1 1]);
hold on
xfill=1:size(PAG_percact{2,1}(1,:),2);% 2=to vertical direction for 290 data points
% Mean=PAG_percact{2,1}(1,:), SEM=PAG_percact{3,1}(1,:). 
% First, make the transpatrnt error bar=Mean +-SEM
h=fill([xfill fliplr(xfill)],[PAG_percact{2,1}(1,:)+PAG_percact{3,1}(1,:) fliplr(PAG_percact{2,1}(1,:)-PAG_percact{3,1}(1,:))],[1 0.2 0.2],'linestyle','none');
set(h,'facealpha',.25);% Let's make the line error bar tranaparent
x = linspace(1,400,400);
plot(x,PAG_percact{2,1}(1,:),'LineWidth',1,'Color',[0.8 0 0]); %Mean Curve

ax=gca;
xlim(ax,[1 400]);
ylim(ax,[-10 60]);
set(ax,'ytick',[-10 0 10 20 30 40 50 60]);
set(ax,'yticklabel',{'-10','0','10','20','30','40','50','60'});
set(ax,'xtick',[1 101 120 200 300 400]);
set(ax,'xticklabel',{'-100','0','20','100','200','300'});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
xlabel('Blue light onset (sec)','Fontsize', 20); % x-axis label
ylabel('mean % activity','Fontsize', 20); % y-axis label

% convert it to be transparent
set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');