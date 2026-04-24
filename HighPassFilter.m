clear
clc
% Select file
[file, path] = uigetfile({'*.jpg;*png;*.bmp','Select an Image'});
if isequal(file,0)
disp('Cancelled');
return;
end

% Load Image
try
img = imread(fullfile(path, file));
catch err
errordlg(err.message);
return;
end
% Some extra setup:
image = img;
img = rgb2gray(img);
newimg = img;
kernelsize = 3; % This is copied from the low pass filter for simpler writing, so the kernel size is specified here.
kernel = [0,-1,0;-1,4,-1;0,-1,0]; % The kernel itself is defined, but I don't know what the kernel would look like if it was bigger so it's just defined normally.
finalpixel = zeros(kernelsize, kernelsize);
for j = 1:size(img, 2)
    for i = 1:size(img, 1)
        kernelmult = zeros(kernelsize, kernelsize); % Just like the low pass filter, this makes a chunk of pixels to multiply with the kernel.
        for k = 1:kernelsize
            for l = 1:kernelsize
                offseth = (k-ceil(kernelsize/2))+i;
                offsetv = (l-ceil(kernelsize/2))+j;
                if (offseth > 0) && (offseth <= size(img, 1)) && offsetv > 0 && offsetv <= size(img, 2)
                    kernelmult(k,l) = img(offseth,offsetv);
                else
                kernelmult(i,j) = 0;
                end
            end
        end
        for k = 1:kernelsize 
            for l = 1:kernelsize
                finalpixel(k,l) = kernelmult(k,l)*kernel(k,l); % Multiplying the kernel and the pixel chunk..
            end
        end
        newimg(i, j) = sum(sum(finalpixel)); % Sums the parts all together and that's your new pixel.
    end
end

% Display the images
figure(1);
subplot(1,2,1); imshow(image); title(['Normal: ' file]);
subplot(1,2,2); imshow(newimg); title('High Pass:');
whos;

