function [ pim, dim ] = MakeDichromatIms( im )
%This function transform the input image into two different images how they
%perceived by dichromats people (protan and deutan)
%   
    R = double(im(:, :, 1));
    G = double(im(:, :, 2));
    B = double(im(:, :, 3));
    
    r = (R/255).^(2.2);
    g = (G/255).^(2.2);
    b = (B/255).^(2.2);
    
    pr1 = 0.992052*r + 0.003974;
    pg1 = 0.992052*g + 0.003974;
    pb1 = 0.992052*b + 0.003974;
    
    dr1 = 0.957237*r + 0.0213814;
    dg1 = 0.957237*g + 0.0213814;
    db1 = 0.957237*b + 0.0213814;
    
    M = [17.8824 43.5161 4.11935; 3.45565 27.1554 3.86714; 0.0299566 0.184309 1.46709];
    
    P = [0 2.02344 -2.52581; 0 1 0; 0 0 1];
    D = [1 0 0; 0.494207 0 1.24827; 0 0 1];

    height = size(im, 1);
    width = size(im, 2);
    rp = zeros(height, width); gp = zeros(height, width); bp = zeros(height, width);
    rd = zeros(height, width); gd = zeros(height, width); bd = zeros(height, width);
    for ii=1:height
       for jj=1:width
           protan = inv(M)*P*M*([pr1(ii,jj) pg1(ii,jj) pb1(ii,jj)]');
           deutan = inv(M)*D*M*([dr1(ii,jj) dg1(ii,jj) db1(ii,jj)]');
           
           rp(ii,jj) = protan(1); gp(ii,jj) = protan(2); bp(ii,jj) = protan(3);
           rd(ii,jj) = deutan(1); gd(ii,jj) = deutan(2); bd(ii,jj) = deutan(3);
       end
    end
    
    Rp = 255*(rp.^(1/2.2)); Gp = 255*(gp.^(1/2.2)); Bp = 255*(bp.^(1/2.2));
    Rd = 255*(rd.^(1/2.2)); Gd = 255*(gd.^(1/2.2)); Bd = 255*(bp.^(1/2.2));
    
    pim = zeros(height, width, 3);
    dim = zeros(height, width, 3);
    pim(:,:, 1) = Rp; pim(:,:, 2) = Gp; pim(:,:, 3) = Bp;
    dim(:,:, 1) = Rd; dim(:,:, 2) = Gd; dim(:,:, 3) = Bd;
end

