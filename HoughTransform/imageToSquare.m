function y = imageToSquare(im)
    y = im(1:min(size(im)), 1:min(size(im)));
end