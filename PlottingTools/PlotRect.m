function [ ] = PlotRect( X, Y, XAxisTitle, YAxisTitle, PlotTitle)
%PlotRect Summary of this function goes here
%   Detailed explanation goes here

%% Configure Plotting Settings
% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Times New Roman')
set(0,'DefaultAxesFontSize', 14)

% Change default text fonts.
set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultTextFontSize', 14)

%% Plot
h = figure
plot(X,Y)
grid on
%legend(Legend)

%% Final Settings
%Make Grid Viewable When Printed
ax = gca;
ax.GridAlphaMode = 'manual'
ax.GridAlpha = 0.35

%% Save Plot
set(h, 'UserData', PlotTitle)
%text = get(h, 'UserData');
% %Save as PDF to Maintain Figure Quality
% set(gcf,'Units','Inches');
% pos = get(gcf,'Position');
% set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% print(gcf,'Title','-dpdf','-r0')

end

