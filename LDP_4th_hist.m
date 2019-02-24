%   Copyright (c) 2016 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato

function hist = LDP_4th_hist(I)
%   LDP_4th_hist returns the unscaled histogram containing 4*2^8 bins of the
%   input image
%   I: the grayscaled image
    [h, w] = size(I);    
    
    hist = zeros(1, 1024); %256 bins for each angle
    
    F = LDP_3rd(I);
    
    F = F > 0;
    
    bin_pattern = [1 2 4; 128 0 8; 64 32 16];
    
    for k = 1:4 % alpha = 0, 45, 90, 135
        for i = 2:h-1 %ignore the borders
            for j = 2:w-1 %ignore the borders
                blk_j = (k-1)*w + j;
                              
                pattern = (F(i-1:i+1, (blk_j-1):(blk_j+1)) - F(i, blk_j)) ~= 0;           
                
                pattern = sum(sum(pattern .* bin_pattern));%0 <= pattern <= 255

                index = (k-1)*256 + pattern + 1;
                hist(index) = hist(index) + 1;
            end
        end
    end
    
    
    
end


