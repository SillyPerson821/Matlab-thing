%% Main Script: Image Segmentation Project
clc; clear; close all;

% 1. Robust File Selection
[file, path] = uigetfile({'*.jpg;*.png;*.bmp;*.tif;*.jpeg', 'Image Files (*.jpg, *.png, *.bmp, *.tif)'}, 'Select your Mushroom Image');

% Check if the user cancelled
if isequal(file, 0)
    disp('User selected Cancel');
    return;
end

% Construct full path and try to read
fullFileName = fullfile(path, file);
try
    original_img = imread(fullFileName);
catch ME
    % If imread fails, this tells you exactly why
    fprintf('Error reading file: %s\n', fullFileName);
    fprintf('MATLAB Error: %s\n', ME.message);
    fprintf('Try opening the image in Paint/Photos and "Saving As" a new .jpg or .png file.\n');
    return;
end

% 2. Get User Input for K
K_input = input('Enter number of clusters K (or 0 for Auto): ');
K = K_input;
if K_input == 0
    fprintf('Running Elbow Method...\n');
    K = findOptimalK(original_img);
end

% 3. Run Universal K-Means (Handles Grayscale and RGB automatically)
segmented_img = myKMeans(original_img, K);

% 4. Visualization
figure('Name', 'K-Means Result');
subplot(1,2,1); imshow(original_img); title('Original');
subplot(1,2,2); imshow(segmented_img); title(['Segmented (K=', num2str(K), ')']);

%% --- Core Function: Manual K-Means ---
function segmented_img = myKMeans(img, K)
    [rows, cols, channels] = size(img);
    img_double = double(img);
    pixels = reshape(img_double, rows * cols, channels);
    
    % Initialize random centroids
    rand_idx = randi(size(pixels, 1), [K, 1]);
    centroids = pixels(rand_idx, :);
    
    for iter = 1:50
        old_centroids = centroids;
        dist = zeros(size(pixels, 1), K);
        for k = 1:K
            diffs = pixels - centroids(k, :);
            dist(:, k) = sqrt(sum(diffs.^2, 2)); % Euclidean distance
        end
        [~, labels] = min(dist, [], 2);
        for k = 1:K
            cluster_data = pixels(labels == k, :);
            if ~isempty(cluster_data)
                centroids(k, :) = mean(cluster_data, 1);
            end
        end
        if isequal(old_centroids, centroids), break; end
    end
    segmented_pixels = centroids(labels, :);
    segmented_img = uint8(reshape(segmented_pixels, rows, cols, channels));
end

%% --- Bonus #1: Elbow Method ---
function bestK = findOptimalK(img)
    [r, c, ch] = size(img);
    pixels = reshape(double(img), r*c, ch);
    wcss = zeros(1, 5); 
    for k = 1:5
        rand_idx = randi(size(pixels, 1), [k, 1]);
        cents = pixels(rand_idx, :);
        for i = 1:10
            d = zeros(size(pixels, 1), k);
            for j = 1:k
                d(:, j) = sum((pixels - cents(j, :)).^2, 2);
            end
            [min_d, labs] = min(d, [], 2);
            for j = 1:k
                if any(labs == j), cents(j,:) = mean(pixels(labs==j,:),1); end
            end
        end
        wcss(k) = sum(min_d);
    end
    diff2 = diff(diff(wcss));
    [~, idx] = max(diff2);
    bestK = idx + 1;
end
