function uwb = Underwater_WhiteBalance(I, a, debug)
    uwb = I;

    %Separate Color Masks
    Ir = I(:,:,1); %Red
    Ig = I(:,:,2); %Green
    
    %Maximum red and green values
    Rmax = double(max(Ir(:))); Gmax = double(max(Ig(:)));
    
    %Normalize red and green color maps
    Ir_norm = double(Ir) ./ Rmax; Ig_norm = double(Ig) ./ Gmax;
    
    %Find average read and green color values
    Ravg = mean2(Ir_norm); Gavg = mean2(Ig_norm);
    
    %Get number of rows and columns for the red color map
    [rows,cols] = size(Ir_norm);
    x = 1:rows; y = 1:cols;
        
    %Find the pixel locations at which the red values are siginificantly 
    %attenuated. This prevents saturation of red in areas that experienced
    %less color loss
    Irc_norm(x,y) = Ir_norm(x,y) + a.*(Gavg - Ravg).*(1 - Ir_norm(x,y)).*Ig_norm(x,y);
    Irc = uint8(Irc_norm * Rmax);
    
    %Set Red compensated map to original image's Red channel
    uwb(:,:,1) = Irc;
    
    %Alter illumninance using gray-world assumption
    uwb = chromadapt(uwb,illumgray(uwb));
    
    %Test Point
    if(debug)       
        figure;
        subplot(221), imshow(I), title('Original Image (Before White Balance)');
        subplot(222), imshow(uwb), title('Image After Red Compensation');
        subplot(223), imshow(Ir_norm), title('Original Red Channel Before Compensation');
        subplot(224), imshow(Irc_norm), title('Compensated Red Channel');
        suptitle('Red Channel Compensation Comparison');
    end
    
end