function answer = askQuestion(msgText, options)
%%
% Asks question and waits as long as correct input is provided by the user.
% Possible options for answer are shown (entries form *options* argument).
%% Inputs
% *msgText* - char; Question.
%
% *options* - cell; Chars, each one is possible answer.
%
%% Outputs
% *answer* - char; Answer that was chosen by the user.
%
%%

%% check
if ~ischar(msgText)
    error('empty msgText argument or wrong type')
end
if ~iscellstr(options)
    error('empty options argument or wrong type')
end

if( strcmp('', msgText) || isempty(msgText) )
   error('Empty message !')
end

if(~iscellstr(options)) error('ERROR: options argument: not a valid type (should be cell with strings)'); end
if(length(unique(options)) < length(options)) error('ERROR: Repeating options to choose !'); end
if(isequal(options, {})) error('ERROR: options argument is empty cell {}'); end
%% ask

disp('Choose one option as an answer to question below: ')
disp(options)
if(length(options) == 1) warning('Only one option to choose ... :( '); end

inputText = input(msgText,'s');

while ~ismember(inputText, options)

    inputText = input(msgText,'s');

end

disp('Valid choice.')
answer = inputText;
