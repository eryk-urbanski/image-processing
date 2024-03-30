function y = houghTransform(im, Nm, Nb)

    if size(im, 1) ~= size(im, 2)
        disp('ERROR: image_height != image_width')
        return
    end

    N = size(im, 1);
    y = im;
    max_m = 1;
    max_b = 2*N;
    m_values = linspace(-max_m, max_m, Nm);
    b_values = linspace(-max_b, max_b, Nb);

    accumulationTable = zeros(Nm, Nb);

    for i = 1:N
        for j = 1:N
            if im(i, j) == 1
                for k = 1:Nm
                    b = -m_values(k)*j + i;
                    [~, b_indices] = min(abs(b_values-b));
                    accumulationTable(k, b_indices) = accumulationTable(k, b_indices) + 1;
                end
            end
        end
    end

    [~, max_index] = max(accumulationTable(:));
    [best_m_index, best_b_index] = ind2sub(size(accumulationTable), max_index);
    final_m = m_values(best_m_index);
    final_b = b_values(best_b_index);

    for j = 1:N
        i = round(final_m*j + final_b);
        if i > 0 && i <= N
            y(i, j) = 1;
        end
    end
    
end