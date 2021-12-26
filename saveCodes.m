function [session] = saveCodes(session)
% save all codes used for running the experiment in a unique folder for
% each subject

cl = clock;
prf = sprintf('sub-%d-%s-%d-%d-%d',session.subjnum, date,cl(4),cl(5),round(cl(6)));
status(1) = copyfile([cd '*.m'],sprintf('..%ccodes_by_run%c%s%c', filesep, filesep, prf,filesep));
status(2) = copyfile([cd '*.mat'],sprintf('..%ccodes_by_run%c%s%c', filesep, filesep, prf,filesep));

if ~all(status)
    session.error = 'Codes not saved';
end

end

