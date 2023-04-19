% PSYCH 20B Homework 1
% Display text of various colors at various screen-positions.
% Author: Brandon Achugbue (08/08/22)

%% SETUP

clear all   % clear variables & settings from memory
clc         % clear command window
rng shuffle % seed the random number generator using current time
close all   % close figure windows
sca         % close Psychtoolbox windows

Screen('Preference', 'VisualDebugLevel', 1)          ; % suppress Psychtoolbox welcome screen
Screen('Preference', 'SkipSyncTests'   , 1)          ; % skip synchronization tests
mainScreenNum       = max(Screen('Screens'))         ; % get main screen number 

backgroundColor     = [100, 149, 237]                ; % define vector for background color
w                   = PsychImaging...                  % open a full-screen window w/ cornflower blue bkgd
    ('OpenWindow', mainScreenNum, backgroundColor)   ;

ListenChar(2)                                          % suppress keyboard input to command window
HideCursor                                             % hide mouse cursor
Screen('BlendFunction', w, 'GL_SRC_ALPHA',...          % set blend function
    'GL_ONE_MINUS_SRC_ALPHA')                        ; 
[wWidth, wHeight]   = Screen('WindowSize', w)        ; % get width and height of window 'w' in pixels
xmid                = round(wWidth / 2)              ; % horizontal midpoint of 'w' in pixels
ymid                = round(wHeight / 2)             ; % vertical midpoint of 'w' in pixels

% define rects for each quadrant of the screen
quadRectTopLeft     = [0, 0, xmid, ymid]             ;
quadRectTopRight    = [xmid, 0, wWidth, ymid]        ;
quadRectBottomLeft  = [0, ymid, xmid, wHeight]       ;
quadRectBottomRight = [xmid, ymid, wWidth, wHeight]  ;

%% DISPLAY TEXT

PsychDefaultSetup(1)                                 ; % use the 0-255 scale for RGB color values

Screen('TextSize', w, round(wHeight/20))             ; % set text size
Screen('TextFont', w, 'Courier')                     ; % set font
Screen('TextStyle', w, 1)                            ; % use bold text

DrawFormattedText(w, 'TOP LEFT\nQUADRANT',...          % draw text (centered within rect)
    'center', 'center', [255 165 2],...
    [], [], [], [], [], quadRectTopLeft)             ; 

DrawFormattedText(w, 'TOP RIGHT\nQUADRANT',...         % draw text (centered within rect)
    'center', 'center', [255 0 0],...
    [], [], [], [], [], quadRectTopRight)            ; 

DrawFormattedText(w, 'BOTTOM LEFT\nQUADRANT',...       % draw text (centered within rect)
    'center', 'center', [0 255 0],...
    [], [], [], [], [], quadRectBottomLeft)          ; 

DrawFormattedText(w, 'BOTTOM RIGHT\nQUADRANT',...      % draw text (centered within rect)
    'center', 'center', [255 0 255],...
    [], [], [], [], [], quadRectBottomRight)         ; 

Screen('Flip', w)                                    ; % put text on screen
WaitSecs(7)                                          ; % wait 7 secs

% reset font, size, and text style
Screen('TextSize', w, round(wHeight/50))             ; % set text size
Screen('TextFont', w, 'Arial')                       ; % set font
Screen('TextStyle', w, 0)                            ; % use bold text

% get dimensions of random text
textDimRect = Screen('TextBounds', w, 'random')      ; % get rect vector of text box dimensions (relative to the text) (0, 0, width, height) 
textWidth = textDimRect(3)                           ; % width of text box
textHeight = textDimRect(4)                          ; % height of text box

xTextBound = round(wWidth - textWidth)               ; % x boundary to place text on screen
yTextBound = round(textHeight)                       ; % y boundary to place text on screen

randomXs = randi([0 xTextBound], [1 300])            ; % vector of 300 random integers in the range of screen width (accomodating for text width)
randomYs = randi([yTextBound wHeight], [300 1])      ; % vector of 300 random integers in the range of screen height (accomodating for text height)

for index = 1:300                                      % for each index
    color = randi([0 255])                           ; % get a random color / amount of light
    DrawFormattedText(w, 'random',...                  % draw the word 'random' on our open window
        randomXs(index), randomYs(index),...           % in a random x and random y position each time
        [color color color])                         ; % in the random tone of light we got earlier             
end

Screen('Flip', w)                                    ; % put text on screen

%% EXIT

WaitSecs(7)                                          ; % wait 7 secs
sca                                                    % close PsychToolbox windows and restore mouse cursor
ListenChar(1)                                          % restore keyboard input