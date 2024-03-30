clear variables
close all

imTraining = imread("images\boat\img1.pgm");
imTraining = im2gray(imTraining);
normsc = 512/max(size(imTraining));
imTraining = imresize(imTraining, normsc);

keypointsTraining = siftkeypoints(imTraining);
disp(length(keypointsTraining))
showkeypoints(imTraining, keypointsTraining, 3.3)

imTest = imread("images\boat\img5.pgm");
imTest = im2gray(imTest);
normsc = 512/max(size(imTest));
imTest = imresize(imTest, normsc);

keypointsTest = siftkeypoints(imTest);
disp(length(keypointsTest))
showkeypoints(imTest, keypointsTest, 3.3)

% descriptorsTraining = siftdescriptors(imTraining, keypointsTraining, 1.6);
% descriptorsTest = siftdescriptors(imTest, keypointsTest, 1.6);


