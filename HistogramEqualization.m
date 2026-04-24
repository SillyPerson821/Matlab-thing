clear
clc
% Select the file
[file, path] = uigetfile({'*.jpg;*png;*.bmp','Select an Image'});
if isequal(file,0)
disp('Cancelled');
return;
end

% Load the image
try
rgb = imread(fullfile(path, file));
catch err
errordlg(err.message);
return;
end

img = rgb2gray(rgb); % Set it to grayscale first
% This next bit is just setting up the other stuff
newimg = zeros(size(img,1), size(img, 2));
totalpixels = 0;
cumuprob = 0;
tab = zeros(6,256);
tab(1,:) = 0:1:255;
for i = 1:size(img,1)
    for j = 1:size(img,2)
        brightness = img(i,j); % This checks the brightness value of each pixel
        tab(2, brightness+1) = tab(2,brightness+1)+1; % And adds one to a list of how many pixels of the same value there are
        totalpixels = totalpixels+1; % It also counts how many total pixels there are in the image (for later use)
    end
end
for i = 1:size(tab, 2) % For each of the brightness values:
    probability = tab(2,i)/totalpixels; % It checks what percentage of pixels have this brightness value
    tab(3, i) = probability; % And adds the percentage to the table.
    cumuprob = probability + cumuprob; % It then makes cumulative probability, adding the previous probabilities to the current one.
    tab(4,i) = cumuprob; % And also adds it to the table.
    multicumprob = cumuprob*255; % Then, since the probability is from 0-1, it turns it into a brightness value by multiplying it by 255
    tab(5,i) = multicumprob; % Adds it to the table.
    fround = floor(multicumprob); % Finally, it rounds that final number down to a whole number.
    tab(6,i) = fround; % And adds it to the table.
end

% Then, you replace each pixel in the image with the rounded value from the
% table
for i = 1:size(img,1)
    for j = 1:size(img,2)
        newimg(i,j) = tab(6, img(i,j)+1)/255;
    end
end

% Display both images
figure(1);
subplot(1,2,1); imshow(img); title(['Original: ' file]);
subplot(1,2,2); imshow(newimg); title('Equalized: ');
whos;
