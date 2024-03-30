i = imread('fabric.jpg');
fontsize = 20;

K = 2;

x = [93, 127];
y = [169, 193];
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,2,1)
imshow(imc, [])
title("Seperating purple with K = "+K, "FontSize", fontsize)

x = [380, 396];
y = [92, 117];
imc = segmentationColor(i, x(1), y(1), x(2), y(2), K);
subplot(1,2,2)
imshow(imc, [])
title("Seperating green with K = "+K, "FontSize", fontsize)