i = imread('fichas.jpg');
subplot(1,3,1)
imshow(i)
fontsize = 16;

K = 25;

x = [189, 207];
y = [160, 171];
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,3,2)
imshow(imc, [])
title("Seperating orange with K = "+K, "FontSize", fontsize)

x = [350, 393];
y = [173, 288];
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,3,3)
imshow(imc, [])
title("Seperating the background with K = "+K, "FontSize", fontsize)