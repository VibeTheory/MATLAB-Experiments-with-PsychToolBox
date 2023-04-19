% PSYCH 20B Homework 2
% Display text of various colors at various screen-positions.
% Author: Brandon Achugbue (08/15/22)

%% SETUP

clear all   % clear variables, settings
clc         % clear command window
close all   % close figure windows
sca         % close PsychToolbox windows

% standard setup
Screen('Preference', 'VisualDebugLevel', 1)                              ; % suppress Psychtoolbox welcome screen
Screen('Preference', 'SkipSyncTests'   , 1)                              ; % skip synchronization tests that can cause errors

ListenChar(2)                                                              % suppress keyboard input
HideCursor                                                                 % hide mouse cursor

% open a window
allScreenNums       = Screen('Screens')                                  ; % vector of screen numbers for the available monitors
mainScreenNum       = max(allScreenNums)                                 ; % main screen number

backgroundColor     = [0 0 0]                                            ; % define background color (black)

w = PsychImaging('OpenWindow', mainScreenNum, backgroundColor)           ; % open a full screen window

% define reference points
[wWidth, wHeight]   = Screen('WindowSize', w)                            ; % width and height of window 'w' in pixels
xmid                = round(wWidth  / 2)                                 ; % horizontal midpoint of 'w' in pixels
ymid                = round(wHeight / 2)                                 ; % vertical   midpoint of 'w' in pixels

% define key-numbers
KbName('UnifyKeyNames')                                                    % use Mac OS key-names
keyNumSpace         = min( KbName('space') )                             ; % key-number for spacebar
keyNumY             = min( KbName('y'   ) )                              ; % key-number for y key
keyNumN             = min( KbName('n'   ) )                              ; % key-number for n key
keyNumE             = min( KbName('e'   ) )                              ; % key-number for e key
keyNumX             = min( KbName('x'   ) )                              ; % key-number for e key
keyNumI             = min( KbName('i'   ) )                              ; % key-number for e key
keyNumT             = min( KbName('t'   ) )                              ; % key-number for e key

% text settings
Screen('TextSize' , w, round(wHeight/30))                                ; % set text size
Screen('TextFont' , w, 'Arial')                                          ; % set font to Arial
Screen('TextStyle', w, 0)                                                ; % use normal text

% text colors
mainTextColor       = [0 255 255]                                        ; % define main text color (cyan)
warningTextColor    = [255 128 0]                                        ; % define warning text color (orange)

% set blend function for anti-aliasing (makes certain drawing smoother)
Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA')     ;

% define rects for each quadrant of the screen
quadRectTopLeft     = [ 0    , 0    , xmid   , ymid    ]                 ;
quadRectTopRight    = [ xmid , 0    , wWidth , ymid    ]                 ;
quadRectBottomLeft  = [ 0    , ymid , xmid   , wHeight ]                 ;
quadRectBottomRight = [ xmid , ymid , wWidth , wHeight ]                 ;

%% SURVEY

% prompt user to press spacebar & put text on screen
DrawFormattedText(w, 'Press the spacebar to continue', 'center', 'center', mainTextColor)                                         ;
Screen('Flip', w)                                                        ;

isSpacePressed = 0                                                       ; % initialize spacebar status

RestrictKeysForKbCheck(keyNumSpace)                                      ; % ignore all keys except space
KbWait(-1,3)                                                               % wait for fresh key-press and release

% ask question 1 (glasses) & put text on screen
DrawFormattedText(w, 'Do you wear glasses or other corrective lenses?\n(Y) Yes  (N) No', 'center', 'center', mainTextColor)       ;
Screen('Flip', w)                                                        ;

keyCode = zeros(1, 256)                                                  ; % initialize keyCode vector
RestrictKeysForKbCheck([keyNumY keyNumN])                                ; % ignore all keys except y and n

while ~keyCode(keyNumY) && ~keyCode(keyNumN)                               % while y isn't pressed and n isn't pressed
    [~, keyCode] = KbWait(-1, 3)                                         ; % wait for fresh key-press and release
                                                                           % get vector of key-statuses
end
                                   
% record glasses response
if keyCode(keyNumN)                                                        % if subjected responded n
    glasses = 0                                                          ; % they don't wear glasses
elseif keyCode(keyNumY)                                                    % if subject responded y
    glasses = 1                                                          ; % they wear glasses
end

% ask question 2 (color blindness) & put text on screen
DrawFormattedText(w, 'Do you know or suspect that you have color blindness?\n(Y) Yes  (N) No', 'center', 'center', mainTextColor) ;
Screen('Flip', w)                                                        ;

keyCode = zeros(1, 256)                                                  ; % initialize keyCode vector

while ~keyCode(keyNumY) && ~keyCode(keyNumN)                               % while y isn't pressed and n isn't pressed
    [~, keyCode] = KbWait(-1, 3)                                         ; % wait for fresh key-press and release
                                                                           % get vector of key-statuses
end

% record color blindness response
if keyCode(keyNumN)                                                        % if subjected responded n
    colorBlind = 0                                                       ; % they don't think they are color blind
elseif keyCode(keyNumY)                                                    % if subject responded y
    colorBlind = 1                                                       ; % they think they are color blind
end

RestrictKeysForKbCheck([])                                               ; % stop ignoring keys

% question 3 (age in years)
age = 0                                                                  ; % initialize age as invalid value

while ~ismember(age, 10:100)  ||  isnan(age)                               % stay in while-loop until whole-number between 10 and 100 entered
    
    % get age input
    ageChar = GetEchoString(w, 'What is your age in years?', xmid, ymid, mainTextColor, backgroundColor)                          ;
    
    age = str2double(ageChar)                                            ; % convert age from char to double value
    Screen('FillRect', w, backgroundColor)                               ; % draw full-screen rectangle in background color (to erase GetEchoString text)

    % if the response is invalid, give warning text
    if ~ismember(age, 10:100) || isnan(age)     
        DrawFormattedText(w, 'INVALID AGE', 'center', 'center', warningTextColor)                                                 ;
        Screen('Flip', w)                                                ;
        WaitSecs(1)
    end
end

% question 5 - favorite color (click on circle)

% define objects for circle settings
diameter      = round(wWidth/8)                                          ; % define diameter of circles
xcoords       = linspace(0, wWidth-diameter, 5)                          ; % left x-coordinates for oval rects
ymidDistance  = round(diameter/2)                                        ; % define distance from ymid to top/bottom of ovals
circleTop     = round(ymid-ymidDistance)                                 ; % define y-coordinate for top of circle
circleBottom  = round(ymid+ymidDistance)                                 ; % define y-coordinate for bottom of circle

ovalPenWidth  = 5                                                        ; % pen width for drawing frame ovals in pixels

% oval colors
ovalColor1    = [100 149 237]                                            ; % (cornflower blue)
ovalColor2    = [123 63  0]                                              ; % (chocolate brown)
ovalColor3    = [29  155 56]                                             ; % (forest green)
ovalColor4    = [255 105 180]                                            ; % (hot pink)
ovalColor5    = [128 0   128]                                            ; % (purple)

% oval rects
ovalRect1     = [xcoords(1) circleTop (xcoords(1)+diameter) circleBottom]                                                         ; 
ovalRect2     = [xcoords(2) circleTop (xcoords(2)+diameter) circleBottom]                                                         ;
ovalRect3     = [xcoords(3) circleTop (xcoords(3)+diameter) circleBottom]                                                         ;
ovalRect4     = [xcoords(4) circleTop (xcoords(4)+diameter) circleBottom]                                                         ;
ovalRect5     = [xcoords(5) circleTop (xcoords(5)+diameter) circleBottom]                                                         ;

% prompt text settings
textYPosition = round(circleTop/2)                                       ; % define text position for prompt (betweeen top of circles and top of screen)

% mouse settings
mouseYPosition = round((circleBottom+wHeight)/2)                         ; % define mouse position (between bottom of circles of bottom of screen)
SetMouse(xmid, mouseYPosition, w)                                        ; % set mouse position 
ShowCursor('Hand', w)                                                    ; % change mouse-cursor symbol to hand with pointing finger

mouseButtons = [0 0 0]                                                   ; % initialize mouse buttons statuses

while ~mouseButtons(1)                                                     % until mouse button 1 is pressed
    
    % draw ovals
    Screen('FillOval', w, ovalColor1, ovalRect1) ; 
    Screen('FillOval', w, ovalColor2, ovalRect2) ;
    Screen('FillOval', w, ovalColor3, ovalRect3) ;
    Screen('FillOval', w, ovalColor4, ovalRect4) ;
    Screen('FillOval', w, ovalColor5, ovalRect5) ; 
    
    % prompt user to choose they're favorite color
    DrawFormattedText(w, 'Click on the color you like best.', 'center', textYPosition, mainTextColor)                             ;
    
    [mouseX, mouseY, mouseButtons] = GetMouse(w)                         ; % get mouse position and button statuses
    
    % if mouse cursor is inside an oval, draw an oval frame around it
    if IsInRect(mouseX, mouseY, ovalRect1) 
        Screen('FrameOval', w, [255 255 255], ovalRect1, ovalPenWidth)
    elseif IsInRect(mouseX, mouseY, ovalRect2)
        Screen('FrameOval', w, [255 255 255], ovalRect2, ovalPenWidth)
    elseif IsInRect(mouseX, mouseY, ovalRect3)
        Screen('FrameOval', w, [255 255 255], ovalRect3, ovalPenWidth)
    elseif IsInRect(mouseX, mouseY, ovalRect4)
        Screen('FrameOval', w, [255 255 255], ovalRect4, ovalPenWidth)
    elseif IsInRect(mouseX, mouseY, ovalRect5)
         Screen('FrameOval', w, [255 255 255], ovalRect5, ovalPenWidth)
    end               

    Screen('Flip', w)                                                    ; % put ovals and text on screen
end

% if mouse cursor is inside an oval after mouse button 1 has been pressed,
% record the number of that oval as the user's response
if IsInRect(mouseX, mouseY, ovalRect1) 
    faveColor = 1                                ; 
elseif IsInRect(mouseX, mouseY, ovalRect2)
    faveColor = 2                                ;
elseif IsInRect(mouseX, mouseY, ovalRect3)
    faveColor = 3                                ;
elseif IsInRect(mouseX, mouseY, ovalRect4)
    faveColor = 4                                ;
elseif IsInRect(mouseX, mouseY, ovalRect5)
    faveColor = 5                                ;
end

HideCursor                                                                 % hide the mouse cursor

% give closing message & put text on the screen
DrawFormattedText(w, 'The survey is complete.\nThank you!', 'center', 'center', mainTextColor)                                    ;
Screen('Flip', w)                                ;

%% SAVE & EXIT

% save a .mat datafile that contains all the variables in the workspace
save('BrandonAchugbue_20B_HW2')                                          ;

keyCode = zeros(1, 256)                                                  ; % initialize keyCode vector

while ~(sum( keyCode([keyNumE keyNumX keyNumI keyNumT]) ) == 4)...         % if e, x, i, and t aren't all pressed
        && ~(sum(keyCode) == 4)                                            % or if there aren't 4 keys being pressed
    [~, keyCode] = KbWait(-1)                                            ; % wait for fresh key-press 
                                                                           % get vector of key-statuses
end

ListenChar(1)                                                              % restore keyboard input
sca                                                                        % close PsychToolbox windows and restore mouse cursor