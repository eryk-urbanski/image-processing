function keypointArray = siftkeypoints(im)

    %% Creating the Gaussian scale-space

    S = gaussianscalespace(im, 1.6, 5);

    %% Compute the Difference of Gaussians
    % in: scale-space
    % out: DoG

    DoG = S(:,:,1:end-1) - S(:,:,2:end);

    %% Finding extrema (keypoint candidates) in the stack

    candidateArray = siftcandidates(DoG);

    %% Finding keypoints (eliminating weak extrema)

    threshold = 24;
    [xArray, yArray, sigmaArray] = ind2sub(size(candidateArray), find(candidateArray > threshold));
    nKeypoints = length(xArray);
    keypointArray = [xArray, yArray, sigmaArray, zeros(nKeypoints, 1)];

    %% Computing the principal orientation

    for i = 1:nKeypoints
        ix = keypointArray(i, 1);
        iy = keypointArray(i, 2);
        isigma = keypointArray(i, 3);
        keypointArray(i, 4) = siftprincipalorientation(im, ix, iy, isigma);
    end

end