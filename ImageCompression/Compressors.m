img = imread('cameraman.tif');
if size(img, 3) == 3
    img = rgb2gray(img);
end

K = 10;
Q = 32;
alpha = 0.8;

% img_compressed = losslessPredictor(img, alpha);
% img_compressed = lossyPredictor(img, K, alpha);

img_compressed = lossyPredictorQ(img, K, Q, alpha);
img_restored = decompressor(img_compressed, alpha);

% img_compressed = lossyPredictor2ndOrder(img, K, alpha);
% img_restored = decompressor2ndOrder(img_compressed, alpha);

figure
% title(['K = ' K ', Q = ' Q ', alpha = ' alpha])
subplot(1,3,1)
imshow(img, [])
title('Original image')
subplot(1,3,2)
imshow(normalize(img_compressed), [])
title(strcat('K=', num2str(K), ', Q=', num2str(Q), ', alpha=', num2str(alpha)))
subplot(1,3,3)
imshow(img_restored, [])
compressionGain = computeCompressionGain(img, img_compressed)
title(strcat('Restored image, compressionGain=', num2str(compressionGain)))


function e = losslessPredictor(im, alpha)
    im = double(im);
    [m, n] = size(im);
    e = double(zeros(m, n));
    e(1:end, 1) = im(1:end, 1);

    for i = 1:m
        for j = 2:n
            e(i, j) = im(i, j) - round(alpha*im(i, j-1));
        end
    end
end

function e_ = lossyPredictor(im, K, alpha)
    im = double(im);
    [m, n] = size(im);
    e_ = double(zeros(m, n));
    e_(1:end, 1) = im(1:end, 1);

    for i = 1:m
        for j = 2:n
            e = im(i, j) - round(alpha * ( e_(i, j-1) + im(i, j-1) ) );
            if e >= 0
                e_(i, j) = K;
            else 
                e_(i, j) = -K;
            end
        end
    end
end

function e_ = lossyPredictor2ndOrder(im, K, alpha)
    Q = 2;
    im = double(im);
    [m, n] = size(im);
    e_ = double(zeros(m, n));
    e_(1:end, 1:2) = im(1:end, 1:2);
    im_ = double(zeros(m, n));
    im_(1:end, 1:2) = im(1:end, 1:2);

    for i = 1:m
        for j = 3:n
            prediction = round( im_(i, j-1) + alpha * ( im_(i, j-1) - im_(i, j-2) ) );
            e = im(i, j) - prediction;
            e_(i, j) = quant(e, K, Q);
            im_(i, j) = e_(i, j) + prediction;
        end
    end
end

function e_ = lossyPredictorQ(im, K, Q, alpha)
    im = double(im);
    [m, n] = size(im);
    e_ = double(zeros(m, n));
    e_(1:end, 1) = im(1:end, 1);
    im_ = double(zeros(m, n));
    im_(1:end, 1) = im(1:end, 1);

    for i = 1:m
        for j = 2:n
            prediction = alpha * im_(i, j-1);
            e = im(i, j) - prediction;
            e_(i, j) = quant(e, K, Q);
            im_(i, j) = e_(i, j) + prediction;
        end
    end
end

function y = decompressor(error, alpha)
    [m, n] = size(error);
    y = zeros(m, n);
    y(1:end, 1) = error(1:end, 1);

    for i = 1:m
        for j = 2:n
            y(i, j) = error(i, j) + round(alpha * y(i, j-1));
        end
    end
end

function y = decompressor2ndOrder(error, alpha)
    [m, n] = size(error);
    y = zeros(m, n);
    y(1:end, 1:2) = error(1:end, 1:2);

    for i = 1:m
        for j = 3:n
            prediction = round( y(i, j-1) + alpha * ( y(i, j-1) - y(i, j-2) ) );
            y(i, j) = error(i, j) + prediction;
        end
    end
end

function e_ = quant(e, K, Q)
    delta = 511 / Q;
    level = ceil( abs(e) / delta);
    e_ = level * K * sign(e);
end

function y = normalize(x)
    y = x;
    mn = min(y);
    y = y + abs(mn);
    mx = max(y);
    y = uint8(y./mx.*255);
end

function y = computeCompressionGain(original, compressed)
    compressed = normalize(compressed);
    y = entropy(original)/entropy(compressed);
end