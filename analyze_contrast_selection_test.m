% Analyze contrast selection test

data = trials_contrast;

%% Accuracy
stimType = extractfield(data, 'stimCat');
F_trials = strcmp(stimType, 'F');
resp_f = [data.resp] == session.params.resp.face;
correct_f = F_trials & resp_f;

H_trials = strcmp(stimType, 'H');
resp_h = [data.resp] == session.params.resp.house;
correct_h = H_trials & resp_h;

accuracy = correct_f | correct_h;

%% Accuracy C condition
c_condition = [data.DCF] == 0;
total = sum(c_condition);
c_accuracy = sum(accuracy(c_condition))/total;

%% Accuracy UC condition
uc_condition = [data.DCF] == 1;
uc_accuracy = sum(accuracy(uc_condition))/total;

%% Plot accuracy
figure()
X = categorical({'Visible', 'Invisible'});
X = reordercats(X,{'Visible', 'Invisible'});
b = bar(X, [c_accuracy, uc_accuracy], 0.4);
ylabel('Accuracy');
ylim([0 1.1]);
labels1 = string(round(b(1).YData,2));
text(b.XData,b.YData,labels1,'VerticalAlignment','bottom','HorizontalAlignment','center')

% If accuracy is above 75% - performance is higher than chance (uncomment
% the next line to check)
% binoinv([0.025 0.975], 16, 0.5)/16;

% Draw cutoff line
% hold on
% plot(xlim,[0.75 0.75], 'r');

grid on
line(xlim, [0.75 0.75], 'Color', 'r', 'LineWidth', 2);


