--- Load up network model or initialize from scratch
paths.dofile('models/' .. opt.netType .. '.lua')

-- Continuing an experiment where it left off
if opt.continue or opt.branch ~= 'none' then
    local prevModel = opt.load .. '/final_model.t7'
    print('==> Loading model from: ' .. prevModel)
    model = torch.load(prevModel)

-- Or a path to previously trained model is provided
elseif opt.loadModel ~= 'none' then
    model_path = projectDir .. '/' .. opt.loadModel
    assert(paths.filep(model_path), 'File not found: ' .. model_path)
    print('==> Loading model from: ' .. model_path)
    model = torch.load(model_path)

    -- Replace the last layer if size mismatch
    if createFTModel then model = createFTModel(model) end

-- Or we're starting fresh
else
    print('==> Creating model from file: models/' .. opt.netType .. '.lua')
    model = createModel(modelArgs)
end

-- Criterion (can be set in the opt.task file as well)
if not criterion then
    criterion = nn[opt.crit .. 'Criterion']()
end

if opt.GPU ~= -1 then
    -- Convert model to CUDA
    print('==> Converting model to CUDA')
    model:cuda()
    criterion:cuda()
    
    cudnn.fastest = true
    cudnn.benchmark = true
end
