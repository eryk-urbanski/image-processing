% test = imread('cameraman.tif');
% represent_DFT(fftshift(fft2(test)))
figure
i = imread('cameraDegrad.tif');
I = fft2(i);
I = fftshift(I);
subplot(1,2,1)
represent_DFT(I)

% 1. degredation function: H = first-order, low-pass Butterworth filter with Do=10 (but the image also has noise, so inverse filtering will probably amplify the noise and the result will not be good)
% 2. identify noise region ([m=33 n=55], [35 57], [38 60]), seperate it to model noise
% 3. inverse filtering: F'(u,v) = G(u,v)/H(u,v)
% 4. Wiener filtering: 1/H * abs(H)^2/(abs(H)^2 + gamma*Sn/Sf) * G

[m, n] = size(i);
H = butter(m, n, 10, 1);
subplot(1,2,2)
imshow(H)
title('Butterworth mask degrading the image')

figure
subplot(1,2,1)
i_restored = inverse(I, H);
subplot(1,2,2)
imshow(abs(i_restored),[])
title('Image after inverse filtering')

% Wiener filtering with the K parameter
figure
subplot(1,3,1)
imshow(abs(wiener_K(I, H, 0.05)), [])
title('Image after Wiener filtering with K = 0.05')
subplot(1,3,2)
imshow(abs(wiener_K(I, H, 0.007)), [])
title('Image after Wiener filtering with K = 0.007')
subplot(1,3,3)
imshow(abs(wiener_K(I, H, 0.002)), [])
title('Image after Wiener filtering with K = 0.002')

% Wiener filtering with modelling the noise
% identified noise points [m=33 n=55], [35 57], [38 60]
figure
n_centroid = (55+57+60)/3;
m_centroid = (33+35+38)/3;
uk = floor(n/2)+1 - n_centroid;
vk = floor(m/2)+1 - m_centroid;
r = sqrt((n_centroid-55)^2+(m_centroid-33)^2);
filt = 1 - notch_butter(m, n, r*2, 6, uk, vk);
N = I.*filt;
subplot(1,3,1)
represent_DFT(N)
title('Seperated noise')

gamma = 1;
S_N = N.*N;
I_restored = 1./H .* (abs(H).*abs(H) ./ (abs(H).*abs(H) + gamma.*S_N)) .* I;
subplot(1,3,2)
represent_DFT(I_restored)
i_restored = ifft2(ifftshift(I_restored));
subplot(1,3,3)
imshow(abs(i_restored), [])
title("Restored image with gamma = "+gamma)

function y = inverse(I, H)
    Y = I./H;
    represent_DFT(Y)
    Y = ifftshift(Y);
    y = ifft2(Y);
end

function y = wiener_K(I, H, K)
    y = ifft2(ifftshift(1./H .* abs(H).^2 ./ (abs(H).^2 + K) .* I));
end

function y = butter(m, n, r, order)
    y = zeros(m,n);
    for i = 1:m
        for j = 1:n
            D = sqrt((j-floor(n/2)-1)^2+(i-floor(m/2)-1)^2);
            y(i,j) = 1/(1 + (D/r)^(2*order));
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