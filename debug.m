% interpretation:
Xn=X';
steps = [1 4 7 10 13];
% steps = [1 4 7 10];
Xref = interp1(TimeList0, coord0(:,1),  epochs, 'linear');
Yref = interp1(TimeList0, coord0(:,2),  epochs, 'linear');
% Zref = interp1(TimeList0, coord0(:,3),  epochs, 'linear');
XabsExp = Xref + Xexp(steps)';
YabsExp = Yref + Xexp(steps+1)';
% ZabsExp = Zref + Xexp(steps+2)';
Xabs    = Xref + Xn(steps)';
Yabs    = Yref + Xn(steps+1)';
% Zabs    = Zref + Xn(steps+2)';
Xmin = min([Xref Xabs XabsExp]);
Xref = Xref - Xmin;
Xabs = Xabs - Xmin;
XabsExp = XabsExp - Xmin;
Ymin = min([Yref Yabs YabsExp]);
Yref = Yref - Ymin;
YabsExp = YabsExp - Ymin;
Yabs = Yabs - Ymin;

% utiliser la fonction regress et plotter autour de X3

figure(9); clf(9);
plot(Xref, Yref,'ok');
hold on;
plot(XabsExp, YabsExp,'xb');
plot(Xabs, Yabs,'xr');
Xinterp = Xabs(1):(Xabs(5)-Xabs(1))/100.:Xabs(5);
plot(mean(Xabs(2:4)),mean(Yabs(2:4)),'rs');
legend('Ref.Traj.', 'Actual shift', 'Found', 'Mean(#2..#4)');
plot(Xinterp, interp1(Xabs, Yabs, Xinterp, 'cubic'), '-r');

figure(8); clf(8);
plot(Xref(3), Yref(3),'ok');
hold on;
xpmin=min([Xref(3) XabsExp(3) Xabs(3) mean(Xabs(2:4))]);
xpmax=max([Xref(3) XabsExp(3) Xabs(3) mean(Xabs(2:4))]);
ypmin=min([Yref(3) YabsExp(3) Yabs(3) mean(Yabs(2:4))]);
ypmax=max([Yref(3) YabsExp(3) Yabs(3) mean(Yabs(2:4))]);
plot(XabsExp(3), YabsExp(3),'xb');
plot(Xabs(3), Yabs(3),'xr');
plot(mean(Xabs(2:4)),mean(Yabs(2:4)),'rs');
legend('Ref.Traj.', 'Actual shift', 'Found', 'Mean(#2..#4)');
plot(Xinterp, interp1(Xabs, Yabs, Xinterp, 'cubic'), '-r');
xlim([2.*xpmin-xpmax 2.*xpmax-xpmin]);
ylim([2.*ypmin-ypmax 2.*ypmax-ypmin]);
% plot(mean(Xabs),mean(Yabs),'or');
