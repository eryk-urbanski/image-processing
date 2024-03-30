figure
i = imread('cameraman.tif');
I = fft2(i);
I = fftshift(I);
subplot(1,2,1)
represent_DFT(I)

i_noise = imread('cameranoise.tif');
I_noise = fft2(i_noise);
I_noise = fftshift(I_noise);
subplot(1,2,2)
represent_DFT(I_noise)
title('Centred FFT')
% identified sinusoidal noise positions: 
% [n=67 m=87], [69 89], [72 92], also some other surrounding points seem to be
% slightly different

figure

[m, n] = size(I_noise);
r = sqrt((floor(m/2)+1 - 92-1)^2 + (floor(n/2)+1 - 72-1)^2); % radius for low-pass filtering
% r = sqrt((m/2+1 - 87)^2 + (n/2+1 - 67)^2); % radius for seperating the noise

filt = ideal(m, n, r, "low-pass");
subplot(1,3,1)
imshow(filt)
title('Ideal filter')

I_denoised = I_noise.*filt;
subplot(1,3,2)
represent_DFT(I_denoised)
title('Filtered FFT')
I_denoised = ifftshift(I_denoised);
i_denoised = ifft2(I_denoised);
subplot(1,3,3)
imshow(uint8(i_denoised))
title('Denoised image using low-pass filter')

figure

[m, n] = size(I_noise);
% n_central = 67 + round((72-67)/2);
% m_central = 87 + round((92-87)/2);
n_centroid = (67+69+72)/3;
m_centroid = (87+89+92)/3;
uk = floor(n/2)+1 - n_centroid;
vk = floor(m/2)+1 - m_centroid;
order = 6;
r = sqrt((n_centroid-67)^2+(m_centroid-87)^2)*2;

filt = notch_butter(m, n, r, order, uk, vk);
subplot(1,3,1)
imshow(filt)
title('Notch filter')

I_denoised = I_noise.*filt;
subplot(1,3,2)
represent_DFT(I_denoised)
title('Filtered FFT using Notch filter of order 6')
I_denoised = ifftshift(I_denoised);
i_denoised = ifft2(I_denoised);
subplot(1,3,3)
imshow(uint8(i_denoised))
title('Denoised image using Notch filter of order 6')

figure
order = 3;
filt = 1 - notch_butter(m, n, r, order, uk, vk); % seperating the noise
subplot(1,3,1)
imshow(filt)
I_seperatednoise = I_noise.*filt;
subplot(1,3,2)
represent_DFT(I_seperatednoise)
I_seperatednoise = ifftshift(I_seperatednoise);
i_seperatednoise = ifft2(I_seperatednoise);
subplot(1,3,3)
imshow(uint8(i_seperatednoise))
title('Seperated noise using 1 - Notch filter of order 3')

function y = ideal(m, n, r, type)
    if type == "low-pass"
        y = zeros(m,n);
        temp = 1;
    elseif type == "high-pass"
        y = ones(m,n);
        temp = 0;
    end
    for i = 1:m
        for j = 1:n
            if sqrt((j-floor(n/2)-1)^2+(i-floor(m/2)-1)^2) <= r
                y(i, j) = double(temp);
            end
        end
    end
end

function y = notch_butter(m, n, r, order, uk, vk)
    Dpos = zeros(m,n);
    Dneg = zeros(m,n);
    for i = 1:m
        for j = 1:n
            Dk = sqrt((j-floor(n/2)-1-uk)^2+(i-floor(m/2)-1-vk)^2);
            D_k = sqrt((j-floor(n/2)-1+uk)^2+(i-floor(m/2)-1+vk)^2);
            Dpos(i, j) = (1/(1 + (r/Dk)^(2*order)));
            Dneg(i, j) = (1/(1 + (r/D_k)^(2*order)));
        end
    end
    y = Dpos .* Dneg;
end

function represent_DFT(F)
    repr = log2(1+abs(F));
    K = 255 / max(max(repr));
    repr = K.*repr;

    imshow(uint8(repr))
end