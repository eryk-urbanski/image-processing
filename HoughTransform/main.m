threshold = 170;
Nm = 100;
Nb = 300;
path = 'Carretera1.png';
test(path, Nm, Nb, threshold)

function test(path, Nm, Nb, threshold)
    im = imread(path);
    im_b = binarizeEdge(imageToGrayscaleSquare(im), threshold);
    im_h = houghTransform(im_b, Nm, Nb);
    showResult(im, im_b, im_h, Nm, Nb);
end

function y = imageToGrayscaleSquare(im)
    y = im;
    if size(y, 3) == 3
        y = rgb2gray(y);
    end
    y = imageToSquare(y);
end

function y = binarizeEdge(im, threshold)
    h = [-1 -1 -1; -1 8 -1; -1 -1 -1];
    y = imfilter(im, h, 'circular');
    y = y > threshold;
end

function showResult(original, binary, hough, Nm, Nb)
    figure
    subplot(1,3,1)
    imshow(original)
    title('Original image')
    subplot(1,3,2)
    imshow(binary)
    title('Binarized image')
    subplot(1,3,3)
    imshow(hough)
    subtitle_text = strcat('Nm=', num2str(Nm), ' Nb=', num2str(Nb));
    title({'Main line detected with Hough Transform', subtitle_text});
end