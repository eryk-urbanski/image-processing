i = imread('pillsetc.png');
fontsize = 20;

K = 15;

x = [262, 503];
y = [267, 366];
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,2,1)
imshow(imc, [])
title("Seperating the background with K = "+K, "FontSize", fontsize)

x = [405, 442];
y = [144, 169];
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,2,2)
imshow(imc, [])
title("Seperating green with K = "+K, "FontSize", fontsize)