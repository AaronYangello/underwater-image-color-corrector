function ufusion = Underwater_MutiScaleFusion(I, debug)
    %Gamma adjusted image
    gamma = imadjust(I, [], [], 1.5);
    %The sharpened image using unsharp masking
    sharpened = I + normalize(I - imgaussfilt(I, 2))/2;
    
    %Derive weight maps for each input
    Wgamma = weightMap(gamma, debug, 'Gamma Corrected Weight Maps');
    Wsharp = weightMap(sharpened, debug, 'Sharpened Weight Maps');
    
    %Fuse the input images and weight maps using mutiscale fusion
    ufusion = fuse(gamma, Wgamma, sharpened, Wsharp, 3, debug);
    
    %Show plots of intermediate steps
    if(debug)
       figure
       subplot(221), imshow(gamma), title('Input 1: Gamma Corrected');
       subplot(222), imshow(sharpened), title('Input 2: Sharpened');
       subplot(223), imshow(Wgamma), title('Gamma Weight Map');
       subplot(224), imshow(Wsharp), title('Sharpened Weight Map');
       suptitle('Mutlti-Scale Fusion');
    end    

end

%% Linear Normalization Operator
function N = normalize(I)
    %Normalized Output
    N = I;
    %Dimensions
    i = 1:3;
    A = I(:,:,i);
    %Current Maximum
    Amax = max(A(:));
    %Curren Minimum
    Amin = min(A(:));
    %Normalization based on 0 to 255
    N(:,:,i) = (A - Amin)*(255/(Amax-Amin));
end
 
%% Weight derivation
function W = weightMap(I, debug, plotTitle) 
    if ~exist('plotTitle','var')
      plotTitle = '';
    end

    hsv = rgb2hsv(I);
    lum = hsv(:,:,3); avg = mean2(lum);
    [rows,cols] = size(lum);
    x = 1:rows; y = 1:cols;
    
    %Laplacian Weight Map
    lapFilt = fspecial('laplacian',0.5);
    Wlap = abs(imfilter(lum,lapFilt,'replicate'));
    
    %Saliency
    Wsal(x,y) = abs(avg - lum(x,y));
    
    %Saturation
    R = double(I(:,:,1))./255; G = double(I(:,:,2))./255; B = double(I(:,:,3))./255;
    Wsat(x,y) = sqrt( 1/3 * ((R(x,y)-lum(x,y)).^2 + (G(x,y)-lum(x,y)).^2 + (B(x,y)-lum(x,y)).^2));
    
    %Merge maps
    Wsum(x,y) = Wlap(x,y) + Wsal(x,y) + Wsat(x,y);
    W(x,y) = (Wsum(x,y) + 0.1) ./ ((Wlap(x,y) + Wsal(x,y) + Wsat(x,y)) + 0.3);
    
    %Show plots of intermediate steps
    if(debug)
        figure
        subplot(221), imshow(Wlap), title('Laplacian Weight Map');
        subplot(222), imshow(Wsal), title('Saliency Weight Map');
        subplot(223), imshow(Wsat), title('Saturation Weight Map');
        subplot(224), imshow(W), title('Merged Weight Map');
        suptitle(plotTitle);
    end
end

%% Fusion
function fused = fuse(I1, W1, I2, W2, numLevels, debug)
    %Generate Gaussian Pyramids for Weight maps
    % and laplacian pyramids for input images
    G1 = genPyr(W1,'gauss',numLevels); 
    G2 = genPyr(W2,'gauss',numLevels); 
    L1 = genPyr(I1,'lap',numLevels); 
    L2 = genPyr(I2,'lap',numLevels);
    
    %Array to hold results of fusion
    Y = cell(numLevels,1);
    
    %Show plots for intermediate steps
    if(debug)
        figure
        pos = 0;
        for i = 1:numLevels
            subplot(numLevels,4,pos+i), imshow(G1{i});
            title(['Gaussian level ' num2str(i) ' for Gamma Corrected Image']);
            subplot(numLevels,4,pos+i+1), imshow(G2{i});
            title(['Gaussian level ' num2str(i) ' for Sharpened Image']);
            subplot(numLevels,4,pos+i+2), imshow(L1{i});
            title(['Laplacian level ' num2str(i) ' for Gamma Corrected Image']);
            subplot(numLevels,4,pos+i+3), imshow(L2{i});
            title(['Laplacian level ' num2str(i) ' for Sharpened Image']);
            pos = pos + 3;
        end
        suptitle('Gaussian and Laplacian Pyramid Levels');
    end
    

    %Combine levels of pyramids
    for i = 1:numLevels
        x = 1:3;
        [rows,cols,~] = size(L1{i});
        G1{i} = imresize(G1{i}, [rows cols]);
        [rows,cols,~] = size(L2{i});
        G2{i} = imresize(G2{i}, [rows cols]);
        Y{i} = G1{i}.*L1{i}(:,:,x) + G2{i}.*L2{i}(:,:,x);
    end
        
    %Preallocate size for result
    fused = Y{1};
    [rows,cols,planes] = size(fused);
    
    %Sum up results of fusion at each level
    % after appropriate upsampling
    for i = 2:numLevels
       fused = fused + imresize3(Y{i}, [rows cols planes]);
    end
end











