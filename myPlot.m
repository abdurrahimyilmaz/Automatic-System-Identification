function [] = myPlot(t, Y1, Y2, xlab, ylab, leg1, leg2)

figure('Color', [1 1 1])
plot(t, Y1, 'r',  'linewidth', 3)
hold on
plot(t, Y2, ':k',  'linewidth', 3)
hold off
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';
ax.XColor = [0 0 0]; %or 'k' = black
ax.YColor = [0 0 0]; %or 'k' = black 
grid on

% Create xlabel
xlabel(xlab,'FontName','Arial');

% Create ylabel
ylabel(ylab,'FontName','Arial');

legend(leg1, leg2)

end