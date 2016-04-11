% expertObs
%  observd = extractObs(epochs, TimeList1, lat1, long1);
%  predict = prepareObs(epochs, TimeList0, lat0, long0, distance0);
figure(1);
%subplot(121); hold on; plot(predict(:,2), predict(:,1), 'xk', observd(:,2), observd(:,1), 'ob');
%subplot(122); hold on; plot((observd(:,2)-predict(:,2))*3600., (observd(:,1)-predict(:,1))*3600., '-b');

% expertise des matrices C et D contenant les sine et cosine
% [C(1,13), C(4,14), C(7,15), C(10,16); C(2,13), C(5,14), C(8,15), C(11,16); C(3,13), C(6,14), C(9,15), C(12,16)]
% [D(1,1), D(4,3), D(7,5), D(10,7); D(2,1), D(5,3), D(8,5), D(11,7); D(2,2), D(5,4), D(8,6), D(11,8); D(3,2), D(6,4), D(9,6), D(12,8)]
% Dans le cas P1 (et P2), planète dans le plan du déplacement (lat ne change pas), on perd des infos => dégénérescence?
% Dans le cas P3, planète dans le plan du mouvement (long ne change pas) on perd aussi des infos
% Dans le cas de P4, planète hors plan du mouvement...?
