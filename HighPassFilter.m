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
image = img;
img = rgb2gray(img);
newimg = img;
kernelsize = 3;
kernel = [0,-1,0;-1,4,-1;0,-1,0];
finalpixel = zeros(kernelsize, kernelsize);
for j = 1:size(img, 2)
    for i = 1:size(img, 1)
        kernelmult = zeros(kernelsize, kernelsize);
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
                finalpixel(k,l) = kernelmult(k,l)*kernel(k,l);
            end
        end
        newimg(i, j) = sum(sum(finalpixel));
    end
end

newimg = uint8(newimg); % Convert to uint8 for display
figure(1);
subplot(1,2,1); imshow(image); title(['Normal: ' file]);
subplot(1,2,2); imshow(newimg); title('High Pass:');
whos;
