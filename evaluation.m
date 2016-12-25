test_dir = ('~/Downloads/person_detection_evaluation');


test_im{1}.eval{1} = 'crop001501a.png';
test_im{1}.eval{2} = 'crop001501b.png';
test_im{1}.eval{3} = 'crop001501c.png';
test_im{1}.eval{4} = 'crop001501d.png';
test_im{1}.eval{5} = 'crop001501e.png';
test_im{1}.eval{6} = 'crop001501f.png';
test_im{1}.eval{7} = 'crop001501g.png';
test_im{1}.eval{8} = 'crop001501h.png';


test_im{2}.eval{1} = 'crop001504a.png';
test_im{2}.eval{2} = 'crop001504b.png';
test_im{2}.eval{3} = 'crop001504c.png';
test_im{2}.eval{4} = 'crop001504d.png';

test_im{3}.eval{1} = 'crop001511a.png';
test_im{3}.eval{2} = 'crop001511b.png';

test_im{4}.eval{1} = 'crop001512a.png';
test_im{4}.eval{2} = 'crop001512b.png';
test_im{4}.eval{3} = 'crop001512c.png';
test_im{4}.eval{4} = 'crop001512d.png';
test_im{4}.eval{5} = 'crop001512e.png';
test_im{4}.eval{6} = 'crop001512f.png';

test_im{5}.eval{1} = 'crop001514a.png';
test_im{5}.eval{2} = 'crop001514b.png';
test_im{5}.eval{3} = 'crop001514c.png';
test_im{5}.eval{4} = 'crop001514d.png';
test_im{5}.eval{5} = 'crop001514e.png';
test_im{5}.eval{6} = 'crop001514f.png';

true_positives = 0;
total_positives = 0;
false_negative = 0;
for i=1:length(test_im)
    for j=1:length(test_im{i}.eval)
        fname = [test_dir '/' test_im{i}.eval{j}];
        im = imread(fname);
        im = rgb2gray(im);
        im = im2single(im);
        best_score = 0;
        best_id = 1;
        score =0;
        a_overlap =0;
        a_union=0;
        total_positives = total_positives+size(test_im{i}.pred,2);
        for z =1:size(test_im{i}.pred,2)
            pred_im =  test_im{i}.pred{z};
            pred_im = im2single(pred_im);
            a_overlap = intersect(im,pred_im);
            a_union = union(im,pred_im);
            score = length(a_overlap)/length(a_union);
            if(score>=.5)
                true_positives=true_positives+1;
            end
            
            if(score>best_score)
                best_score = score;
                best_id = z;
            end
        end
        if(score == 0)
            false_negative = false_negative+1;
        end
        
        test_im{i}.best_pred{j} = test_im{i}.pred{best_id};
        test_im{i}.best_score{j} = best_score;
        for t=1:length(test_im{i}.best_pred)
            output_name = test_im{i}.eval{t};
            imwrite(test_im{i}.best_pred{t},output_name);
        end
       
        disp('score');
    disp(best_score);
       
    end
    disp(i);
    
end

precision = true_positives/total_positives
recall = true_positives/(true_positives+false_negative)

