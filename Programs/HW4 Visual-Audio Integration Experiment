% PSYCH 20B - Summer 2022 - Homework 4
% Simple experiment examining how sound effects can affect perception of an
% ambiguous animation.

% Author: Brandon Achugbue (08/28/22)

% In each of 20 trials, two basketballs approach each other from opposite corners of the screen.
% Where the balls "meet" in the center of the screen, they are hidden by a grey square. When the
% balls meet behind the square, there is a sound effect (either a "bonk" or a "whoosh"), and
% the balls continue until they reach the corners of the screen. The subject presses 'LeftShift'
% if the balls appeared to bounce off each other, or 'RightShift' if the balls appeared to pass
% through or by each other. After the experiment, the experimenter holds down the 'q' key
% (and no other keys) to exit.

% Requires image file: basketball.png
% Outputs datafile: ['psych20bhw4_subj' subjIDChar '.mat']

%% GENERAL SETUP

clear all    % clear variables, settings
clc          % clear command window
close all    % close figure windows
sca          % close PsychToolbox windows
rng shuffle  % seed the random number generator based on the current time

ListenChar(2)     % suppress keyboard input
HideCursor        % hide mouse cursor

% define key-numbers
KbName('UnifyKeyNames')                                 % use Mac OS key-names
keyNumLeftShift     = min( KbName('LeftShift') )      ; % key-number for left shift
keyNumRightShift    = min( KbName('RightShift') )     ; % key-number for right shift
keyNumSpace         = min( KbName('space') )          ; % key-number for spacebar
keyNumR             = min( KbName('r'    ) )          ; % key-number for the r key
keyNumQ             = min( KbName('q'    ) )          ; % key-number for the q key

% initialize audio driver
numAudioChannels = 2                ; % number of audio channels
InitializePsychSound(1)             ; % load audio driver (1 means low-latency)

% open 2 stereophonic audio ports
try
    audioSampleRate = 44100 ;          % try to open audio ports with sample rate of 44100
    audioPortBonk   = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels) ;
    audioPortWhoosh = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels) ;
    
catch            % if it doesn't work, give exception message and use sample rate of 48000
    fprintf('\nAttempt to use 44100 sample rate didn''t work. Using 48000 instead.\n\n') 
    audioSampleRate = 48000 ;                               
    audioPortBonk   = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels) ;
    audioPortWhoosh = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels) ;
end
% failing to open an audioport can undefine the window you've already opened - do it first

% open a window
Screen('Preference', 'VisualDebugLevel', 1)       ; % suppress Psychtoolbox welcome screen
Screen('Preference', 'SkipSyncTests'   , 1)       ; % skip synchronization tests that can cause errors

allScreenNums       = Screen('Screens')           ; % vector of screen numbers for the available monitors
mainScreenNum       = max(allScreenNums)          ; % main screen number
backgroundColor     = [0 0 0]                     ; % definebackground color (black)

w = PsychImaging('OpenWindow', mainScreenNum, backgroundColor)      ; % open a full screen window

% define reference points
[wWidth, wHeight]   = Screen('WindowSize', w)     ; % width and height of window 'w' in pixels
xmid                = round(wWidth  / 2)          ; % horizontal midpoint of 'w' in pixels
ymid                = round(wHeight / 2)          ; % vertical   midpoint of 'w' in pixels

% define rects for each quadrant of the screen
quadRectTopLeft     = [ 0    , 0    , xmid   , ymid    ] ;
quadRectTopRight    = [ xmid , 0    , wWidth , ymid    ] ;
quadRectBottomLeft  = [ 0    , ymid , xmid   , wHeight ] ;
quadRectBottomRight = [ xmid , ymid , wWidth , wHeight ] ;

% set blend function for anti-aliasing (makes certain drawing smoother)
Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA') ;

% text settings
Screen('TextSize' , w, round(wHeight/30))         ; % set text size
Screen('TextFont' , w, 'Arial')                   ; % set font to Arial
Screen('TextStyle', w, 0)                         ; % use normal text
mainTextColor       = 255                         ; % define main text color (white)
warningTextColor    = [255 128 0]                 ; % define warning text color (orange)

% Priority( MaxPriority(w) )  ; % prioritize Psychtoolbox display performance

%% ANIMATION SETUP

% import basketball.png image file
basketballRGB      = imread('basketball.png')                   ; % import basketball image into RGB array 
basketballTexture  = Screen('MakeTexture', w, basketballRGB)    ; % texture pointer for basketball image (single number)

% obtain refresh rate of the monitor
flipInterval     = Screen('GetFlipInterval', w)     ; % get average flip interval for window w

% basketball image settings
basketballHeight = round(wHeight/10)                ; % height of basketball (set to 1/10 height of screen)
basketballWidth  = basketballHeight                 ; % width of basketball (same as height)

basketballRect1  = [0 0 basketballWidth basketballHeight]                            ; % initialize top-left basketball rect
basketballRect2  = [wWidth-basketballWidth wHeight-basketballHeight wWidth wHeight]  ; % initialize bottom-right basketball rect

% grey square settings
squareColor      = 50                               ; % color of square (grey)
squareWidth      = basketballWidth*2                ; % width of square (twice width of basketball)
squareHeight     = squareWidth                      ; % height of square (same as width)

squareBaseRect   = [0 0 squareWidth squareHeight]   ; % define base rect for square
startXCoord      = xmid - squareWidth/2             ; % x coordinate of square rect centered on screen
startYCoord      = ymid - squareHeight/2            ; % y coordinate of square rect centered on screen

squareRect = squareBaseRect + [startXCoord startYCoord startXCoord startYCoord] ; % initialize rect for square's position on screen

% miscellaneous settings
totalAniSecs     = 4                                ; % number of seconds for the animation to take (accuracy will depend on system)
totalAniFrames   = totalAniSecs / flipInterval      ; % convert above to the number of frames the complete animation will take

% compute number of pixels to move the circle diagonally each frame
% (this is the total number of pixels the circle has to travel divided by the total number of frames it takes)

totalTravelPixelsX = wWidth - basketballWidth             ; % total number of pixels the basketball will travel horizonally
totalTravelPixelsY = wHeight - basketballHeight           ; % total number of pixels the basketball will travel vertically

pixelsPerFrameX    = totalTravelPixelsX / totalAniFrames  ; % pixels to move the circle horizontally each frame
pixelsPerFrameY    = totalTravelPixelsY / totalAniFrames  ; % pixels to move the circle horizontally each frame

%% GENERATE AUDIO

% BONK SOUND
% made by oversaturating a sine-wave burst, then applying a linear fade-out across it

sineFreq       = 50 ; % frequency of sine-wave tone in Hz
sineLengthSecs = .2 ; % duration  of sine-wave tone in seconds
oversaturation = 5  ; % level of oversaturation (will be multiplied by the sine wave to create distortion)

sineTone        = MakeBeep(sineFreq, sineLengthSecs, audioSampleRate) ; % audio vector for sine-wave tone
sineToneOversat = sineTone * oversaturation                           ; % distorted (i.e., oversaturated) sine-wave tone
fadeOut4Bonk    = linspace(1, 0, numel(sineToneOversat))              ; % fade-out vector for bonk: linearly decreasing values from 1 to 0
bonk            = sineToneOversat .* fadeOut4Bonk                     ; % make bonk sound by applying fade-out to oversaturated sine-wave tone
bonk(bonk >  1) =  1                                                  ; % clip (flatten) the peaks in bonk wherever they exceed 1
bonk(bonk < -1) = -1                                                  ; % clip (flatten) the troughs in bonk wherever they go lower than -1
bonk            = repmat(bonk, numAudioChannels, 1)                   ; % replicate bonk into designated number of channels

PsychPortAudio('FillBuffer', audioPortBonk, bonk)     ; % fill audio buffer with bonk sound

% WHOOSH SOUND
% made by applying an exponential fade-in across a Gaussian white-noise burst

noiseLengthSecs             = .2                                           ; % duration of noise in seconds
fadeExp                     = 6                                            ; % exponent that will determine the steepness of the fade-in
noiseLengthSamples          = noiseLengthSecs * audioSampleRate            ; % duration of noise in samples
whiteNoise                  = randn(1, noiseLengthSamples)                 ; % Gaussian white noise (random numbers from standard normal distribution)
whiteNoise(whiteNoise >  1) =  1                                           ; % clip (flatten) the peaks in white noise wherever they exceed 1
whiteNoise(whiteNoise < -1) = -1                                           ; % clip (flatten) the troughs in white noise wherever they go lower than -1
fadeIn4WhiteNoise           = linspace(0, 1, numel(whiteNoise)) .^ fadeExp ; % fade-in vector for white noise: exponentially increasing values from 0 to 1
whoosh                      = whiteNoise .* fadeIn4WhiteNoise              ; % make whoosh sound by applying fade-in to the white noise
whoosh                      = repmat(whoosh, numAudioChannels, 1)          ; % replicate whoosh into designated number of channels

PsychPortAudio('FillBuffer', audioPortWhoosh, whoosh) ; % fill audio buffer with whoosh sound

%% PREPARE VECTORS

numTrials     = 20 ; % number of trials
numTrialTypes = 2  ; % number of conditions

% define vector of trial types containing an equal number of 1s and 2s in random order
trialTypeTemp = repmat(1:numTrialTypes, 1, numTrials/numTrialTypes) ; % unshuffled trial-type vector
trialType     = Shuffle(trialTypeTemp)                              ; %   shuffled trial-type vector

% ensure that there are never more than 2 trials of the same type in a row
while ~isempty( strfind(trialType, [1 1 1]) ) || ~isempty( strfind(trialType, [2 2 2]) )  % while there are double repeats of 1 or 2 in trialType
    trialType = Shuffle(trialTypeTemp) ;                                                  % shuffle trialType
end

% initialize vector to be filled with subject's responses
bounceOrPass = zeros(1, numTrials) ;

% initialize vector to be filled with subject's response times
responseTime = NaN(1, numTrials)   ;

%% PRIME FUNCTIONS

% prime Psychtoolbox functions that will be used
KbCheck                                     ;
GetMouse                                    ;
RestrictKeysForKbCheck([])                  ;
GetSecs                                     ;
DrawFormattedText(w, '')                    ;
Screen('DrawTexture', w, basketballTexture) ; 
Screen('FillRect', w, backgroundColor)      ;
Screen('Flip', w)                           ;

KbWait(-1, 1) ;
PsychPortAudio('Start', audioPortBonk)      ;
PsychPortAudio('Stop' , audioPortBonk)      ;

%% ENTER SUBJECT NUMBER

% get coordinates to center the subject-number prompt text
subjIDPromptDimRect = Screen('TextBounds', w, 'Enter subject number:') ; % rect giving dimensions of subject-number prompt text
subjIDPromptWidth   = subjIDPromptDimRect(3)                           ; % width  of subject-number prompt text
subjIDPromptHeight  = subjIDPromptDimRect(4)                           ; % height of subject-number prompt text
xSubjIDPrompt       = xmid - subjIDPromptWidth /2                      ; % x-coordinate for subject-number prompt text
ySubjIDPrompt       = ymid - subjIDPromptHeight/2                      ; % y-coordinate for subject-number prompt text

% input subject ID number
RestrictKeysForKbCheck([keyNumR keyNumSpace]) ; % ignore all keys except 'r' and spacebar (won't affect GetEchoString input)
isSubjIDValid = 0                             ;  % initialize logical flag indicating whether a valid subject ID number has been entered

while ~isSubjIDValid % stay in while-loop until valid subject ID number is entered
    
    subjIDChar = GetEchoString(w, 'Enter subject number: ', xSubjIDPrompt, ySubjIDPrompt, mainTextColor, backgroundColor) ; % get subject ID as character array
    Screen('Flip', w) ; % this flip keeps the above GetEchoString text from staying on the screen after the next flip
    
    subjID = str2double(subjIDChar) ; % convert the entered subject ID from character array to numeric value
    if ismember(subjID, 1:1000)       % if entered subject ID is a whole number between 1 and 1000 inclusive
        
        outputFileName = ['entersubjiddemoData_subj' num2str(subjID) '.mat'] ; % filename for this subject's data
        
        if ~exist(outputFileName, 'file') % if filename for this subject doesn't already exist in the directory; could also say: if isempty(dir(outputFileName))
            isSubjIDValid = 1 ;           % then subject ID is valid; update logical flag to break while-loop
        else                              % otherwise, display warning below
            
            DrawFormattedText(w, ['WARNING: Data already exist for subject number ' num2str(subjID) ' and will be overwritten.\n\n' ...
                                  'Filename: ' outputFileName '\n\n' ...
                                  'Press spacebar to continue anyway, or press ''r'' to re-enter subject number.'], 'center', 'center', warningTextColor) ;
            Screen('Flip', w) ; % put warning on screen

            [~, keyCode]  = KbWait(-1)           ; % wait for key-press
            isSubjIDValid = keyCode(keyNumSpace) ; % if overwriting of datafile okayed, update logical flag to break while-loop
        end

    else % if entered subject ID is not a whole number between 1 and 1000 inclusive, display error message below
        
        DrawFormattedText(w, 'SUBJECT ID MUST BE WHOLE NUMBER\nBETWEEN 1 AND 1000 INCLUSIVE', 'center', 'center', warningTextColor) ; % error message
        Screen('Flip', w)  ; % put error message on screen
        WaitSecs(2)        ; % hold error message on screen for 2 seconds
    end
end

RestrictKeysForKbCheck([]) ; % stop ignoring keys

%% EXPERIMENT

% define text prompts
instructionsText = 'In each round of this experiment, you will see two moving basketballs.\n\nThen you will press Left-Shift if they seemed to bounce off each other,\nor press Right-Shift if they seemed to pass through or by each other.\n\nPress the spacebar to begin' ;

trialPromptText = 'Press Left-Shift if the balls bounced off each other.\n\nPress Right-Shift if the balls passed through or by each other.' ;                
          
closingText     = 'That''s the end of the experiment.\nThank you for participating!' ;
               
% give instructions
DrawFormattedText(w, instructionsText, 'center', 'center', mainTextColor) ; % draw instructions text
Screen('Flip', w)                                                         ; % put instructions text on screen

% wait for spacebar press
while KbCheck(-1)                      % wait for all keys to be up
end
RestrictKeysForKbCheck(keyNumSpace) ;  % restrict keyboard input to space key
while ~KbCheck(-1)                     % and wait for any key to be down
end
while KbCheck(-1)                      % wait for all keys to be up again
end
RestrictKeysForKbCheck([])          ;  % stop disregarding keys

% begin experiment
for iTrial = 1:numTrials
    
    frameCounter   = 1       ; % initialize frame counter
    animationEnded = 0       ; % initialize flag signifying the animation has ended
    aniStartSecs   = GetSecs ; % start timing the animation

    currentBallRect1 = basketballRect1 ; % initialize rect for basketball 1 current position (starting at top-left)
    currentBallRect2 = basketballRect2 ; % initialize rect for basketball 2 current position (starting at bottom-right)
    
    % show animation
    while currentBallRect1 <= wWidth                                        % draw frames one at a time until right edge of basketball 1 has reached right edge of screen
        Screen('DrawTexture', w, basketballTexture, [], currentBallRect1) ; % draw basketball texture in basketball 1's current position
        Screen('DrawTexture', w, basketballTexture, [], currentBallRect2) ; % draw basketball texture in basketball 2's current position
        Screen('FillRect'   , w, squareColor      ,     squareRect     )  ; % draw grey square in the center of the screen (after basketballs so they're covered)
        Screen('Flip', w)                                                 ; % put the grey square and basketballs on the screen
        
        if frameCounter == round(totalAniFrames/2)                   % if we're halfway through the total frames of animation
            if trialType(iTrial) == 1                                % if the current trial is type 1
                PsychPortAudio('Start'     , audioPortBonk       ) ; % play bonk sound
                %PsychPortAudio('Stop'      , audioPortBonk  , 1  ) ; % wait for audio to finish playing
            elseif trialType(iTrial) == 2                            % if the current trial is type 2
                PsychPortAudio('Start'     , audioPortWhoosh     ) ; % play whoosh sound
                %PsychPortAudio('Stop'      , audioPortWhoosh, 1  ) ; % wait for audio to finish playing
            end
        end
        
        currentBallRect1 = currentBallRect1 + [pixelsPerFrameX pixelsPerFrameY pixelsPerFrameX pixelsPerFrameY] ; % move basketball 1's current position right and down by the designated number of pixels
        currentBallRect2 = currentBallRect2 - [pixelsPerFrameX pixelsPerFrameY pixelsPerFrameX pixelsPerFrameY] ; % move basketball 2's current position left and up by the designated number of pixels
    
        frameCounter = frameCounter + 1         ; % update frame counter     
    end
    
    aniActualDuration = GetSecs - aniStartSecs  ; % actual duration of animation  
    
    % after the animation in each trial, display prompt text
    DrawFormattedText(w, trialPromptText, 'center', 'center', mainTextColor) ; % draw trial prompt text
    shiftPromptSecs = Screen('Flip', w)                                      ; % put text on screen and get timestamp of flip
        
    % wait for left- or right-shift press & record response
    while KbCheck(-1)                                            % wait for all keys to be up
    end
    
    RestrictKeysForKbCheck([keyNumLeftShift keyNumRightShift]) ; % restrict keyboard input to left shift and right shift      
    keyCode = zeros(1, 256)                                    ; % initialize keyCode vector
 
    while ~bounceOrPass(iTrial)                        % while participant response vector indexed at the current trial is unanswered (0)
        [~, shiftPressSecs, keyCode] = KbCheck(-1) ;   % get vector of key statuses
            
        if keyCode(keyNumLeftShift)                                    % if left shift has been pressed
            responseTime(iTrial) = shiftPressSecs - shiftPromptSecs  ; % update response time vector
            bounceOrPass(iTrial) = 1                                 ; % update response vector and break while loop
        elseif keyCode(keyNumRightShift)                               % or if right shift has been pressed
            responseTime(iTrial) = shiftPressSecs - shiftPromptSecs  ; % update response time vector
            bounceOrPass(iTrial) = 2                                 ; % update response vector and break while loop
        end 
    end
        
    % after each trial, save a .mat file containing important variables
    save(outputFileName, 'wWidth', 'wHeight', 'flipInterval', 'subjID', 'trialType', 'bounceOrPass', 'responseTime')
    
    % after the last trial, display the closing message
    if iTrial == numTrials                                                     % if it's the end of the 20th trial
        DrawFormattedText(w, closingText, 'center', 'center', mainTextColor) ; % write closing message
        Screen('Flip', w)                                                    ; % put text on screen
    end
        
end

%% EXIT

RestrictKeysForKbCheck([])  ; % stop disregarding keys      

% exit code
keyCode         = zeros(1, 256)                                          ; % initialize keyCode vector
mouseButtons    = [0 0 0]                                                ; % initialize mouse buttons statuses
exitCodeEntered = 0                                                      ; % initialize invalid flag for exit code entered

while ~exitCodeEntered                                                     % while the exit code hasn't been entered
    
    [~, ~, keyCode]                = KbCheck(-1)                         ; % get vector of key statuses
    [mouseX, mouseY, mouseButtons] = GetMouse(w)                         ; % get mouse position and button statuses

    if keyCode(keyNumQ) ...                                                % if the Q key is being pressed
            && sum( keyCode ) == 1 ...                                     % and no other keys are being pressed
            && any(mouseButtons)                                           % and any mouse button is being pressed
        exitCodeEntered = 1                                              ; % update exit code entered flag and break while loop
    end
    
end

% get out
ListenChar(1)        % restore keyboard input
sca                  % close PsychToolbox windows and restore mouse cursor

PsychPortAudio('Close') ; % closer audio ports
% Priority(0) ;        % reset Psychtoolbox display priority to normal
