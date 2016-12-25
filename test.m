test_dir = ('~/Downloads/person_detection_test_data');
test_im{1}.name = 'crop001501';
test_im{2}.name= 'crop001504';
test_im{3}.name = 'crop001511';
test_im{4}.name = 'crop001512';
test_im{5}.name = 'crop001514';


%Load 5 images

for i=1:5
    person_counter = 0;
    counter = 0;
    fname = [test_dir '/' test_im{i}.name '.png'];
     
     im3=imread(fname);
     if(i==1) %Manual resize
        im3 = imresize(im3, .7);
     elseif(i==2)
        im3 = imresize(im3, .4);
     elseif(i==3)
        im3 = imresize(im3, .2);
     elseif(i==4)
        im3 = imresize(im3, .2);
     elseif(i==5)
        im3 = imresize(im3, .25);
     end
   
    im3 = rgb2gray(im3);
    %Slide image looking for the person
    %l = length of the person image w = width of the person image
    [iml imw] = size(im3);
    for x=1:10:(imw-w)
        for y=1:10:(iml-l)
            crop_im = im3(y:y+l-1,x:x+w-1);
            crop_im = im2single(crop_im);
            counter = counter+1;
            %imshow(crop_im);
         
            crop = vl_hog(crop_im,8);
            crop = crop(:);
            %1 = positive person
            %2 = negative person
            pred = predict(model,crop');
            %disp(pred);
            if(pred==1)
                person_counter=person_counter+1;
                person_predict{person_counter}=crop_im;
            end
            y=y+10;
        end
        
        %

        x=x+10;
        
    end
    %Show 3 random predicted images from each set
    for j=1:3
        p=randperm(person_counter,1);
        imshow(person_predict{p});
        figure;
    end
    test_im{i}.pred = person_predict;
    person_predict(:) = {[]};
    person_predict=person_predict(~cellfun('isempty',person_predict)); 
end
