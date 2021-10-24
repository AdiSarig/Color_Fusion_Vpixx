function trials = runFaceHousePreview_13(params)
params.timing.nON = 60;

trials = prepTrials_faceHousePreview_13(params);
[trials,w] = oneRun('ignore',trials,params,[],[1 1],1,false); %run 1 part

Screen('CloseAll');


nCorrect = 0;

for i = 1:length(trials)
   if strmatch(trials(i).stimCat, upper(KbName(trials(i).resp)))  
       nCorrect = nCorrect + 1;
   end
end

correctness = int8(nCorrect/length(trials)*100);

disp(sprintf('\n%d perc correct \n%d',...
    correctness));




%     if upper(KbName(trials(i).resp)) == trials(i).stimCat
%         params.correct = params.correct + 1;
%     end 
% 
% for i=1:length(trials)
%     tmp = KbName(trials(i).resp(1,:));
%     if isempty(tmp)
%         tmp = nan;
%     elseif iscell(tmp)
%         if length(tmp)==1
%             tmp=tmp{1};
%         else
%             tmp=nan;
%         end
%     end
%     switch tmp
%         case {'f'}
%             trials(i).respc = 'F';
%         case {'h'}
%             trials(i).respc = 'H';
%         otherwise
%             trials(i).respc = '?';
%     end
% end
% 
% for i = 1:length(trials)
%    trials(i).acc = trials(i).respc == trials(i).stimCat;
% end
