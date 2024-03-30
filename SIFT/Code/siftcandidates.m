function candidates = siftcandidates(DoG)
    
    candidates = uint8(zeros(size(DoG)));

    for i = 1:size(DoG, 3)

        % Extracting a 2D slice
        slice = DoG(:,:,i);

        % Applying a modified NMS (Non-maximal suppression) algorithm to
        % detect extrema in each 3x3x1 grid
        local_extrema = imregionalmax(abs(slice));
        nms_slice = slice .* uint8(local_extrema);
        candidates(:,:,i) = nms_slice;

    end

    for i = 2:size(candidates, 1)-1
        for j = 2:size(candidates, 2)-1
            for k = 2:size(candidates, 3)-1
                grid = candidates(i-1:i+1, j-1:j+1, k-1:k+1);
                maxVal = max(max(max(grid)));
                grid = grid .* uint8(grid == maxVal);
                candidates(i-1:i+1, j-1:j+1, k-1:k+1) = grid;
            end
        end
    end

end