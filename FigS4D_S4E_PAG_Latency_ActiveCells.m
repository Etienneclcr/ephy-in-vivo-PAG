% by Mai Iwasaki, August 2022
load('PAG_Conv1_400_PAG_String.mat');
%percentage activity; (value-base)/peak is stored in PAG_Conv1_400{:,9}
% Let's decide the threshold of onset peak offset
for i=1:21
base_max_actPAG(i,1)=mean(PAG_Conv1_400{i,9}(1,1:90));% mean of base, filtersize is 10, so take until -10 sec before BL
base_max_actPAG(i,2)=std(PAG_Conv1_400{i,9}(1,1:90));% sigma=std of base
base_max_actPAG(i,3)=base_max_actPAG(i,1)+3*base_max_actPAG(i,2);% 3 sigma thresh
base_max_actPAG(i,4)=base_max_actPAG(i,1)+4*base_max_actPAG(i,2);% 4 sigma thresh
base_max_actPAG(i,5)=base_max_actPAG(i,1)+5*base_max_actPAG(i,2);% 5 sigma thresh
base_max_actPAG(i,6)=max(PAG_Conv1_400{i,9}(1,1:90));% base max
base_max_actPAG(i,7)=max(PAG_Conv1_400{i,9}(1,101:400));% after BL max
end

for i=1:21
PAG_Lat{i,1}=PAG_Conv1_400{i,9};%(value-base)/peak is stored in PAG_Conv1_400{:,9}
% thresh=base_max_actPAG(i,3);%3 sigma
thresh=base_max_actPAG(i,4);%4 sigma
%  thresh=base_max_actPAG(i,5);%5 sigma
PAG_Lat{i,2}=thresh;
PAG_Lat{i,3}=find(PAG_Lat{i,1}>thresh);  

for j=1:400
if PAG_Lat{i,1}(1,j)>thresh
PAG_Lat{i,4}(j,1)=1;
else  PAG_Lat{i,4}(j,1)=0; 
end
end

PAG_Lat{i,5}=PAG_Lat{i,4};
for k=1:length(PAG_Lat{i,3})-1
% If the value below the thresh continues only less than 20sec, 
%let's regard this period as above thresh because it is momental drop
    if  PAG_Lat{i,3}(1,k+1)-PAG_Lat{i,3}(1,k)<20
% PAG_Lat{i,3}(1,k) is the index of last "1" before successive "0",in PAG_Lat{i,4}. 
% So,in PAG_Lat{i,5} which is the copy of {i,4},"0" of the column whose index 
% from PAG_Lat{i,3}(1,k)+1 to PAG_Lat{i,3}(1,k+1)-1 should be replaced with 1.
       for m=PAG_Lat{i,3}(1,k)+1:PAG_Lat{i,3}(1,k+1)-1
       PAG_Lat{i,5}(m,1)=1;
       end
    end
end

PAG_Lat{i,6}=find(PAG_Lat{i,5}==1);% timecode of above threshold
% Let's store onset in PAG_Lat{i,7}(:,1)
PAG_Lat{i,7}(1,1)=PAG_Lat{i,6}(1,1);% first value is always onset 
for n=1:length(PAG_Lat{i,6})-1
    if PAG_Lat{i,6}(n+1,1)-PAG_Lat{i,6}(n,1)>=2 %"=1"means,the above threshold is continuous
       p=length(PAG_Lat{i,7}(:,1));
       PAG_Lat{i,7}(p,3)=PAG_Lat{i,6}(n,1);% Time code of the offset 
       PAG_Lat{i,7}(p+1,1)=PAG_Lat{i,6}(n+1,1);% Time code of the next onset  
    end
end
% if PAG_Lat{i,6}(end,1)==300, it is not the final offset though
  PAG_Lat{i,7}(end,3)=PAG_Lat{i,6}(end,1);% anyway the final offset is!
  
for q=1:length(PAG_Lat{i,7}(:,1))
%peak latency between onset PAG_Lat{i,7}(p,1) and offset PAG_Lat{i,7}(p,3)
onset=PAG_Lat{i,7}(q,1);
offset=PAG_Lat{i,7}(q,3); 
PAG_Lat{i,8}{q,1}=find(PAG_Lat{i,1}==max(PAG_Lat{i,1}(1,onset:offset)));% peaks
PAG_Lat{i,7}(q,2)=min(PAG_Lat{i,8}{q,1}((onset<=PAG_Lat{i,8}{q,1})&(offset>=PAG_Lat{i,8}{q,1})));% real peak
end
end

% re-order to fit to the heatmap
I3=I(1:21,1);
for i=1:21
    PAG_Lat2{i,1}=PAG_Lat{I3(i,1),7};
end
I6=I2(3:23,1);
for i=1:21
    PAG_Lat3{i,1}=PAG_Lat2{I6(i),:};
end

PAG_Lat2_all=[PAG_Lat2{1,1};PAG_Lat2{2,1};PAG_Lat2{3,1};PAG_Lat2{4,1};PAG_Lat2{5,1};
    PAG_Lat2{6,1};PAG_Lat2{7,1};PAG_Lat2{8,1};PAG_Lat2{9,1};PAG_Lat2{10,1};PAG_Lat2{11,1};
    PAG_Lat2{12,1};PAG_Lat2{13,1};PAG_Lat2{14,1};PAG_Lat2{15,1};PAG_Lat2{16,1};
    PAG_Lat2{17,1};PAG_Lat2{18,1};PAG_Lat2{19,1};PAG_Lat2{20,1};PAG_Lat2{21,1};];

PAG_Lat2_allON=PAG_Lat2_all(:,1);
PAG_Lat2_allPEAK=PAG_Lat2_all(:,2);
PAG_Lat2_allOFF=PAG_Lat2_all(:,3);
for j=1:41 % from 90(=-10sec to BL) to 400(=300sec to BL)binning every 10sec
    initial=(j-1)*10;
    final=j*10;
% neurons which reached ONSET in this period
PAG_Lat2_10bin{j,1}=PAG_Lat2_allON(initial<=PAG_Lat2_allON & final>PAG_Lat2_allON);
% number of neurons which reached ONSET in this period
PAG_10bin(j,1)=length(PAG_Lat2_10bin{j,1}(:,1));

% neurons which reached OFFSET in this period
PAG_Lat2_10bin{j,2}=PAG_Lat2_allOFF(initial<=PAG_Lat2_allOFF & final>PAG_Lat2_allOFF);
% number of neurons which reached OFFSET in this period
PAG_10bin(j,2)=length(PAG_Lat2_10bin{j,2}(:,1));

for k=1:length(PAG_Lat2_allON(:,1))
% neurons which are above threshold in this period
if (PAG_Lat2_allOFF(k,1)<initial)==1 || (PAG_Lat2_allON(k,1)>=final)==1 % ==0 means not true
    PAG_nbr_active(j,k)=0;
else PAG_nbr_active(j,k)=1;
end
end
%number of neurons which are above threshold in this period
PAG_10bin(j,3)=sum(PAG_nbr_active(j,:));

% neurons which reached PEAK in this period
PAG_Lat2_10bin{j,3}=PAG_Lat2_allPEAK(initial<=PAG_Lat2_allPEAK& final>PAG_Lat2_allPEAK);
% number of neurons which reached PEAK in this period
PAG_10bin(j,4)=length(PAG_Lat2_10bin{j,3}(:,1));
end

figure % avobe thresh neurons number
set(0,'defaultAxesLineWidth', 1.0); 
for i=1:length(PAG_10bin(:,3))-1
    h=patch([i-0.4 i-0.4 i+0.4 i+0.4],[0 PAG_10bin(i,3) PAG_10bin(i,3) 0], [0.7 0 0],'FaceAlpha',1.0,'EdgeColor','k');
    hold on
end

Square_coloring([9.5 13.5],[15 15],0,[0.8 1 1]);
ax=gca;
xlim(ax,[0 40.5]);
ylim(ax,[0 15]);
set(ax,'ytick',[0 5 10 15]);
set(ax,'yticklabel',{'0','5','10','15'});
set(ax,'xtick',[0.5 10.5 12.5 20.5 30.5 40.5]);
set(ax,'xticklabel',{'-100','0','20','100','200','300'});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
xlabel('Blue light onset (sec)','Fontsize', 20); % x-axis label
ylabel('# of active cells','Fontsize', 20); % y-axis label
% convert it to be transparent
set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');
hold off

for i=1:21
    PAG_onpkof(i,1)=min(PAG_Lat2{i,1}(:,1))-100; % first onset of each neurons
    PAG_onpkof(i,2)=max(PAG_Lat2{i,1}(:,2))-100; % max peak of each neurons
    PAG_onpkof(i,3)=max(PAG_Lat2{i,1}(:,3))-100;  % final offset of each neurons
end

figure
set(0,'defaultAxesLineWidth', 1.0); 
for i=1:3 %1=1st onset, 2=peak, 3=offset latency
    
    % values for box plot
PAG_onpkof_stat(1,i)=max(PAG_onpkof(:,i));% max 
PAG_onpkof_stat(2,i)=min(PAG_onpkof(:,i));% min 
PAG_onpkof_stat(3,i)=median(PAG_onpkof(:,i));% median 
PAG_onpkof_stat(4,i)=mean(PAG_onpkof(:,i));% mean 
PAG_onpkof_stat(5,i)=quantile(PAG_onpkof(:,i),0.25);% 1st quantile 
PAG_onpkof_stat(6,i)=quantile(PAG_onpkof(:,i),0.75);% 3rd quantile 

%     patch of 1st and 3rd quantile
h=patch([i-0.25 i-0.25 i+0.25 i+0.25],[PAG_onpkof_stat(5,i)  PAG_onpkof_stat(6,i) PAG_onpkof_stat(6,i) PAG_onpkof_stat(5,i)],[0.7 0.7 0.7],'FaceAlpha',0.8,'EdgeColor','none');
hold on
plot (i,PAG_onpkof_stat(4,i),'+','LineWidth',0.1,'MarkerEdgeColor',[0 0 0],'MarkerSize',6);% mean
line([-0.25+i 0.25+i],[PAG_onpkof_stat(3,i), PAG_onpkof_stat(3,i)],'Color',[0,0,0]);% median
line([-0.05+i 0.05+i],[PAG_onpkof_stat(1,i),PAG_onpkof_stat(1,i)],'Color',[0,0,0]);% max end
line([i i],[PAG_onpkof_stat(6,i),PAG_onpkof_stat(1,i)],'Color',[0,0,0]);% 3rd quantile to max
line([-0.05+i 0.05+i],[PAG_onpkof_stat(2,i),PAG_onpkof_stat(2,i)],'Color',[0,0,0]);% min end
line([i i],[PAG_onpkof_stat(5,i),PAG_onpkof_stat(2,i)],'Color',[0,0,0]);% 1st quantile to min
end

 A7=PAG_onpkof(:,1);% onset
[B7,I7]=sort(A7,'ascend'); % B=from small to big,I=index
plot([1 1 1 1 1 1 1],[-4 12 23 58 66 81 132],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
plot([0.9 1.1],[2 2],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
plot([0.8 0.85 1.15 1.2],[1 1 1 1],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
plot([0.95 1.05 0.97 1.03 0.97 1.03 0.97 1.03],[0 0 3 4 17 17 40 41],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);

A8=PAG_onpkof(:,2);% peak
[B8,I8]=sort(A8,'ascend'); % B=from small to big,I=index
plot([2 2 2 2 2 2 2 2 2 2 2],[10 18 24 51 78 129 151 204 230 292 296],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
plot([1.97 2.03 1.97 2.03 1.97 2.03 1.97 2.03 1.97 2.03],[144 149 153 155 253 259 279 284 294 295],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);

A9=PAG_onpkof(:,3);% offset
[B9,I9]=sort(A9,'ascend'); % B=from small to big,I=index
plot([3 3 3 3 3 3 3 3 3 3 3],[19 32 52 100 132 153 161 184 229 280 296],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
plot([2.97 3.03 3],[297 298 299],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
plot([3.1 2.85 3.15 2.8 3.2 2.9 3.07],[300 300 300 300 300 300 300],'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',5);
Square_coloring([0 3.5],[30 30],-10,[0.8 1 1]);

ax=gca;
xlim(ax,[0.5 3.5]);
ylim(ax,[-20 310]);
set(ax,'xtick',[1 2 3]);
set(ax,'xticklabel',{'onset','peak','offset'});
set(ax,'ytick',[0 20 100 200 300]);
set(ax,'yticklabel',{'0','20','100','200','300'});
set(ax, 'Fontsize', 15); 
set(ax,'Ticklength',[0.01 0]);
set(ax,'TickDir', 'out');
ylabel('latency (sec)','Fontsize', 20); % y-axis label
% convert it to be transparent
set(ax, 'XColor', [0 0 0]);
set(ax, 'YColor', [0 0 0]);
set(gcf,'Color','none');
set(gcf,'InvertHardcopy','off');
hold off