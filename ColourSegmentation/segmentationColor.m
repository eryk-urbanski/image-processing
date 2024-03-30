function y = segmentationColor(im, x1, y1, x2, y2, K)
    subRGB = im(y1:y2, x1:x2, :);
    avgRGB = mean(double(subRGB), [1,2]);
    stdRGB = std(double(subRGB), 0, [1,2]);

    min = avgRGB - K.*stdRGB;
    max = avgRGB + K.*stdRGB;

    out_of_range = any(im < min | im > max, 3);
    y = uint8(255 * (~out_of_range));
end