warning off
load data data
scena = ["2022" "2030 (BAU)" "2030 (ICM)" "2030 (ICM+HLR)"];
figure("Color",'w',"Position",[840 515 1e3 750])
pos = [0.1325 0.585 0.335 0.340
    0.5350 0.585 0.335 0.340
    0.1320 0.215 0.335 0.340
    0.5350 0.215 0.335 0.340];
pos(:,2) = pos(:,2)+0.065;

color = [180 180 180;150 110 180;120 195 235;50 175 145;235 180 50;225 120 95;155 90 40]*255^-1;
color = flipud(color);

name = data(:,1);
data = double(data(:,2:end))*1e-3;

req = 8400e-3; % required finance
fgap = req-sum(data(1:6,:),1); % finance gap
data_c = repmat(req,1,4)-[zeros(1,4);cumsum(data,1)];

for i = 1:1:4
    axes('Position',pos(i,:))
    hold on
    text(4.95,8.5,scena(i),'FontSize',15,'HorizontalAlignment','right')
    x_1 = 2.5; % Starting point (horizontal axis) for each scenario
    plot(x_1+[0 0 0.25 0.25],[0 req req 0],'Color',[42 155 145]*255^-1,'LineWidth',1) % required finance
    for j = 1:1:6 % for each finance type
        x_here = x_1+ 0.3*j+ [0 0 0.25 0.25];
        if i == 1 % scenario 2022
            patch(x_here,data_c([j+1 j j j+1],i),'k','FaceColor',color(j,:),'EdgeColor',color(j,:),'LineWidth',1)
        else % other scenarios
            patch(x_here,data_c(j,i)-[data(j,1) 0 0 data(j,1)],'k','FaceColor',color(j,:),'EdgeColor',color(j,:),'LineWidth',1+0.5*(j<=5))
            % 2022 value using "patch"
            y_range = data_c(j,i)-[data(j,i) data(j,1) data(j,1) data(j,i)];
            patch(x_here,y_range,'k','FaceColor','none','EdgeColor',color(j,:),'LineWidth',1+0.5*(j<=5))
            shade_a(x_here,y_range,color(j,:),0.5,0.035,75)
            % values using "shade_a". Function shade_a is defined below
            % (0.55): ratio- the proportion of "painted area" to "rectangular area"
            % (0.065): wide- width of shadow bar
            % (60): angle- inclination angle of each shadow bar
        end
        h_item = num2str(round(data(j,i)*200)*0.005);
        a = strsplit(h_item,'.');
        if length(a)==2
            if length(a{2})<=2
                h_item = [h_item repmat('0',1,3-length(a{2}))];
            end
        end
        text(mean(x_here),data_c(j,i)+0.35,h_item,'HorizontalAlignment','center', ...
            'FontName','Times New Roman','FontWeight','bold','FontSize',11.5)
    end
    if i < 4
        patch(x_1+ 0.3*(6+1)+ [0 0 0.25 0.25],[0 fgap(i) fgap(i) 0],'k', ...
            'FaceColor',color(end,:),'EdgeColor','none')
    end
    set(gca,'FontSize',15,'XTick',[])
    box on
    xlim([2.25 5])
    if i < 4
        ylim([0 9])
    else
        ylim([-0.5 9])
        plot([2 5],[0 0],'k','LineWidth',1,'LineStyle','--')
    end
    ylabel('Capital (Trillion USD)','FontSize',15)
end

tx = ["a." "b." "c." "d."];
for i = 1:1:4
    annotation(gcf,'textbox',...
        [pos(i,1)-0.05 pos(i,2)+0.265 0.1 0.1],...
        'String',tx(i),'FontWeight','bold','FontSize',22,'EdgeColor','none');
end

axes("FontSize",15,'Position',[0.1 0.025 0.775 0.3])
hold on
xlim([1 12])
ylim([2 12])
patch(2+[0.5 0.75 0.75 0.5],9.25-[0 0 0.75 0.75],'k','FaceColor','none','EdgeColor',[42 155 145]*255^-1,'LineWidth',1)
text(2.8,9.25-0.4,'Required finance','FontSize',15)
patch(5.025+[0.5 0.75 0.75 0.5],9.25-[0 0 0.75 0.75],'k','FaceColor',color(end,:),'EdgeColor',color(end,:),'LineWidth',1)
text(5.825,9.25-0.4,'Finance Gap','FontSize',15)

for i = 1:1:length(name)-1
    patch(2+[0.5 0.75 0.75 0.5],(9-i)-[0 0 0.75 0.75],'k','FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',1)
    patch(1.65+[0.5 0.75 0.75 0.5],(9-i)-[0 0 0.75 0.75],'k','FaceColor','none','EdgeColor',color(i,:),'LineWidth',1)
    shade_a(1.65+[0.5 0.75 0.75 0.5],(9-i)-[0 0 0.75 0.75],color(i,:),0.55,0.045,70)
    text(2.8,9-i-0.4,name(i),'FontSize',15)
end
axis off

function [] = shade_a(x,y,color,rat,wid,ang)
ang = ang*(180^-1)*pi;

x_ = [min(x) max(x) max(x) min(x)];
y_ = [min(y) min(y) max(y) max(y)];

dx = x_(2)-x_(1);
dy = y_(3)-y_(2);

int = dx*sin(ang)^-1+ (dy- dx*cot(ang))*cos(ang);
num = ceil((rat*int)*wid^-1);

lng = 1e2*dx*cos(ang)^-1;

p1 = 0.5*wid*[sin(ang) -cos(ang)];
p2 = lng*[cos(ang) sin(ang)];
c  = cat(1,p1+p2,p2-p1,-p1-p2,p1-p2);
xm = linspace(x_(4),x_(4)+int*sin(ang),num);
ym = linspace(y_(4),y_(4)-int*cos(ang),num);

shape = polyshape;
for i=1:1:num
    temp  = polyshape( repmat([xm(i) ym(i)],4,1)+c );
    shape = union(shape,temp);
end
poly  = polyshape(x,y);
shape = intersect(poly,shape);
plot(shape,'FaceColor',color,'EdgeColor','none','FaceAlpha',1)
end