clear
clc
% Step 1: Select file
[file, path] = uigetfile({'*.jpg;*png;*.bmp','Select an Image'});
if isequal(file,0)
disp('Cancelled');
return;
end

% Step 2: Load Image
try
img = imread(fullfile(path, file));
catch err
errordlg(err.message);
return;
end
newimg = img; % Some extra setup
% Choose the kernel size
kernelsize = input("How many pixels big will the kernel be? ");
kernel = zeros(kernelsize, kernelsize);
% this part makes the kernel, going one square at a time to set the numbers
for i = 1:kernelsize
    for j = 1:kernelsize
        kernel(i,j) = 1/((kernelsize)^2); % All of the kernel's values are the same, but it all needs to add up to 1.
    end
end

% Next, we blur the image
for a = 1:3 % Each rgb value must be changed individually
finalpixel = zeros(kernelsize, kernelsize);
for j = 1:size(img, 2)
    for i = 1:size(img, 1) % Repeating for each pixel in the image
        kernelmult = zeros(kernelsize, kernelsize); % This whole thing basically makes a chunk surrounding a pixel, making it the same size as the kernel
        for k = 1:kernelsize 
            for l = 1:kernelsize % Repeating for each pixel in the kernel, to make it the same size
                offseth = (k-ceil(kernelsize/2))+i; % These two parts choose how far up, down, left, or right a specific pixel in the new chunk will be.
                offsetv = (l-ceil(kernelsize/2))+j;
                if (offseth > 0) && (offseth <= size(img, 1)) && offsetv > 0 && offsetv <= size(img, 2)
                    kernelmult(k,l) = img(offseth,offsetv, a); % As long as the pixel is valid, it checks where that offset pixel is and adds its value to the chunk.
                else
                kernelmult(i,j) = 0; % If the pixel is invalid, it just counts as 0.
                end
            end
        end
% Then, you have to multiply the kernel and the image chunk:
        for k = 1:kernelsize
            for l = 1:kernelsize
                finalpixel(k,l) = kernelmult(k,l)*kernel(k,l);
            end
        end
        newimg(i, j, a) = sum(sum(finalpixel)); % then you replace the original pixel in the image with the new pixel on a blank canvas, combining the new multiplied chunk into one value.
    end
end
end
% Now, show the new image
figure(1);
subplot(1,2,1); imshow(img); title(['Original: ' file]);
subplot(1,2,2); imshow(newimg); title('Blurred');
whos;
