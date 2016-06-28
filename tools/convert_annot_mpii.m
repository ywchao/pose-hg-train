
anno = load('./data/mpii/annot/mpii_human_pose_v1_u12_1.mat');
anno = anno.RELEASE;

annot_tr_file = './data/mpii/annot/train.mat';
annot_ts_file = './data/mpii/annot/test.mat';

if exist(annot_tr_file,'file') && exist(annot_ts_file,'file')
    % load annot
    fprintf('loading annot ... \n');
    load(annot_tr_file);
    load(annot_ts_file);
    fprintf('done.\n');
else
    % get number of images
    nimages = numel(anno.img_train);
    fprintf('total: %d images\n',nimages);
    % initialize annot
    annot_tr = struct('index',[],'person',[],'imgname',[],'center',[],'scale',[], ...
        'part',[],'visible',[],'normalize',[],'torsoangle',[]);
    annot_ts = struct('index',[],'person',[],'imgname',[],'center',[],'scale',[], ...
        'part',[],'visible',[],'normalize',[],'torsoangle',[]);
    annot_tr = repmat(annot_tr,[0,1]);
    annot_ts = repmat(annot_ts,[0,1]);
    % get train/test split
    istrain = zeros(nimages,1);
    for i = 1:nimages
        istrain(i) = anno.img_train(i) == 1 && ...
            ~isempty(anno.annolist(i).annorect) && ...
            isfield(anno.annolist(i).annorect,'annopoints');
    end
    % start processing each image
    for i = 1:nimages
        % print
        if mod(i,1000) == 0
            fprintf('processed %04d images.\n',i);
        end
        npeople = numel(anno.annolist(i).annorect);
        for j = 1:npeople
            % get annorect
            annorect = anno.annolist(i).annorect(j);
            % location
            if isempty(annorect) || ~isfield(annorect,'scale') || ~isfield(annorect,'objpos')
                assert(istrain(i) == 0);
                continue
            else
                if ~isempty(annorect.scale) && ~isempty(annorect.objpos)
                    scale = annorect.scale;
                    center = [annorect.objpos.x,annorect.objpos.y];
                else
                    continue
                end
            end
            % adjust center/scale slightly to avoid cropping limbs
            center(2) = center(2) + 15 * scale;
            scale = scale * 1.25;
            % part annotations and visibility
            if ~isfield(annorect,'annopoints')
                assert(istrain(i) == 0);
                coords = zeros(16,2);
                vis = zeros(16,1);
            else
                if isempty(annorect.annopoints.point)
                    coords = -1*ones(16,2);
                    vis = -1*ones(16,1);
                else
                    coords = zeros(16,2);
                    vis = zeros(16,1);
                    for k = 1:numel(annorect.annopoints.point)
                        % id is zero-based
                        id = annorect.annopoints.point(k).id+1;
                        coords(id,1) = annorect.annopoints.point(k).x;
                        coords(id,2) = annorect.annopoints.point(k).y;
                        if isfield(annorect.annopoints.point(k),'is_visible')
                            if isempty(annorect.annopoints.point(k).is_visible)
                                vis(id) = 1;
                            else
                                vis(id) = annorect.annopoints.point(k).is_visible;
                            end
                            assert(isnumeric(vis(id)));
                        else
                            vis(id) = 1;
                        end
                    end
                end
            end
            % normalization
            if anno.img_train(i) == 1
                x1 = int64(anno.annolist(i).annorect(j).x1);
                y1 = int64(anno.annolist(i).annorect(j).y1);
                x2 = int64(anno.annolist(i).annorect(j).x2);
                y2 = int64(anno.annolist(i).annorect(j).y2);
                diff = double([y2-y1,x2-x1]);
                normalize = norm(diff) * 0.6;
            else
                normalize = -1;
            end
            % torsoangle
            pt1 = coords(7,:);
            pt2 = coords(8,:);
            if ~(pt1(1) == 0 && pt2(1) == 0)
                torsoangle = atan2(pt2(2)-pt1(2), pt2(1)-pt1(1)) * 180 / pi;
            else
                torsoangle = 0;
            end
            % save to a
            clear a;
            a.index = i;
            a.person = j;
            a.imgname = anno.annolist(i).image.name;
            a.center = center;
            a.scale = scale;
            a.part = coords;
            a.visible = vis;
            a.normalize = normalize;
            a.torsoangle = torsoangle;
            % save to anno
            if anno.img_train(i) == 1
                annot_tr = [annot_tr; a];
            else
                annot_ts = [annot_ts; a];
            end
        end
    end
    % save to file
    if ~exist(annot_tr_file,'file')
        save(annot_tr_file,'annot_tr');
    end
    if ~exist(annot_ts_file,'file')
        save(annot_ts_file,'annot_ts');
    end
    fprintf('done.\n');
end
