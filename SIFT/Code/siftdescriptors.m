function descriptorArray = siftdescriptors(im, keypointArray, sigmaInit)

    % Compute 4 histograms

    k = 3.3;
    nKeypoints = length(keypointArray);

    descriptorArray = zeros(4*361, nKeypoints);
    for i = 1:nKeypoints
        x = keypointArray(i, 1);
        y = keypointArray(i, 2);
        sigma = keypointArray(i, 3);
        angle = keypointArray(i, 4);
        half = floor(k*sigma);
        xLow = max(1, x-half+1);
        xHigh = min(size(im,1), x+half-1);
        yLow = max(1, y-half+1);
        yHigh = min(size(im,2), y+half-1);
        slice = im(xLow:xHigh, yLow:yHigh);
        
        % Scale invariance
        slice = imresize(slice, (sigmaInit*sqrt(2)^5)/max(size(slice)));
        
        % Rotation invariance
        slice = imrotate(slice, -angle);

        % Divide into quadrants
        [m, n] = size(slice);
        midpoint_row = floor(m / 2);
        midpoint_col = floor(n / 2);
        quadrant1 = slice(1:midpoint_row, 1:midpoint_col);
        quadrant2 = slice(1:midpoint_row, midpoint_col+1:end);
        quadrant3 = slice(midpoint_row+1:end, 1:midpoint_col);
        quadrant4 = slice(midpoint_row+1:end, midpoint_col+1:end);

        quadrants = {quadrant1, quadrant2, quadrant3, quadrant4};
        
        counter = 1;
        for j = 1:length(quadrants)
            dirHistogram = zeros(361, 1);
            [~, Gdir] = imgradient(quadrants{j});
            Gdir = round(Gdir);
            for k = 1:size(Gdir, 1)
                for l = 1:size(Gdir, 2)
                    index = Gdir(k,l) + 181;
                    dirHistogram(index) = dirHistogram(index) + 1;
                end
            end
            descriptorArray(counter:counter+360, k) = dirHistogram;
            counter = counter + 361;
        end
    end

end