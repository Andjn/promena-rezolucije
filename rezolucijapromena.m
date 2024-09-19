clear all;
close all;

videoPath = 'C:\Program Files\MATLAB\R2017a\test.mp4';
video = VideoReader(videoPath);

numFrames = video.NumberOfFrames;
w = video.Width;
h = video.Height;

originalAspectRatio = w / h;
targetAspectRatio16_9 = 16 / 9;
targetAspectRatio4_3 = 4 / 3;

if originalAspectRatio < targetAspectRatio16_9
    % 4:3 u 16:9
    outWidth = round(h * targetAspectRatio16_9);
    outHeight = h;
    targetAspectRatio = targetAspectRatio16_9;
else
    % 16:9 u 4:3
    outWidth = w;
    outHeight = round(w / targetAspectRatio4_3);
    targetAspectRatio = targetAspectRatio4_3;
end

outputVideo = uint8(zeros(outHeight, outWidth, 3, numFrames));

for i = 1:numFrames
    frame = read(video, i);
    
    if originalAspectRatio < targetAspectRatio16_9
        % 4:3 u 16:9
        newWidth = round(h * targetAspectRatio16_9);
        scaledFrame = imresize(frame, [h, newWidth]);
        leftPadding = floor((newWidth - w) / 2);
        rightPadding = ceil((newWidth - w) / 2);
        
        finalFrame = padarray(scaledFrame, [0, leftPadding], 0, 'pre');
        finalFrame = padarray(finalFrame, [0, rightPadding], 0, 'post');
    else
        % 16:9 u 4:3
        newHeight = round(w / targetAspectRatio4_3);
        scaledFrame = imresize(frame, [newHeight, w]);
        topPadding = floor((newHeight - h) / 2);
        bottomPadding = ceil((newHeight - h) / 2);
        
        finalFrame = padarray(scaledFrame, [topPadding, 0], 0, 'pre');
        finalFrame = padarray(finalFrame, [bottomPadding, 0], 0, 'post');
    end
    finalFrame = imresize(finalFrame, [outHeight, outWidth]);
    outputVideo(:, :, :, i) = finalFrame;
end

implay(outputVideo);



