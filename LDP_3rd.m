%   Copyright (c) 2016 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato
function F = LDP_3rd(I)
%   LDP_3rd returns the third-order derivation on 4 directions: 0, 45, 90
%   and 135 degrees 
%   I: the grayscaled image
    [h,w] = size(I);

    h1 = [0 0 0; 0 1 -1; 0 0 0];
    h2 = [0 0 -1; 0 1 0; 0 0 0];
    h3 = [0 -1 0; 0 1 0; 0 0 0];
    h4 = [-1 0 0; 0 1 0; 0 0 0];
    
    F_2nd = LDP_2nd(I);
    F = [imfilter(F_2nd(:,1:w), h1), imfilter(F_2nd(:,w+1:2*w), h2), imfilter(F_2nd(:,2*w+1:3*w), h3), imfilter(F_2nd(:, 3*w+1:4*w), h4)];
end
