% PSYCH 20B - Summer 2022 - Homework 5
% Author: Brandon Achugbue (9/3/22)

% This program imports, analyzes, and visualizes data from an experiment
% measuring response times to changes of a face's position (Homework 3). 
% In each trial, participants were presented with a face image in the 
% center of the screen, and after some amount of time, shown the same face 
% again in a location shifted in some direction as specified by the 
% trialType vector (up = 1, down = 2, left = 3, right = 4).

% Imports datafiles: ['psych20bhw3_subj' subjIDChar '.mat']

%% IMPORT DATA

clear     % clear variables from workspace
close all % close any open figure windows

dataFiles = dir('psych20bhw3_subj*.mat') ; % structure listing the .mat files in current directory that start with 'psych20bhw3subj'
n         = numel(dataFiles)             ; % total number of subjects (number of files listed in the above structure)
numTrials = 20                           ; % number of trials for each subject

% for variables that have 1 value per subject, initialize "all-subjects" data vectors (in which each value is for a given subject)
% we won't actually be using these variables in our analysis; they're just for confirmation purposes
wWidthAll          = NaN(n, 1) ; % screen width
wHeightAll         = NaN(n, 1) ; % screen height
subjIDAll          = NaN(n, 1) ; % subject ID number
avgRefreshRateAll  = NaN(n, 1) ; % average refresh rate of monitor

% for variables that have 1 value per trial per subject, initialize "all-subjects" data matrices (each row is for a subject and each column is for a trial)
trialTypeAll    = NaN(n, numTrials) ; % trial types (1 = upward, 2 = down, 3 = left, 4 = right)
rtAll           = NaN(n, numTrials) ; % response time in seconds for every trial
delayActualAll  = NaN(n, numTrials) ; % actual delay in seconds from face appearing in original position to face appearing in new position for every trial

% loop through subjects, importing data from each
for iSubj = 1:n
    fileName = dataFiles(iSubj).name ; % name of data file for current subject
    load(fileName)                   ; % load that data file (if file isn't in the current folder, you may need to concatenate the path onto the filename here)
    
    % insert current subject's single-value variables into all-subjects data vectors
    wWidthAll(        iSubj) = wWidth         ;
    wHeightAll(       iSubj) = wHeight        ;
    subjIDAll(        iSubj) = subjID         ;
    avgRefreshRateAll(iSubj) = avgRefreshRate ;

    
    % insert current subject's multiple-value variables into all-subjects data matrices
    trialTypeAll(   iSubj, :) = trialType    ;
    rtAll(          iSubj, :) = responseTime ;
    delayActualAll( iSubj, :) = delayActual  ;

    
    % clear the loaded variables for this subject from the workspace
    clear wWidth wHeight subjID avgRefreshRate trialType rt delayActual
end

%% COMPARE MEAN RESPONSE TIMES

% pairwise mean comparisons of response times

% up vs down, up vs right, down vs left, down vs right, & left vs rigth
% for each comparison, get the p-value, confidence interval for population
% mean difference, and the 'stats' struct 

% response-times only where trial type was 1 (up)
rtUpAll                  = rtAll                 ; % initialize rtUpAll as equal to the rtAll matrix
rtUpAll(trialTypeAll~=1) = NaN                   ; % set all response-times to NaN where trial-type isn't 1 (that is, on non-up trials)
rtUpAllAvg               = nanmean(rtUpAll, 2  ) ; % vector giving average up-trial response time for each subject (nanmean ignores NaN values)
                                         
% response-times only where trial type was 2 (down)
rtDownAll                  = rtAll                   ; % initialize rtDownAll as equal to the rtAll matrix
rtDownAll(trialTypeAll~=2) = NaN                     ; % set all response-times to NaN where trial-type isn't 2 (that is, on non-down trials)
rtDownAllAvg               = nanmean(rtDownAll, 2)   ; % vector giving average down-trial response time for each subject (nanmean ignores NaN values)

% response-times only where trial type was 3 (left)
rtLeftAll                  = rtAll                   ; % initialize rtLeftAll as equal to the rtAll matrix
rtLeftAll(trialTypeAll~=2) = NaN                     ; % set all response-times to NaN where trial-type isn't 3 (that is, on non-left trials)
rtLeftAllAvg               = nanmean(rtLeftAll, 2)   ; % vector giving average left-trial response time for each subject (nanmean ignores NaN values)

% response-times only where trial type was 4 (right)
rtRightAll                  = rtAll                   ; % initialize rtRightAll as equal to the rtAll matrix
rtRightAll(trialTypeAll~=2) = NaN                     ; % set all response-times to NaN where trial-type isn't 4 (that is, on non-right trials)
rtRightAllAvg               = nanmean(rtRightAll, 2)  ; % vector giving average right-trial response time for each subject (nanmean ignores NaN values)


% paired t-tests of whether mean response-time is statistically significantly different between trial types
% pT is the p-value; ciT is the 95% confidence interval, statsT is a structure containing other statistics

% up vs down
[~, pTResTimeUpVsDown   , ciTResTimeUpVsDown   , statsTResTimeUpVsDown   ] = ttest(rtUpAllAvg  , rtDownAllAvg)  ;
% up vs left
[~, pTResTimeUpVsLeft   , ciTResTimeUpVsLeft   , statsTResTimeUpVsLeft   ] = ttest(rtUpAllAvg  , rtLeftAllAvg)  ;
% up vs right
[~, pTResTimeUpVsRight  , ciTResTimeUpVsRight  , statsTResTimeUpVsRight  ] = ttest(rtUpAllAvg  , rtRightAllAvg) ;
% down vs left
[~, pTResTimeDownVsLeft , ciTResTimeDownVsLeft , statsTResTimeDownVsLeft ] = ttest(rtDownAllAvg, rtLeftAllAvg)  ;
% down vs right
[~, pTResTimeDownVsRight, ciTResTimeDownVsRight, statsTResTimeDownVsRight] = ttest(rtDownAllAvg, rtRightAllAvg) ;
% left vs right
[~, pTResTimeLeftVsRight, ciTResTimeLeftVsRight, statsTResTimeLeftVsRight] = ttest(rtLeftAllAvg, rtRightAllAvg) ;

%% DESCRIPTIVE STATISTICS

% compute the mean, std dev, and std error in each condition

% means of response-time measurements
meanRtUp    = mean(rtUpAllAvg  )  ; % mean of average response-times in up    condition
meanRtDown  = mean(rtDownAllAvg)  ; % mean of average response-times in down  condition
meanRtLeft  = mean(rtLeftAllAvg)  ; % mean of average response-times in left  condition
meanRtRight = mean(rtRightAllAvg) ; % mean of average response-times in right condition

% std. deviations of response-time measurements
sdRtUp    = std(rtUpAllAvg  )  ; % standard deviation of the mean for average response-times in up    condition
sdRtDown  = std(rtDownAllAvg)  ; % standard deviation of the mean for average response-times in down  condition
sdRtLeft  = std(rtLeftAllAvg)  ; % standard deviation of the mean for average response-times in left  condition
sdRtRight = std(rtRightAllAvg) ; % standard deviation of the mean for average response-times in right condition

% std. error of response-time measurements
semRtUp    = sdRtUp/sqrt(n)    ; % standard error of the mean for average response-times in up condition
semRtDown  = sdRtDown/sqrt(n)  ; % standard error of the mean for average response-times in down condition
semRtLeft  = sdRtLeft/sqrt(n)  ; % standard error of the mean for average response-times in left condition
semRtRight = sdRtRight/sqrt(n) ; % standard error of the mean for average response-times in right condition

%% BAR GRAPH SHOWING MEAN RESPONSE TIMES

figure(1) % open figure 1 window

% make bar graph w/ light blue bars of width .5
% we multiply the means by 1000 to convert from seconds to milliseconds, which is typically preferable when response times are short
bar(1:4, 1000*[meanRtUp meanRtDown meanRtLeft meanRtRight], 'FaceColor', [.5 .5 1], 'BarWidth', .5)  % use 0-1 scale with graphs

% label the graph (by using a cell array for the title, we can split it into two lines)
title ( {'Mean Responses Times', 'in Each Condition'}, 'FontSize', 16 ) % title
xlabel('Direction'                                   , 'FontSize', 14) % x-axis label
ylabel('Mean Response Time (ms)'                     , 'FontSize', 14) % y-axis label
set(gca, 'XTickLabel', {'Up' 'Down' 'Left' 'Right'}  , 'FontSize', 12) % x-axis tick labels

% add standard deviation error-bars (we do this by creating a line plot with error bars and setting the linestyle to 'none' so the line itself is invisible)
% again, we multiply values by 1000 to convert seconds to milliseconds
hold on % use the hold function to keep the error bars from overwriting the bars we just plotted
errorbar(1:4, 1000*[meanRtUp meanRtDown meanRtLeft meanRtRight], 1000*[semRtUp semRtDown semRtLeft semRtRight], 'LineStyle', 'none', 'Color', 'black', 'LineWidth', 2)
hold off

% add annotation explaining the error-bars
annotation('textbox', [.9 .7 .1 .2], 'String', ['Error bars indicate ' char(177) '1 SEM'], 'EdgeColor','none')

% Notes: In the annotation function above, the first 2 values in the vector indicate the textbox's x and y position, respectively,
%        as a proportion of the graph's dimensions. The 3rd and 4th values indicate the textbox's width and height, respectively,
%        as a proportion of the graph's dimensions. char(177) is the plus-or-minus symbol.

%% PLOT SHOWING EACH SUBJECT'S AVERAGE RESPONSE TIME

figure(2) % open figure 2 window

% make plot
% the first input to the scatter function gives the horizontal positions of the points (in this case, all 1s, 2s, 3s, and 4s because those are the conditions)
% we multiply response times by 1000 to convert seconds to milliseconds
scatter(repelem(1:4, 1, n), 1000*[rtUpAllAvg ; rtDownAllAvg ; rtLeftAllAvg ; rtRightAllAvg])

xlim([.5 4.5])  % x-axis limits (there are 4 condtions, but instead of just going from 1 to 4, give slight margin so points aren't on very edges of the graph)

% label the graph
title('Mean Response Time for Each Subject in Each Condition', 'FontSize', 16) % title
xlabel('Direction'                                           , 'FontSize', 14) % x-axis label
ylabel('Response Time (ms)'                                  , 'FontSize', 14) % y-axis label 
set(gca, 'XTickLabel', {'Up' 'Down' 'Left' 'Right'}          , 'FontSize', 12) % x-axis tick labels
xticks(1:4)                                                                    % only put x-axis tick marks at 1, 2, 3, and 4

% add standard error of the mean error-bars (we do this by creating a line plot with error bars and setting the linestyle to 'none' so the line itself is invisible)
% again, we multiply values by 1000 to convert seconds to milliseconds
hold on % use the hold function to keep the error bars from overwriting the bars we just plotted
errorbar(1:4, 1000*[meanRtUp meanRtDown meanRtLeft meanRtRight], 1000*[semRtUp semRtDown semRtLeft semRtRight], 'LineStyle', 'none', 'Color', 'black')
hold off

% add annotation explaining the error-bars
annotation('textbox', [.9 .7 .1 .2], 'String', ['Error bars indicate ' char(177) '1 SEM'], 'EdgeColor','none')

%% OPTIONAL SAVING

% saveas(figure(1), 'hw3analysisMeanResponseTimesByCondition.pdf'        )
% saveas(figure(2), 'hw3analysisMeanResponseTimeBySubjectByCondition.pdf')


