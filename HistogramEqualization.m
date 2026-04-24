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
rgb = imread(fullfile(path, file));
catch err
errordlg(err.message);
return;
end

% Step 3: Convert to grayscale
img = rgb2gray(rgb);
newimg = zeros(size(img,1), size(img, 2));
totalpixels = 0;
cumuprob = 0;
tab = zeros(6,256);
tab(1,:) = 0:1:255;
for i = 1:size(img,1)
    for j = 1:size(img,2)
        brightness = img(i,j);
        tab(2, brightness+1) = tab(2,brightness+1)+1;
        totalpixels = totalpixels+1;
    end
end
for i = 1:size(tab, 2)
    probability = tab(2,i)/totalpixels;
    tab(3, i) = probability;
    cumuprob = probability + cumuprob;
    tab(4,i) = cumuprob;
    multicumprob = cumuprob*250;
    tab(5,i) = multicumprob;
    fround = floor(multicumprob);
    tab(6,i) = fround;
end

for i = 1:size(img,1)
    for j = 1:size(img,2)
        newimg(i,j) = tab(6, img(i,j)+1)/250;
    end
end

% Step 4: Display both
figure(1);
subplot(1,2,1); imshow(img); title(['Original: ' file]);
subplot(1,2,2); imshow(newimg); title('Changed: ');
whos;