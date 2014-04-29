function [ pim, dim ] = MakeDichromatIms2( im )
%This function transform the input image into two different images how they
%perceived by dichromats people (protan and deutan) faster using matrix
%operation in Matlab

    im = double(im);
    
    % Normalize transform the original RGB value
    im1 = (im/255).^(2.2);
    R = im1(:, :, 1);
    G = im1(:, :, 2);
    B = im1(:, :, 3);
    
    % Protan transform
    pR = 0.992052*R + 0.003974;
    pG = 0.992052*G + 0.003974;
    pB = 0.992052*B + 0.003974;
    
    % Deutan transform
    dR = 0.957237*R + 0.0213814;
    dG = 0.957237*G + 0.0213814;
    dB = 0.957237*B + 0.0213814;
    
    % Transformation matrix from RGB to LMS
    M = [17.8824 43.5161 4.11935; 
         3.45565 27.1554 3.86714; 
         0.0299566 0.184309 1.46709];
    
    % Protan projection
    P = [0 2.02344 -2.52581; 0 1 0; 0 0 1];
    
    % Deutan projection
    D = [1 0 0; 0.494207 0 1.24827; 0 0 1];

    % Precompute the transformation matrix before loop to speed things up
    Tp = inv(M)*P*M;
    Td = inv(M)*D*M;
    
    % Apply the transformation using matrix operation
    PP = Tp * [pR(:)'; pG(:)'; pB(:)'];
    DD = Td * [dR(:)'; dG(:)'; dB(:)'];
    
    % Reverse the initial transform
    PP = 255*(PP.^(1/2.2));
    DD = 255*(DD.^(1/2.2));
    
    % Reshape the computed vector back
    pim = zeros(size(im));
    pim(:,:, 1) = reshape(PP(1, :), size(R));
    pim(:,:, 2) = reshape(PP(2, :), size(G));
    pim(:,:, 3) = reshape(PP(3, :), size(B));
    
    dim = zeros(size(im));
    dim(:,:, 1) = reshape(DD(1, :), size(R));
    dim(:,:, 2) = reshape(DD(2, :), size(G));
    dim(:,:, 3) = reshape(DD(3, :), size(B));
end

