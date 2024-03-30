i = imread('barras.jpg');
fontsize = 20;

K = 100;

x = [1082, 1207];
y = [328, 481];
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,2,1)
imshow(imc, [])
title("Seperating blue with K = "+K, "FontSize", fontsize)

x = [800, 852];
y = [700, 767];
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,2,2)
imshow(imc, [])
title("Seperating light gray with K = "+K, "FontSize", fontsize)