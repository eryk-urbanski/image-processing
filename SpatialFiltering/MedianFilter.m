im = im2gray(imread('perro.jpg'));
im = imnoise(im, 'salt & pepper');
figure
subplot(1,2,1)
imshow(im)
title('original noisy image')

imf = medianFilter(im);
subplot(1,2,2)
imshow(imf)
title('filtered image')

function output = medianFilter(im)
    [m, n] = size(im);
    output = zeros(m,n);

    % manual implementation of the  'replicate' option
    imb = zeros(m+2, n+2);
    imb(2:m+1,2:n+1) = im;
    imb(1,1) = im(1,1);
    imb(1,2:n+1) = im(1,:);
    imb(1,n+2) = im(1,n);
    imb(2:m+1,1) = im(:,1);
    imb(2:m+1,n+2) = im(:,n);
    imb(m+2,1) = im(m,1);
    imb(m+2,2:n+1) = im(m,:);
    imb(m+2,n+2) = im(m,n);

    for i = 1:m
        for j = 1:n
            subset = double(imb(i:i+2,j:j+2));
            subset = reshape(subset, 1, []);
            subset = sort(subset);
            output(i,j) = subset(1,floor(length(subset)/2)+1); % median
            % output(i,j) = subset(1,9); % max
            % output(i,j) = subset(1,1); % min
            output = uint8(output);
        end
    end
end