%   Copyright (c) 2016 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato
	
function F = LDP_1st(I)
%   LDP_1st returns 1st-order derivation on 4 directions: 0, 45, 90 and 135
%   degree 
%   I: the grayscaled image 
    [h, w] = size(I);

    h1 = [0 0 0; 0 1 -1; 0 0 0];
    h2 = [0 0 -1; 0 1 0; 0 0 0];
    h3 = [0 -1 0; 0 1 0; 0 0 0];
    h4 = [-1 0 0; 0 1 0; 0 0 0];
    F = [imfilter(I,h1), imfilter(I, h2), imfilter(I,h3), imfilter(I, h4)];
end