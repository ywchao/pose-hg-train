
% check equivalent

h5_ts = './data/mpii/annot/test.h5';

load('./data/mpii/annot/test.mat');

index = hdf5read(h5_ts,'index');
person = hdf5read(h5_ts,'person');
imgname = hdf5read(h5_ts,'imgname');
imgname_t = cell(numel(imgname),1);
for i = 1:numel(imgname)
    imgname_t{i} = imgname(i).Data;
end
imgname = imgname_t;
center = hdf5read(h5_ts,'center');
scale = hdf5read(h5_ts,'scale');
part = hdf5read(h5_ts,'part');
visible = hdf5read(h5_ts,'visible');
normalize = hdf5read(h5_ts,'normalize');
torsoangle = hdf5read(h5_ts,'torsoangle');

assert(all([annot_ts.index]' == double(index+1)));
assert(all([annot_ts.person]' == double(person+1)));
assert(all(cellfun(@(x,y)strcmp(x,y)==1,{annot_ts.imgname}',imgname)));
assert(all([annot_ts.center]' == center(:)));
assert(all([annot_ts.scale]' == scale));
pt = cat(3,annot_ts.part);
assert(all(pt(:) == part(:)));
vs = [annot_ts.visible];
assert(all(vs(:) == visible(:)));
assert(all([annot_ts.normalize]' == double(normalize)));
assert(all([annot_ts.torsoangle]' == double(torsoangle)));

fprintf('done.\n');