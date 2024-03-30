im = im2gray(imread('cameraman.tif'));
figure
subplot(1,2,1)
imshow(im)
title('original image')

imf = filterImage(im, 'Laplacian');
subplot(1,2,2)
imshow(imbinarize(imf))
title('filtered image')

function output = filterImage(im, maskName)
    [m, n] = size(im);
    output = zeros(m,n);
    
    switch maskName
        case 'Laplacian'
            mask = [-1 -1 -1; -1 8 -1; -1 -1 -1]
        case 'PrewittHorizontal'
            mask = [-1 -1 -1; 0 0 0; 1 1 1]
        case 'SobelVertical'
            mask = [1 0 -1; 2 0 -2; 1 0 -1]
        otherwise
            mask = [1 1 1; 1 1 1; 1 1 1];
            mask = mask/9
    end

    % maskSize = size(mask, 1);
    % then in for loops it would be subset =
    % imb(i-int32(maskSize/2):i+int32(maskSize/2)),
    % at least for masks with odd dimensions

    % manual implementation of the  'replicate' option
    imb = zeros(m+2, n+2);
    imb(2:m+1, 2:n+1) = im;
    imb(1, 1) = im(1,1);
    imb(end, 1) = im(end, 1);
    imb(1, end) = im(1, end);
    imb(end, end) = im(end, end);
    imb(2:end-1, 1) = im(1:end, 1);
    imb(2:end-1, end) = im(1:end, end);
    imb(1, 2:end-1) = im(1, 1:end);
    imb(end, 2:end-1) = im(end, 1:end);

    for i = 2:m-1
        for j = 2:n-1
            subset = double(imb(i-1:i+1, j-1:j+1));
            calc = subset.*mask;
            output(i,j) = sum(sum(calc));
            output = uint8(output);
        end
    end
end