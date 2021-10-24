


session = initSession('DCM_Pilot');

[p,P]=run_calibration;

save(sprintf('subj%02d_sess%02d_lumFunc_%s.mat',session.subjnum,session.sessnum,datestr(now,30)),'p','P','beta');

session.params = initParams(p);

runFaceHousePreview;

