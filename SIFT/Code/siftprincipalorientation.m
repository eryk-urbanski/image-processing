%% Computing the principal orientation
% in: image, keypoint
% processing: define mask using radius value, apply gradient function
% and save values to a histogram, choose the biggest value
% output: principal orientation value

function result = siftprincipalorientation(im, x, y, sigma)
    k = 3.3;
    half = floor(k*sigma);
    xLow = max(1, x-half+1);
    xHigh = min(size(im,1), x+half-1);
    yLow = max(1, y-half+1);
    yHigh = min(size(im,2), y+half-1);
    slice = im(xLow:xHigh, yLow:yHigh);
    [~, Gdir] = imgradient(slice);
    Gdir = round(Gdir);

    % TODO: better histogram (only unique values)
    % values = unique(Gdir);
    % dir_histogram = zeros(length(values));

    dirHistogram = zeros(361, 1);
    for i = 1:size(Gdir, 1)
        for j = 1:size(Gdir, 2)
            index = Gdir(i,j) + 181;
            dirHistogram(index) = dirHistogram(index) + 1;
        end
    end
    [~, dirMax] = max(dirHistogram);
    result = dirMax - 181;
end