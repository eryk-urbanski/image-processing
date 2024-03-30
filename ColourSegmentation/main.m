i = imread('fichas.jpg');
figure
subplot(1,2,1)
imshow(i)

[x, y] = ginput(2);
x = sort(round(x));
y = sort(round(y));
K = 10;
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,2,2)
imshow(imc, [])
title("K = "+K)
