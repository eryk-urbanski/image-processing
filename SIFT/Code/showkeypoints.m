function showkeypoints(im, keypointArray, radiusProportionalCoefficient)

    figure
    imshow(im)
    hold on

    for i = 1:length(keypointArray)
        centerX = keypointArray(i, 1);
        centerY = keypointArray(i, 2);
        sigma = keypointArray(i, 3);

        radius = sigma * radiusProportionalCoefficient;

        viscircles([centerY centerX], radius, 'EdgeColor', 'r', 'LineWidth', 1);
    end

    hold off
    title(['Number of keypoints: ' int2str(length(keypointArray))])

end