close all
plot_phase = filter_data(:,3);
plot_mag = filter_data(:,4);

figure
hold on
plot(plot_phase)
title("S21 Phase vs. Switch State")
xlabel("Switch State")
ylabel("S21 Phase (degrees)")
hold off

figure
hold on
plot(plot_mag)
title("Magnitude S21 vs. Switch State")
xlabel("Switch State")
ylabel("S21 Magnitude (dB)")
hold off