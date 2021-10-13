clear; close all; clc;

% answer = askQuestion(msgText, options)
passed = 0;
total = 0;

options = {'yes', 'no'};


%%
msgText = [];
try
    askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

msgText = {};
try
    askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

msgText = {'foo'};
try
    askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

msgText = 4;
try
    askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

msgText = 2.4;
try
    askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

% correct
msgText = 'Is Earth flat?';
try
    askQuestion(msgText, options);
    passed = passed + 1;
catch
end
total = total+1;


%%
options = [];
try
askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

try
options = {}; % no options
askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;


options = 4;
try
askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

options = 2.4;
try
askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

options = {1, 'foo'}; % mixed type
try
askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

options = {'y', 'y', 'n'}; % repeating options
try
askQuestion(msgText, options);
catch
    passed = passed + 1;
end
total = total+1;

options = {'foo'}; % single option
try
    askQuestion(msgText, options);
    passed = passed + 1;
catch
end
total = total+1;


%% SUMMARY
disp(['Tests finished. Passed ', num2str(passed), ' / ', num2str(total), '.']);
