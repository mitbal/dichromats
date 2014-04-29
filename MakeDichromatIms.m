function [ pim, dim ] = MakeDichromatIms( im )
%This function transform the input image into two different images how they
%perceived by dichromats people (protan and deutan)

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

    % Allocate the output image
    pim = zeros(size(im));
    dim = zeros(size(im));
    
    % Apply the transformation for each pixel
    for ii=1:size(im, 1)
       for jj=1:size(im, 2)
           protan = Tp*([pR(ii,jj) pG(ii,jj) pB(ii,jj)]');
           deutan = Td*([dR(ii,jj) dG(ii,jj) dB(ii,jj)]');
           
           pim(ii, jj, 1) = protan(1); pim(ii, jj, 2) = protan(2); pim(ii, jj, 3) = protan(3);
           dim(ii, jj, 1) = deutan(1); dim(ii, jj, 2) = deutan(2); dim(ii, jj, 3) = deutan(3);
       end
    end
    
    % Reverse the initial transform
    pim = 255*(pim.^(1/2.2));
    dim = 255*(dim.^(1/2.2));
end
