train_dir = ('~/Downloads/person_detection_training_data');

train_pos_dir = [train_dir '/pos'];
train_neg_dir = [train_dir '/neg'];

fnames_train_pos = dir(train_pos_dir);
fnames_train_neg = dir(train_neg_dir);

%Setup
counter=0;
for i=3:length(fnames_train_pos)
    %hog extraction for pos
	fname = [train_pos_dir '/' fnames_train_pos(i).name];
	im = imread(fname);
    im = rgb2gray(im);
    im=im2single(im);
    counter=counter+1;
    train_hog{counter} = vl_hog(im,8);
    train_label{counter}=1; %1 = TRUE
end
pos_length = i-2;
[l w] = size(im);
person=im;
neg_counter = 0;
for i=3:length(fnames_train_neg)
    %hog extraction for neg
    fname = [train_neg_dir '/' fnames_train_neg(i).name];
    im2 = imread(fname);
    im2 = rgb2gray(im2);
    im2 = im2single(im2);
    [l2 w2]=size(im2);
    maxl = l2-l;
    maxw = w2-w;
    for j=1:30
        neg_counter=neg_counter+1;
        counter=counter+1;
        
        rand_l=randperm(maxl,1);
        rand_w=randperm(maxw,1);
        crop_im=im2(rand_l:rand_l+l-1,rand_w:rand_w+w-1);
        
        train_hog{counter}=vl_hog(crop_im,8);
        train_label{counter}=2;     %2 = FALSE
        if(neg_counter==pos_length)
            break;
        end
    end
    if(neg_counter==pos_length)
        break;
    end
end

%SVM TEST
[s1 s2 s3] = size(train_hog{1});
train_hog_vector = zeros(size(train_hog,2),s1*s2*s3);
train_label_vector = zeros(size(train_label,2),1);

for i=1:size(train_hog,2);
   train_hog_vector(i,:) = train_hog{i}(:);
   train_label_vector(i) = train_label{i};
end

model = fitcecoc(train_hog_vector, train_label_vector);



