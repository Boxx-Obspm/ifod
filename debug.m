% iDebug=0; % switch for debug mode
graphs = false; % plots graphs
writes = true; % save detailed data in binary format into <outputs>_bin
% ------------
% iDebug==0 : no debug mode
% iDebug==1,2,3,4 : relates to KF monitoring
% iDebug==10,11 : relates to Monte-Carlo results
% iDebug==20 : relates to the analysis of the 3D inverted solution
% ------------
if iDebug==1
  % memory allocations
  nbPts=nKF-Nobs+1;
  ndebug=0;
  rex  = double(zeros(nbPts+1,3));
  rme  = double(zeros(nbPts+1,3));
  rkf  = double(zeros(nbPts+1,3));
  vkf  = double(zeros(nbPts+1,1));
  tst  = double(zeros(nbPts+1,1)); tst0=epochs(3);
  lKg  = double(zeros(nbPts+1,1));
  ldP  = double(zeros(nbPts+1,1));
  dtrm = double(zeros(1,nbPts+1));
  dlgm = double(zeros(1,nbPts+1));
  dtrk = double(zeros(1,nbPts+1));
  dlgk = double(zeros(1,nbPts+1));
end
% ------------
if iDebug==2
    ndebug=ndebug+1;
    rex(ndebug,:) = (refLoc + Xexp(7:9))';   % Expected results
    rme(ndebug,:) = (refLoc + X(7:9))';      % "Measured" results (3D-OD)
    rkf(ndebug,:) = refLoc' + nState(1:3)'.*fx; % "Kalman Filterd" results
    vkf(ndebug)   = norm(nState(4:6)).*fv;  % "Kalman Filtered" velocity
    tst(ndebug)   = (epochs(3)-tst0).*24;   % elapsed time (in hours)
    lKg(ndebug)   = Kg;
    ldP(ndebug)   = det(nSigma);
    unitvvector(1) = interp1(TimeList1, vel0(:,1), epochs(3), 'linear');
    unitvvector(2) = interp1(TimeList1, vel0(:,2), epochs(3), 'linear');
    unitvvector(3) = interp1(TimeList1, vel0(:,3), epochs(3), 'linear');
    unitvvector = unitvvector./norm(unitvvector);
    %==> as expected:
    trx = norm(cross(Xexp(7:9)', unitvvector));
    lgx = dot(Xexp(7:9), unitvvector);
    %==> as computed:
    dtrm(ndebug) = norm(cross(X(7:9)', unitvvector)) - trx;
    dtrk(ndebug) = norm(cross(fx*nState(1:3)', unitvvector)) - trx;
    dlgm(ndebug) = dot(X(7:9)', unitvvector) - lgx;
    dlgk(ndebug) = dot(fx*nState(1:3)', unitvvector) - lgx;
end
% ------------
if iDebug==3
    ndebug=ndebug+1; % must be ndebug = nbPts+1
    rex(ndebug,:) = (refLoc + Xexp(13:15))';   % Expected results
    rme(ndebug,:) = (refLoc + X(13:15))';      % "Measured" results (3D-OD)
    rkf(ndebug,:) = refLoc' + nState(1:3)'.*fx; % "Kalman Filterd" results
    vkf(ndebug)   = norm(nState(4:6)).*fv;  % "Kalman Filtered" velocity
    tst(ndebug)   = (epochs(5)-tst0).*24;   % elapsed time (in hours)
    lKg(ndebug)   = Kg;
    ldP(ndebug)   = det(nSigma);
    unitvvector(1) = interp1(TimeList1, vel0(:,1), epochs(5), 'linear');
    unitvvector(2) = interp1(TimeList1, vel0(:,2), epochs(5), 'linear');
    unitvvector(3) = interp1(TimeList1, vel0(:,3), epochs(5), 'linear');
    unitvvector = unitvvector./norm(unitvvector);
    %==> as expected:
    trx = norm(cross(Xexp(13:15)', unitvvector));
    lgx = dot(Xexp(13:15), unitvvector);
    %==> as computed:
    dtrm(ndebug) = norm(cross(X(13:15)', unitvvector)) - trx;
    dtrk(ndebug) = norm(cross(fx*nState(1:3)', unitvvector)) - trx;
    dlgm(ndebug) = dot(X(13:15)', unitvvector) - lgx;
    dlgk(ndebug) = dot(fx*nState(1:3)', unitvvector) - lgx;
end
% ------------
if iDebug==4
    rrkf=rkf-rex; % residual from KF-results
    rrme=rme-rex; % residual from 3D-OD results
    % largest max on x, y or z found for the rest of the KF processing
    mxkf=max(abs(rrkf),[],2);
    mmkf = double(zeros(1,nbPts+1));
    mmtk = double(zeros(1,nbPts+1));
    mmlk = double(zeros(1,nbPts+1));
    for iid=1:nbPts+1
      mmkf(iid)=max(mxkf(iid:nbPts+1));
      mmtk(iid)=max(abs(dtrk(iid:nbPts+1)));
      mmlk(iid)=max(abs(dlgk(iid:nbPts+1)));
    end

   if (writes)
    % file was created in (iDebug==10) section
    fw = fopen([outputs '_bin'],'a');
    fwrite(fw, ...
        [rex rrme rrkf lKg ldP vkf dtrm' dlgm' dtrk' dlgk' mmkf' mmtk' mmlk']', ...
        'double');
    % Z = fread(fw, 3, 'uint32'); % first reading, will provide a 1x3 uint32 array
    % % then with
    %   nbPts=Z(2)-Z(1)+1; % (nbPts=nKF-Nobs+1;)
    %   DATA = fread(fw, (3*3+10)*(nbPts+1), 'double');
    % % will read the detailed value for 1 Monte-Carlo cycle,
    % % to be reshaped into (nbPts+1) lines with:
    %   reshape(DATA, (3*3+10), nbPts)'; % (nbPts+1) lines x (3*3+10) columns
    fclose(fw);
   end
   if (graphs)
    % chronogrammes
    figure(102); clf;
    subplot(4,3, [1 3]);
    plot(rrkf(:,1), 'r-'); hold on;
    plot(rrkf(:,2), 'g-');
    plot(rrkf(:,3), 'b-');
    plot(rrme(:,1), 'rx:');
    plot(rrme(:,2), 'gx:');
    plot(rrme(:,3), 'bx:');
%     ylim([min(min(rrme)) max(max(rrme))]);
   ylim([-5*mmkf(nbPts*3/4) 5*mmkf(nbPts*3/4)]);
    title('Residuals dX, dY, dZ (km)');
    legend('dX (-KF, ..3D-OD)', 'dY (-KF, ..3D-OD)', ...
        'dZ (-KF, ..3D-OD)', 'Location', 'SouthWest');
    plot(mmkf, 'k:'); plot(-mmkf, 'k:');
    subplot(4,3, [4 6]);
    plot(dtrk, 'r-'); hold on;
    plot(dtrm, 'gx:');
%     ylim([-2*std(dtrm) 2*std(dtrm)]);
    ylim([-5*mmtk(nbPts*3/4) 5*mmtk(nbPts*3/4)]);
    plot(mmtk, 'r:'); plot(-mmtk, 'r:');
    title('Residual in transversal shift (km)');
    subplot(4,3, [7 9]);
    plot(dlgk, 'r-'); hold on;
    plot(dlgm, 'gx:');
%     ylim([-2*std(dlgm) 2*std(dlgm)]);
    ylim([-5*mmlk(nbPts*3/4) 5*mmlk(nbPts*3/4)]);
    plot(mmlk, 'r:'); plot(-mmlk, 'r:');
    title('Residual in longitudinal shift (km)');

    subplot(4,3, 10);
    plot(rrme(:,1),rrme(:,2),'gx:'); hold on;
    plot(rrkf(:,1),rrkf(:,2),'r-');
    plot(rrkf(nbPts,1),rrkf(nbPts,2),'ks');
    axis([min(rrme(:,1)) max(rrme(:,1)) min(rrme(:,2)) max(rrme(:,2))]);
%     axis equal;
%     legend('KF', '3D-OD', 'final KF');
    title(['dY=f(dX), km']);
    subplot(4,3, 11);    
    plot(rrme(:,1),rrme(:,3),'gx:'); hold on;
    plot(rrkf(:,1),rrkf(:,3),'r-');
    plot(rrkf(nbPts,1),rrkf(nbPts,3),'ks');
    axis([min(rrme(:,1)) max(rrme(:,1)) min(rrme(:,3)) max(rrme(:,3))]);
%     axis equal; 
%     legend('KF', '3D-OD', 'final KF');
    title(['dZ=f(dX), km']);
    subplot(4,3, 12);
    plot(rrme(:,2),rrme(:,3),'gx:'); hold on;
    plot(rrkf(:,2),rrkf(:,3),'r-');
    plot(rrkf(nbPts,2),rrkf(nbPts,3),'ks');
    axis([min(rrme(:,2)) max(rrme(:,2)) min(rrme(:,3)) max(rrme(:,3))]);
%     axis equal; 
%     legend('KF', '3D-OD', 'final KF');
    title(['dZ=f(dY), km']);

    figure(103); clf;
    subplot(2,1,1);
	% 
	% Plutot visualiser les évolutions d'erreur en transveral et logitudinal p.r.vitesse
	% de plus, la position finale obtenue est à une date passee, il faudrait comparer
    % la prédiction à la date en cours avec l'attendu
	%
    semilogy(lKg, 'b-'); hold on;
    semilogy(ldP, 'b:');
    ylim([1e-5 1e5]);
    legend('Kalman gain, det(K''*K)', 'det(P)');
    subplot(2,1,2);
	% 
	% on dirait un delta-V et non un Velocity
	%
    semilogy(vkf, 'kx-'); hold on;
    legend('Velocity (km/s)');
   end
end

% ------------
if iDebug==10
   if (writes)
     % initizes the binary outputs with the number of written columns
     fw = fopen([outputs '_bin'],'w');
     fclose(fw);
     t0debug = now; strstart = datestr(t0debug,'yyyy-mm-ddTHH:MM:SS');
     t0cpu = cputime;
     scndebug = [fscenario pfix];
     fw = fopen('ifod_log','a');
     pid = 0; % default (if MATLAB local run)
     if (runInOctave) pid = getpid(); end % OCTAVE run
     fprintf(fw,'%s %s PID: %5i starting \n', strstart, scndebug, pid);
     fclose(fw);
   end
   if (graphs)
    figure(11); clf(11);
    subplot(2,1,1); hold on;
    plot([0 min([NbLT1 simLims(3)])-TimeList1(1)], [0. 0.], '-k');
    subplot(2,1,2); hold on;
    plot([0 min([NbLT1 simLims(3)])-TimeList1(1)], [0. 0.], '-k');
   end
end
% ------------
if iDebug==11
   if (writes)
    fw = fopen([outputs '_bin'],'a');
    fwrite(fw, [obstime(ik+nKF-2) obstime(ik+nKF)], 'double');
    fwrite(fw, [Nobs nKF nbCycles (ik+nKF==length(obstime))], 'uint32');
    % Z = fread(fw, 3, 'uint32'); will provide a 1x3 uint32 array
    fclose(fw);
    dtdebug = floor((now-t0debug)*1440.); % mn elapsed time in the OCTAVE process
    strnow = datestr(now,'yyyy-mm-ddTHH:MM:SS');
    dtcpu = floor((cputime-t0cpu)/60); % mn CPU (?) in the OCTAVE process
    fw = fopen('ifod_log','a');
    fprintf(fw,'%s %s PID: %5i %5imn [ %4imn CPU] since %s, time-step: %3i\n', ...
        strnow, scndebug, pid, dtdebug, dtcpu, strstart, ii);
    fclose(fw);
   end
end
% ------------
if iDebug==12
   if (graphs)
    figure(11);
    subplot(2,1,1);
    plot(epochs(Nobs)-TimeList1(1), data(4)-data(3), 'or');
    errorbar(epochs(Nobs)-TimeList1(1), data(4)-data(3), data(5), 'r');
%     idy=find(abs(data(:,4))<=2*mm(4)); mn1=mean(data(idy,4)-data(idy,3)); sg1 = max([.001 std(data(:,5))]); ylim([mn1-3*sg1 mn1+3*sg1]);
%     xlim([0 tlim]); ylim([-2500 2500]);
    xlabel('time (days)'); ylabel('Shift error (km)');  title('Transversal error');
    set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
    %
    subplot(2,1,2);
    plot(epochs(Nobs)-TimeList1(1), data(7)-data(6), 'or');
    errorbar(epochs(Nobs)-TimeList1(1), data(7)-data(6), data(8), 'r');
%     idy=find(abs(data(:,7))<=2*mm(7)); mn2=mean(data(idy,7)-data(idy,6)); sg2 = max([.001 std(data(:,8))]); ylim([mn2-3*sg2 mn2+3*sg2]);
%     xlim([0 tlim]); ylim([-6500 +6500]);
    xlabel('time (days)'); ylabel('Shift error (km)'); title('Longitudinal error');
    set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
   end
end
% ------------
% interpretation: absolute values
if iDebug==20
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

