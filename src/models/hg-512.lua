paths.dofile('layers/Residual.lua')

local function hourglass(n, f, inp)
    -- Upper branch
    local up1 = Residual(f,f)(inp)

    -- Lower branch
    local low1 = nnlib.SpatialMaxPooling(2,2,2,2)(inp)
    local low2 = Residual(f,f)(low1)
    local low3

    if n > 1 then low3 = hourglass(n-1,f,low2)
    else
        low3 = Residual(f,f)(low2)
    end

    local low4 = Residual(f,f)(low3)
    local up2 = nn.SpatialUpSamplingNearest(2)(low4)

    -- Bring two branches together
    return nn.CAddTable()({up1,up2})
end

local function lin(numIn,numOut,inp)
    -- Apply 1x1 convolution, stride 1, no padding
    local l = nnlib.SpatialConvolution(numIn,numOut,1,1,1,1,0,0)(inp)
    return nnlib.ReLU(true)(nn.SpatialBatchNormalization(numOut)(l))
end

function createModel()

    local inp = nn.Identity()()

    -- Initial processing of the image
    local cnv1_ = nnlib.SpatialConvolution(3,64,7,7,2,2,3,3)(inp)           -- 128
    local cnv1 = nnlib.ReLU(true)(nn.SpatialBatchNormalization(64)(cnv1_))
    local r1 = Residual(64,128)(cnv1)
    local pool = nnlib.SpatialMaxPooling(2,2,2,2)(r1)                       -- 64
    local r4 = Residual(128,128)(pool)
    local r5 = Residual(128,512)(r4)

    local hg = hourglass(4,512,r5)

    -- Linear layer to produce first set of predictions
    local ll = lin(512,512,hg)

    -- Predicted heatmaps
    local out = nnlib.SpatialConvolution(512,outputDim[1],1,1,1,1,0,0)(ll)

    -- Final model
    local model = nn.gModule({inp}, {out})

    return model

end

function createFTModel(model)
    -- Fine-tuning: replace the last layer if output dim is different
    local dim_pre = model.modules[#model.modules].nOutputPlane
    local dim_new = outputDim[1]
    if dim_pre ~= dim_new then
        print('==> Output size mismatch: ' .. dim_pre .. ' (pre) vs. ' .. dim_new .. ' (new)')
        print('==> Replacing the last layer')
        local out = nnlib.SpatialConvolution(512,dim_new,1,1,1,1,0,0)
        model.forwardnodes[#model.forwardnodes-1].data.module = out
        model.modules[#model.modules] = out
    end

    return model
end

