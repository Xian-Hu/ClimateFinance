fig = figure('Position',[650 215 1200 1100],'Color','w');
ax = axes('Parent',fig); hold on; axis equal; xlim([-1 1]); ylim([-1 1])

c = [105 100 70
    210 235 155
    165 205 120
    110 125 100]*255^-1;

seed = {["Renewable" "Energy"] ["Coal" "Phase-out"] ["Energy" "Efficiency"] ["Electrify"] ["Hydrogen"] ["Power" "Storage"]};
flsh = {["Policy"] ["Infrastructure"] ["Market"] ["Workforce"]};
fsub = {["Renewable Portfolio Standards" "Electricity Market Reform" "Subsidies & Incentives" "Carbon Pricing"] ...
    ["Smart Grids" "Transmission & Distribution"  "CCUS" "Transport Network"] ...
    ["Risk Mitigation Instruments" "Public-private partnership" "Price Signals" "Green Finance"] ...
    ["Training & Reskilling" "Public Awareness" "Green Job Creation" "Just Transition"]};
skin = {["Long-term Vision"] ["Cross-sector Integration"] ["Legislative Frameworks"] ["Stakeholder Engagement"] ["International Cooperation"]};

circle_plot(ax,{[]},seed,16,0.3750,0.05,'nono','bold',c(1,:));
circle_plot(ax,flsh,fsub,15,0.6000,0.05,'bold','normal',c(2:3,:));
circle_plot(ax,{[]},skin,20,0.8375,0.075,'nono','bold',c(4,:));

axis off

function [] = circle_plot(ax,f,f1,fontSize,upr,itv,w1,w2,c)
[chr,c_w,c_l] = size_get(ax,fontSize,w2);
for i = 1:1:length(f1)
    num = length(f1{i});
    for j = 1:1:num
        text_h = char(f1{i}(j));
        for k = 1:length(text_h)
            l(k) = strfind(chr,text_h(k));
        end
        ret(i,j) = sum(c_w(l));
        clear l
    end
end
sz = length(ret(1,:));

ret = max(ret,[],2);
ret = ret*sum(ret)^-1*(2*pi);
ret = [0;cumsum(ret)];
ret = round(ret*2000)*0.0005;

for i = 1:1:length(f1)
    num = length(f1{i}); tp = 1;
    if ~isempty(f{1})
        color_add(ret(i+1),ret(i),upr-itv,upr+itv,c(2,:),2); tp = 3;
        text_add(ax,ret(i+1),ret(i),upr+0.75*itv,char(f{i}),fontSize+5,w1);
    end
    color_add(ret(i+1),ret(i),upr-itv-(sz+0.5)*itv,upr-itv,c(1,:),tp)
    for j = 1:1:num
        text_add(ax,ret(i+1),ret(i),[upr-itv*j-0.25*itv],char(f1{i}(j)),fontSize,w2);
    end
end

end

function color_add(lft,rht,r1,r2,color,tp)
n = 400;
if color(end)<=0.3
    [x,y] = pol2cart([lft linspace(lft,rht,n) rht],[0 repmat(r2,1,n) 0]);
    patch(x,y,'k','FaceColor',color,'EdgeColor','w','LineWidth',2)
    return
end

[x,y] = pol2cart([linspace(lft,rht,n) linspace(rht,lft,n)],[repmat(r1,1,n) repmat(r2,1,n)]);
if tp==1
    patch(x,y,'k','FaceColor',color,'EdgeColor','w','LineWidth',2)
elseif tp == 2
    [x_1,y_1] = pol2cart([lft linspace(lft,rht,n) rht],[r1 repmat(r2,1,n) r1]);
    patch(x,y,'k','FaceColor',color,'EdgeColor','none')
    plot(x_1,y_1,'Color','w','LineWidth',2)
elseif tp==3
    [x_1,y_1] = pol2cart([lft linspace(lft,rht,n) rht],[r2 repmat(r1,1,n) r2]);
    patch(x,y,'k','FaceColor',color,'EdgeColor','none')
    plot(x_1,y_1,'Color','w','LineWidth',2)
end
end

function [] = text_add(ax,lft,rht,r,text_h,fontsize,fontweight)
[chr,c_w,c_l] = size_get(ax,fontsize,fontweight);

for i = 1:length(text_h)
    l(i) = strfind(chr,text_h(i));
end
c_w = c_w(l); r = r- 0.5*c_l(1);

a_del = lft-rht;
mid = 0.5*(lft+rht);

ang = 2*asin(0.5*c_w*r^-1);
apt = r*cos(0.5*ang);

if 0.5*(lft+rht) <= pi
    lft = mid+ 0.5*sum(ang);
    ang = lft- 0.5*cumsum([0 ang]+[ang 0]);
    rot = -(0.5*pi-ang)*(180/pi);
else
    lft = mid- 0.5*sum(ang);
    ang = lft+ 0.5*cumsum([0 ang]+[ang 0]);
    rot = -(1.5*pi-ang)*(180/pi);
end
for i = 1:length(text_h)
    [x,y] = pol2cart(ang(i),apt(i));
    text(x,y,text_h(i),'FontName','Arial','FontSize',fontsize,'FontWeight',fontweight,...
        'Rotation',rot(i),'HorizontalAlignment','center','VerticalAlignment','middle')
end
end

function [chr,c_w,c_l] = size_get(ax,fontsize,fontweight)
chr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-& ';
c_w = zeros(1,length(chr)); c_l = zeros(1,length(chr));
for i = 1:length(chr)
    t = text('Parent',ax,'String',chr(i),'FontName','Arial','FontSize',fontsize,'FontWeight',fontweight);
    extents = get(t,'Extent'); c_w(i) = extents(3); c_l(i) = extents(4); delete(t);
end
end