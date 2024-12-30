% Data from the table
population = [2320, 441, 372, 659, 1919, 480, 1212, 492, 32];
CO2 = [15388, 2585, 5606, 1758, 3180, 3485, 814, 2844, 430];
GDP = [26224, 18362, 23005, 5561, 3826, 4819, 1925, 3713, 1809];
total_finance = [660, 338, 190, 59, 50, 36, 34, 20, 15];
public_finance = [396, 149, 46, 29, 22, 19, 30, 10, 2];
private_finance = [264, 189, 144, 29, 28, 17, 3, 11, 13];
public_share = [60, 44, 24, 50, 44, 52, 90, 48, 14]; % in percentage
private_share = [40, 56, 76, 50, 56, 48, 10, 52, 86]; % in percentage

b_size = 2*total_finance.^0.75; % bubble size (based on total finance)

figure('Color','w','Position',[785 345 995 770])
axes('FontSize',14)
hold on
box on

% Plot the scatter plot
regions = [
    "East Asia and Pacific" 3 1 1
    "Western Europe" 1 1 1
    "US & Canada" 1 0.5 1
    "Latin America & Caribbean" 1 0.5 3
    "South Asia" 1 0.5 1
    "Eastern Europe" 2 1 1 % departed to 2 lines (Central Asia and Eastern Europe)
    "Sub-Saharan Africa" 1 0.15 1
    "Middle East and North Africa" 4 0.15 0.35
    "Other Oceania" 1 0.25 1.5];
l_dir = double(regions(:,2)); % link_direction: 1-4 represents 45° 135° 225° 315°
l_dst = 100*double(regions(:,3)); % link_distance: annotates the length of diagonal lines
l_lgt = 200*double(regions(:,4)); % link_length: annotates the length of horizon lines
regions = regions(:,1);

% Update color scheme
pie_colr = [0 0.4470 0.7410; 0.9290 0.6940 0.1250]; % blue for public, yellow for private

for i = 1:length(regions)
    pie_data = [public_finance(i) private_finance(i)];

    loc = (2*pi)*pie_data.*sum(pie_data)^-1; loc = [0 cumsum(loc)]; loc = loc+(0.5*pi-loc(2)); % here for "middle angle"
    rho = [0 b_size(i)*ones(1,50+2) 0];
    for j = 1:1:2
        theta = [loc(j) loc(j) linspace(loc(j),loc(j+1),50) loc(j+1) loc(j+1)];
        [x,y] = pol2cart(theta,rho);
        patch(population(i)+x,total_finance(i)+(y*0.325),'k','FaceColor',pie_colr(j,:),'EdgeColor',[0 50 70]*255^-1,'LineWidth',0.75)
    end
    flg_1 = -ismember(l_dir(i),[2 3])+ ismember(l_dir(i),[1 4]);
    flg_2 = -ismember(l_dir(i),[3 4])+ ismember(l_dir(i),[1 2]);

    pos_b = [population(i)+ 0.7*(flg_1*b_size(i))
        total_finance(i)+ 0.7*(flg_2*b_size(i)*0.35)]; % Starting coordinate of annotation line

    del_x = l_dst(i)*flg_1;
    del_y = (l_dst(i)*0.35)*flg_2;

    font_size = 12+3*ismember(i,[1 2 3]);

    text(pos_b(1)+ del_x+ 0.5*(l_lgt(i)*flg_1),...
        pos_b(2)+ del_y+ 15*flg_2,regions(i),...
        'HorizontalAlignment','center','FontSize',font_size)
    if i == 6
        text(pos_b(1)+ del_x+ 0.5*(l_lgt(i)*flg_1),...
            pos_b(2)+ del_y+ 35*flg_2,"Central Asia and",...
            'HorizontalAlignment','center','FontSize',font_size)
    end
    r_line = min([l_lgt(i) 200]);
    plot(pos_b(1)+ [0 del_x del_x+r_line*flg_1],pos_b(2)+ [0 del_y del_y],'Color',[0.7 0.7 0.7],'LineWidth',1.5)
end
xlabel('Population (million)')
ylabel('Total Climate Finance (billion USD)')
% title('Scatter Plot of Population vs Total Finance with Finance Distribution');

% legend
name = ["Public  Finance" "Private Finance"];
patch([180 900 900 180],[675 675 750 750]-5,'k','EdgeColor',[0.4 0.4 0.4],'FaceColor',[0.95 0.95 0.95])
[x,y] = pol2cart([0 0 linspace(0,135,50) 135 135]*180^-1*pi,75*[0 1 1*ones(1,50) 1 0]);
for i = 1:1:2
    patch(250+x,650+30*i+y*0.325,'k','FaceColor',pie_colr(i,:),'EdgeColor',[2 48 70]*255^-1,'LineWidth',0.75)
    text(350,650+30*i+10,name(i),'FontSize',15)
end
