%% Create the Gaussian scale-space
% in: image, initial sigma, number of sigmas (number of layers in
% scale-space)
% out: scale-space
%
% Scale-space: Stack created by filtering an image with Gaussians with
% different sigma
% S(x,y,σ) = n(x,y,σ) conv I(x,y)

function S = gaussianscalespace(im, sigmaInit, nSigmas)
    S = uint8(zeros(size(im, 1), size(im, 2), nSigmas));
    nextMultiplier = 1;
    for i = 1:nSigmas
        S(:, :, i) = imgaussfilt(im, sigmaInit*nextMultiplier);
        nextMultiplier = nextMultiplier * sqrt(2);
    end
end