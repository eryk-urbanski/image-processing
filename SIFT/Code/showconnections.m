function showconnections(imTrain, imTest, kpTrain, kpTest, matches)
    figure;
    imshow([imTrain, imTest]);
    
    hold on;
    
    for i = 1:size(matches, 1)
        % point1 = kpTrain(matches(i, 1)).Loc
        % point2 = keypoints2(matches(i, 2)).Location + [size(image1, 2), 0];  % Shift x-coordinate for the second image
    
        % Draw a line connecting matched keypoints
        line([point1(1), point2(1)], [point1(2), point2(2)], 'Color', 'r', 'LineWidth', 1);
    end
    
    hold off;
    title('Matched Keypoints');
end