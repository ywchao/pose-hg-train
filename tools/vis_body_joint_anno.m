% 1. only visualize training set now
% 2. run convert_annot.m first

addpath('common');

% mode = 'pi';  % per image
mode = 'pp';  % per person

% set paths
im_root = './data/mpii/images/';
vis_root = './outputs/vis_body_joints_%s/';
vis_root = sprintf(vis_root,mode);

% make directories
makedir(vis_root);

% set body joint config
pa = [2 3 7 7 4 5 8 9 10 0 12 13 9 9 14 15];
p_no = numel(pa);

% set vis params
msize = 4;
partcolor = {'c','c','c','y','y','y','m','m','m','m','b','b','b','r','r','r'};

rlen = 256;

% load annotation
load('./data/mpii/annot/train.mat');

figure(1);

for i = 1:numel(annot_tr)
    % print
    if mod(i,1000) == 0
        fprintf('processed %04d images.\n',i);
    end
    % skip if vis file exists
    switch mode
        case 'pi'
            vis_file = [vis_root annot_tr(i).imgname];
        case 'pp'
            vis_file = [vis_root annot_tr(i).imgname(1:end-4) '_' num2str(annot_tr(i).person,'%02d') '.jpg'];
    end
    if exist(vis_file,'file')
        continue
    end
    % read image
    switch mode
        case 'pi'
            if i == 1 || strcmp(annot_tr(i).imgname,annot_tr(i-1).imgname) == 0
                im_file = [im_root annot_tr(i).imgname];
                im = imread(im_file);
                h = imshow(im); hold on;
                setup_im_gcf(size(im,1),size(im,2));
            end
        case 'pp'
            im_file = [im_root annot_tr(i).imgname];
            im_full = imread(im_file);
            r = annot_tr(i).scale * 200;
            x1_bb = round(annot_tr(i).center(1) - r/2);
            y1_bb = round(annot_tr(i).center(2) - r/2);
            x2_bb = round(annot_tr(i).center(1) + r/2);
            y2_bb = round(annot_tr(i).center(2) + r/2);
            assert(x1_bb < size(im_full,2) && x2_bb > 1 && y1_bb < size(im_full,1) && y2_bb > 1);
            pad_l = 0;
            pad_t = 0;
            pad_r = 0;
            pad_b = 0;
            if x1_bb < 1
                pad_l = -x1_bb+1;
                x1_bb = 1;
            end
            if y1_bb < 1
                pad_t = -y1_bb+1;
                y1_bb = 1;
            end
            if x2_bb > size(im_full,2)
                pad_r = x2_bb-size(im_full,2);
                x2_bb = size(im_full,2);
            end
            if y2_bb > size(im_full,1)
                pad_b = y2_bb-size(im_full,1);
                y2_bb = size(im_full,1);
            end
            im = im_full(y1_bb:y2_bb,x1_bb:x2_bb,:);
            im = padarray(im,[pad_t,pad_l],'pre');
            im = padarray(im,[pad_b,pad_r],'post');
            rfactor = rlen/((size(im,1)+size(im,2))/2);
            im = imresize(im,[rlen,rlen]);
            h = imshow(im); hold on;
            setup_im_gcf(size(im,1),size(im,2));
    end
    % visualize each key point
    for child = 1:p_no
        if pa(child) == 0
            continue
        end
        x1 = annot_tr(i).part(pa(child),1);
        y1 = annot_tr(i).part(pa(child),2);
        x2 = annot_tr(i).part(child,1);
        y2 = annot_tr(i).part(child,2);
        if strcmp(mode,'pp') == 1
            x1 = (x1 - x1_bb + pad_l) * rfactor;
            y1 = (y1 - y1_bb + pad_t) * rfactor;
            x2 = (x2 - x1_bb + pad_l) * rfactor;
            y2 = (y2 - y1_bb + pad_t) * rfactor;
        end
        % skip invisible joints
        if annot_tr(i).visible(child)
            plot(x2, y2, 'o', ...
                'color', partcolor{child}, ...
                'MarkerSize', msize, ...
                'MarkerFaceColor', partcolor{child});
            if annot_tr(i).visible(pa(child))
                plot(x1, y1, 'o', ...
                    'color', partcolor{child}, ...
                    'MarkerSize', msize, ...
                    'MarkerFaceColor', partcolor{child});
                line([x1 x2], [y1 y2], ...
                    'color', partcolor{child}, ...
                    'linewidth',round(msize/2));
            end
        end
    end
    drawnow;
    % save vis to file
    switch mode
        case 'pi'
            if i == numel(annot_tr) || strcmp(annot_tr(i).imgname,annot_tr(i+1).imgname) == 0
                print(gcf,vis_file,'-djpeg','-r0');
                clf;
            end
        case 'pp'
            print(gcf,vis_file,'-djpeg','-r0');
            clf;
    end
end
fprintf('\n');

close;
