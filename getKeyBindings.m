function KEYS = getKeyBindings(responseList)

for i=1:length(responseList)
    %prompt the user
    disp(sprintf('Press the key for %s...',responseList{i}))
    % get the key bindings
    [KEYS.(responseList{i}).NUM, KEYS.(responseList{i}).CHAR] = testKey;
end


    