warning off
load data data
scena = ["2022" "2030 (BAU)" "2030 (ICM)" "2030 (ICM+HLR)"];
figure("Color",'w',"Position",[840 515 1e3 750])
axes("FontSize",15,'Position',[0.1 0.35 0.775 0.6])
hold on; box on

color = [5 215 160;214 40 40;230 85 20;245 125 0;250 190 75;235 225 185;115 80 55]*255^-1;
color = flipud(color);

name = data(:,1);
data = double(data(:,2:end))*1e-3;

req = 8408e-3; % required finance
data_c = repmat(req,1,4)-[zeros(1,4);cumsum(data,1)];

for i = 1:1:4
    x_1 = 2.5*i; % Starting point (horizontal axis) for each scenario
    plot(x_1+[0 0 0.25 0.25],[0 req req 0],'Color',[42 155 145]*255^-1,'LineWidth',1) % required finance
    for j = 1:1:6+1 % for each finance type
        add_x = 0.5+0.5*(j>1)+0.5*(j>6); x_here = x_1+add_x+[0 0 0.25 0.25];
        if i == 1 % scenario 2022
            patch(x_here,data_c([j+1 j j j+1],i),'k','FaceColor',color(j,:),'EdgeColor',color(j,:),'LineWidth',2)
        else % other scenarios
            patch(x_here,data_c(j,i)-[data(j,1) 0 0 data(j,1)],'k','FaceColor',color(j,:),'EdgeColor',color(j,:),'LineWidth',2)
            % 2022 value using "patch"
            shade_a(x_here,data_c(j,i)-[data(j,i) data(j,1) data(j,1) data(j,i)],color(j,:),0.55,0.065,60)
            % values using "shade_a". Function shade_a is defined below
            % (0.55): ratio- the proportion of "painted area" to "rectangular area"
            % (0.065): wide- width of shadow bar
            % (60): angle- inclination angle of each shadow bar
        end
    end
    plot([x_1+0.25 x_1+0.5],data_c(1,i)*ones(1,2),'k','LineStyle','--','LineWidth',1)
    plot([x_1+0.75 x_1+1.0],data_c(2,i)*ones(1,2),'k','LineStyle','--','LineWidth',1)
    plot([x_1+1.25 x_1+1.5],data_c(6+1,i)*ones(1,2),'k','LineStyle','--','LineWidth',1)
end
set(gca,'XTick',[])
xlim([2 12])
ylim([0 9])
ylabel('Capital and finance gap (Tillion USD)')
%%
axes("FontSize",15,'Position',[0.1 0.05 0.775 0.3])
hold on
xlim([1 12])
ylim([2 12])
patch(2+[0.5 0.75 0.75 0.5],10.25-[0 0 0.75 0.75],'k','FaceColor','none','EdgeColor',[42 155 145]*255^-1,'LineWidth',1)
text(2.8,10.25-0.4,'Required finance','FontSize',15)
patch(2+[0.5 0.75 0.75 0.5],9.25-[0 0 0.75 0.75],'k','FaceColor',color(end,:),'EdgeColor',color(end,:),'LineWidth',1)
text(2.8,9.25-0.4,'Finance Gap','FontSize',15)

for i = 1:1:length(name)-1
    patch(2+[0.5 0.75 0.75 0.5],9-i-[0 0 0.75 0.75],'k','FaceColor',color(i,:),'EdgeColor','none')
    shade_a(1.5+[0.5 0.75 0.75 0.5],9-i-[0 0 0.75 0.75],color(i,:),0.55,0.065,60)
    text(2.8,9-i-0.4,name(i),'FontSize',15)
end
for i = 1:1:4
    x = [2.5 4.3]+2.5*(i-1);
    plot([x(1)*ones(1,3) x(2)*ones(1,3)],10.95+0.5*[1.5 0.5 1 1 1.5 0.5],'k')
    text(mean(x),10.75,scena(i),'HorizontalAlignment','center','FontSize',15)
end
axis off
%%
function [] = shade_a(x,y,color,rat,wid,ang)
patch(x,y,'k','FaceColor','none','EdgeColor',color,'LineWidth',2)

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