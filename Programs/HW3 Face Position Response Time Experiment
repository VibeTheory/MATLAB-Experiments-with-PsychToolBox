% Simple experiment to measure and record patient response time to changes 
% in position of a face in the visual field.
% In each trial, participants are presented with a face image in the 
% center of the screen, and after some amount of time, shown the same face 
% again in a location shifted in some direction as specified by the 
% trialType vector (up = 1, down = 2, left = 3, right = 4).
% Author: Brandon Achugbue (08/15/22)

%% SETUP
clear all   % clear variables, settings
clc         % clear command window
close all   % close figure windows
sca         % close PsychToolbox windows
rng shuffle % seed the random number generator based on the current time

% standard setup
Screen('Preference', 'VisualDebugLevel', 1)                              ; % suppress Psychtoolbox welcome screen
Screen('Preference', 'SkipSyncTests'   , 1)                              ; % skip synchronization tests that can cause errors
ListenChar(2)                                                              % suppress keyboard input
HideCursor                                                                 % hide mouse cursor

% open a window
allScreenNums       = Screen('Screens')                                  ; % vector of screen numbers for the available monitors
mainScreenNum       = max(allScreenNums)                                 ; % main screen number
backgroundColor     = [0 0 0]                                            ; % definebackground color (black)
w = PsychImaging('OpenWindow', mainScreenNum, backgroundColor)           ; % open afull screen window

% define reference points
[wWidth, wHeight]   = Screen('WindowSize', w)                            ; % width and height of window 'w' in pixels
xmid                = round(wWidth  / 2)                                 ; % horizontal midpoint of 'w' in pixels
ymid                = round(wHeight / 2)                                 ; % vertical   midpoint of 'w' in pixels

% define rects for each quadrant of the screen
quadRectTopLeft     = [ 0    , 0    , xmid   , ymid    ]                 ;
quadRectTopRight    = [ xmid , 0    , wWidth , ymid    ]                 ;
quadRectBottomLeft  = [ 0    , ymid , xmid   , wHeight ]                 ;
quadRectBottomRight = [ xmid , ymid , wWidth , wHeight ]                 ;

% set blend function for anti-aliasing (makes certain drawing smoother)
Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA')     ;

% obtain refresh rate of the monitor
avgFlipInterval = Screen('GetFlipInterval', w) ; % get average flip interval for window w
avgRefreshRate = FrameRate(w)                  ; % get refresh rate of monitor

% define key-numbers
KbName('UnifyKeyNames')                                                    % use Mac OS key-names
keyNumSpace         = min( KbName('space') )                             ; % key-number for spacebar
keyNumReturn         = min( KbName('Return') )                           ; % key-number for return
keyNumE             = min( KbName('e'   ) )                              ; % key-number for e key
keyNumX             = min( KbName('x'   ) )                              ; % key-number for e key

% text settings
Screen('TextSize' , w, round(wHeight/30))                                ; % set text size
Screen('TextFont' , w, 'Arial')                                          ; % set font to Arial
Screen('TextStyle', w, 0)                                                ; % use normal text
mainTextColor       = 255                                                ; % define main text color (cyan)
warningTextColor    = [255 128 0]                                        ; % define warning text color (orange)

% coordinates to center the subject number prompt horizontally and vertically
subjectNumPromptRect = Screen('TextBounds', w, 'Enter subject number: ') ; % rect giving dimensions of the prompt
subjectNumPromptX    = round(xmid - subjectNumPromptRect(3) / 2)         ; % x-coordinate for left edge   of prompt text
subjectNumPromptY    = round(ymid - subjectNumPromptRect(4) / 2)         ; % y-coordinate for bottom edge of prompt text


% import samjack.png image file
samJackRGB        = imread('samjack.png')                                ; % import samJack image into RGB array
reducedSamJackRGB = samJackRGB / 3                                       ; % reduce the brightness in RGB array to 1/3 of the original 
samJackTexture    = Screen('MakeTexture', w, reducedSamJackRGB)          ; % texture pointer for samJack image (single number)

% compute width/height ratio of original samJack image
samJackWidthHeightRatio = size(samJackRGB, 2) / size(samJackRGB, 1)      ;
samJackHeight = round(wHeight/2)                                         ;
samJackWidth  = round(samJackHeight * samJackWidthHeightRatio)           ;

samJackBaseRect = [0 0 samJackWidth samJackHeight]                       ; % define base rect for samJack texture

startXCoord = xmid - samJackWidth/2                                      ; % x coordinate of image rect centered on screen
startYCoord = ymid - samJackHeight/2                                     ; % y coordinate of image rect centered on screen

% define 5 rects for where the face will appear on the screen
faceRectStart = samJackBaseRect + [startXCoord startYCoord startXCoord startYCoord] ;
shift = round(wHeight/8) ; % amount to shift faceRects by

faceRects = [ faceRectStart + [     0 -shift      0 -shift]
              faceRectStart + [     0  shift      0  shift]
              faceRectStart + [-shift      0 -shift      0]
              faceRectStart + [ shift      0  shift      0] ]' ;

%faceRectUp    = faceRectStart + [     0 -shift      0 -shift] ;
%faceRectDown  = faceRectStart + [     0  shift      0  shift] ;
%faceRectLeft  = faceRectStart + [-shift      0 -shift      0] ;
%faceRectRight = faceRectStart + [ shift      0  shift      0] ;


% prime Psychtoolbox functions that will be used
KbCheck ;
GetMouse ;
RestrictKeysForKbCheck([]) ;
GetSecs ;
DrawFormattedText(w, '') ;
Screen('DrawTexture', w, samJackTexture) ; 
Screen('FillRect', w, backgroundColor) ;
Screen('Flip', w) ;

% initialize variable for number of trials
numTrials     = 20                    ;

% define a vector of trial-types (1-4)
trialTypeTemp         = [1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4] ; % unshuffled vector of condition codes
trialTypeShuffleOrder = randperm(20)                              ; % integers 1 thru 20 in random order
trialType             = trialTypeTemp(trialTypeShuffleOrder)      ; % shuffled condition-codes

% vector that defines when a shift will occur (in seconds after the face appears)
delayNominal  = unifrnd(3, 7, [1 20]) ; % row vector of 20 independently sampled random values between 3 & 7 (nonintegers)

% vector that consists of the values in delayNominal adjusted a half flip-interval lower
delayAdjusted = delayNominal - avgFlipInterval/2 ;
% initialize vector of time elapsed between face actually appearing at original position 
% and face actually appearing at new position for each trial
delayActual   = NaN(1, 20) ;

% intialize vector of subject response times (in seconds) for each trial
responseTime  = NaN(1, 20) ; 

% text for experiment prompts
experimentPromptText = 'In each round of this experiment, you will see a face.\nAfter a few seconds, the face will change position.\nYour task is to press the spacebar as quickly as possible\nonce you notice the change.\nPress <Return> to begin.' ;
postTrialText        = 'Press <Return> to do another round.' ;
postExperimentText   = 'That''s the end of the experiment.\nThank you!' ;  

% Priority( MaxPriority(w) )  ; % prioritize Psychtoolbox display performance

%% ENTER SUBJECT NUMBER

isSubjectNumValid = 0 ; % initialize flag for valid subject number

% prompt user to enter a subject number
while ~isSubjectNumValid
    subjectNumChar = GetEchoString(w, 'Enter subject number: ', subjectNumPromptX, subjectNumPromptY, mainTextColor, backgroundColor) ; % input age as character array
    Screen('FillRect', w, backgroundColor) ; % erase text by filling screen with rectangle in the background color
    
    subjectNum = str2double(subjectNumChar)  ; % convert age from char to double value
    
    if ismember(subjectNum, 1:1000) && ~isnan(subjectNum) % if the response is valid
        isSubjectNumValid = 1 ;                           % update flag for valid subject number
    else    
        DrawFormattedText(w, 'INVALID SUBJECT NUMBER', 'center', 'center', warningTextColor) % if invalid subject num, draw error message                                             ;
        Screen('Flip', w) ;             % and display error message
        WaitSecs(1) ;                   % and wait 1 second
    end
end

%% EXPERIMENT

% give instructions and prompt user to press enter
DrawFormattedText(w, experimentPromptText, 'center', 'center', mainTextColor)                                    ;
Screen('Flip', w) ; % put text on screen

% wait for fresh <Return> key-press and release before starting trials
while KbCheck(-1)                       % wait for all keys to be up
end
RestrictKeysForKbCheck(keyNumReturn) ;  % restrict keyboard input to Return key
while ~KbCheck(-1)                      % and wait for any key to be down
end
while KbCheck(-1)                       % wait for all keys to be up again
end
RestrictKeysForKbCheck([])           ;  % stop disregarding keys

for iTrial = 1:numTrials                % for 20 trials
    
    % display the face at the center of the screen
    Screen('DrawTexture', w, samJackTexture, [], faceRectStart) ; % draw samJack texture in center of the screen
    centerSecs = Screen('Flip', w)                              ; % put samJack texture on screen and get timestamp for flip
    
    % display the face at 1 of 4 shifted locations
    Screen('DrawTexture', w, samJackTexture, [], faceRects(:, trialType(iTrial))) ; % draw samJack texture at designated new location
    % put samJack texture on screen after the designated delay for the trial, and get timestamp for flip
    spacePromptSecs = Screen('Flip', w, centerSecs + delayAdjusted(iTrial) - avgFlipInterval/2) ; 
    
    % wait for fresh <space> key-press and release
    while KbCheck(-1)                                          % wait for all keys to be up
    end
    
    RestrictKeysForKbCheck(keyNumSpace)                      ; % restrict keyboard input to space key
    % stay in while-loop until space pressed
    spacePressed = 0                                         ; % initialize invalid flag for spacebar pressed
    while ~spacePressed
    [spacePressed, spacePressSecs] = KbCheck(-1)             ; % check keyboard, get timestamp for key-press
    end
    
    while KbCheck(-1)                                          % wait for all keys to be up again
    end
    RestrictKeysForKbCheck([])                               ; % stop disregarding keys

    % record response time for the trial (time elapsed from face at new location to spacebar press)
    responseTime(iTrial) = spacePressSecs - spacePromptSecs  ; % time elapsed since target prompt
   
    % record the actual delay (time elapsed from face at original position to face at new position)
    delayActual(iTrial) = spacePromptSecs - centerSecs       ; % time elapsed from pretarget stimulus to target
        
    %%%%Screen('FillRect', w, backgroundColor) ; % clear the screen    not needed? 
    
    if iTrial < numTrials                                                                    % if it's not the last trial
        DrawFormattedText(w, postTrialText, 'center', 'center', mainTextColor)      ; % write post-trial message text
        Screen('Flip', w)                                                           ; % put text on screen

        % wait for fresh <Return> key-press and release before continuing to the next trial
        
        while KbCheck(-1)                       % wait for all keys to be up
        end
        RestrictKeysForKbCheck(keyNumReturn) ;  % restrict keyboard input to Return key
        while ~KbCheck(-1)                      % and wait for any key to be down
        end
        while KbCheck(-1)                       % wait for all keys to be up again
        end
        RestrictKeysForKbCheck([])           ;  % stop disregarding keys
    
    else                                                                              % if it is the last trial    
        DrawFormattedText(w, postExperimentText, 'center', 'center', mainTextColor) ; % write closing message
        Screen('Flip', w)                                                           ; % clear screen and put text on screen
    end
    
end

%% SAVE & EXIT

% save a .mat datafile that contains all important variables in the workspace
save(['psych20bhw3_subj' num2str(subjectNum)], 'subjectNum', 'responseTime', 'trialType', 'delayNominal', 'delayAdjusted', 'delayActual', 'wWidth', 'wHeight', 'quadRectTopLeft', 'quadRectTopRight', 'quadRectBottomLeft', 'quadRectBottomRight', 'faceRectStart', 'faceRects', 'avgFlipInterval')

% exit code
keyCode = zeros(1, 256)                                                  ; % initialize keyCode vector
mouseButtons = [0 0 0]                                                   ; % initialize mouse buttons statuses
exitCodeEntered = 0                                                      ; % initialize invalid flag for exit code entered

while ~exitCodeEntered                                                     % while the exit code hasn't been entered
    
    [~, ~, keyCode]                = KbCheck(-1)                         ; % get vector of key statuses
    [mouseX, mouseY, mouseButtons] = GetMouse(w)                         ; % get mouse position and button statuses

    if sum( keyCode([keyNumE keyNumX]) ) == 2 ...                          % if E and X are being pressed
            && sum( keyCode ) == 2 ...                                     % and no other keys are being pressed
            && any(mouseButtons)                                           % and any mouse button is being pressed
        exitCodeEntered = 1                                              ; % update exit code entered flag
    end
    
end

% get out
ListenChar(1)        % restore keyboard input
sca                  % close PsychToolbox windows and restore mouse cursor

% Priority(0) ;        % reset Psychtoolbox display priority to normal
