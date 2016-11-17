% iDebug==0; % desactiviation du mode debug
% ------------
if iDebug==1
    rex = []; rme = []; res = []; ves = []; tst = []; tst0=epochs(3);
    lKg = []; ldP = [];
end
% ------------
if iDebug==2
    rex = [rex; (refLoc + Xexp(7:9))'];   % debug
    rme = [rme; (refLoc + X(7:9))'];      % debug
    res = [res; refLoc' + nState(1:3)'.*fx];       % debug
    ves = [ves; norm(nState(4:6)).*fv];  % debug
    tst = [tst; (epochs(3)-tst0).*24];
    lKg = [lKg; Kg];
    ldP = [ldP; det(pSigma)];
%     fprintf('%i ', floor(norm(pState(1:3).*fx-Xexp(7:9))));
end
% ------------
if iDebug==3
    rres=res-rex; rrme=rme-rex;
    
    % interpretation: === absolute values ====
    figure(100); clf;
    subplot(2,2,1);
    plot3(res(:,1),res(:,2),res(:,3),'rx--'); hold on;
    plot3(rme(:,1),rme(:,2),rme(:,3),'gx:');
    plot3(rex(:,1),rex(:,2),rex(:,3),'ko-');
    plot3(res(nKF,1),res(nKF,2),res(nKF,3),'ks');
    legend('KF', '3D-OD', 'actual', 'final KF');
    subplot(2,2,3);
    plot(res(:,1),res(:,2),'rx--'); hold on;
    plot(rme(:,1),rme(:,2),'gx:');
    plot(rex(:,1),rex(:,2),'ko-');
    plot(res(nKF,1),res(nKF,2),'ks');
    legend('KF', '3D-OD', 'actual', 'final KF'); title(['Y=f(X)']);
    subplot(2,2,2);
    plot(res(:,2),res(:,3),'rx--'); hold on;
    plot(rme(:,2),rme(:,3),'gx:');
    plot(rex(:,2),rex(:,3),'ko-');
    plot(res(nKF,2),res(nKF,3),'ks');
    legend('KF', '3D-OD', 'actual', 'final KF'); title(['Z=f(Y)']);
    subplot(2,2,4);
    plot(res(:,1),res(:,3),'rx--'); hold on;
    plot(rme(:,1),rme(:,3),'gx:');
    plot(rex(:,1),rex(:,3),'ko-');
    plot(res(nKF,1),res(nKF,3),'ks');
    legend('KF', '3D-OD', 'actual', 'final KF'); title(['Z=f(X)']);
    
    % interpretation: === relative values ===
    figure(101); clf;
    subplot(2,2,1);
    plot3(rres(:,1),   rres(:,2),   rres(:,3),   'rx--'); hold on;
    plot3(rrme(:,1),   rrme(:,2),   rrme(:,3),   'gx:');
    plot3(rres(nKF,1), rres(nKF,2), rres(nKF,3), 'ks');
    axis([min(rrme(:,1)) max(rrme(:,1)) min(rrme(:,2)) max(rrme(:,2)) min(rrme(:,3)) max(rrme(:,3))]);
    % axis equal;
    legend('KF', '3D-OD', 'final KF');
    subplot(2,2,3);
    plot(rres(:,1),rres(:,2),'rx--'); hold on;
    plot(rrme(:,1),rrme(:,2),'gx:');
    plot(rres(nKF,1),rres(nKF,2),'ks');
    axis([min(rrme(:,1)) max(rrme(:,1)) min(rrme(:,2)) max(rrme(:,2))]);
    % axis equal;
    legend('KF', '3D-OD', 'final KF');
    subplot(2,2,2);
    plot(rres(:,2),rres(:,3),'rx--'); hold on;
    plot(rrme(:,2),rrme(:,3),'gx:');
    plot(rres(nKF,2),rres(nKF,3),'ks');
    axis([min(rrme(:,2)) max(rrme(:,2)) min(rrme(:,3)) max(rrme(:,3))]);
    % axis equal; 
    legend('KF', '3D-OD', 'final KF');
    subplot(2,2,4);
    plot(rres(:,1),rres(:,3),'rx--'); hold on;
    plot(rrme(:,1),rrme(:,3),'gx:');
    plot(rres(nKF,1),rres(nKF,3),'ks');
    axis([min(rrme(:,1)) max(rrme(:,1)) min(rrme(:,3)) max(rrme(:,3))]);
    % axis equal; 
    legend('KF', '3D-OD', 'final KF');
    
    % chronogrammes
    moyrres = sum(rres(10:20,:))/11;
    figure(102); clf;
    subplot(3,2, [1 2]);
    plot(rres(:,1), 'rx-'); hold on;
    plot(rres(:,2), 'gx-');
    plot(rres(:,3), 'bx-');
    plot(rrme(:,1), 'rx:');
    plot(rrme(:,2), 'gx:');
    plot(rrme(:,3), 'bx:');
    ylim([min(min(rrme)) max(max(rrme))]);
    legend('dX (-KF, ..3D-OD)', 'dY (-KF, ..3D-OD)', 'dZ (-KF, ..3D-OD)');
%     plot([0 nKF], [moyrres(1) moyrres(1)], 'r-');
%     plot([0 nKF], [moyrres(2) moyrres(2)], 'g-');
%     plot([0 nKF], [moyrres(3) moyrres(3)], 'b-');
    subplot(3,2, [3 4]);
    semilogy(lKg, 'b-'); hold on;
    semilogy(ldP, 'b:');
    ylim([1e-5 1e5]);
    legend('Kalman gain, det(K''*K)', 'det(P)');
    subplot(3,2, [5 6]);
    plot(ves, 'kx-'); hold on;
    legend('Velocity (km/s)');
end

% ------------
% interpretation: absolute values
if iDebug==10
    Xn=X;
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
end

