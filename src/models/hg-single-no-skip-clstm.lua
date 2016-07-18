paths.dofile('layers/Residual.lua')

local function hourglassNoSkip(n, numIn, numOut, inp)
    -- Upper branch
    -- local up1 = Residual(numIn,256)(inp)
    -- local up2 = Residual(256,256)(up1)
    -- local up4 = Residual(256,numOut)(up2)

    -- Lower branch
    local pool = nnlib.SpatialMaxPooling(2,2,2,2)(inp)
    local low1 = Residual(numIn,256)(pool)
    local low2 = Residual(256,256)(low1)
    local low5 = Residual(256,256)(low2)
    local low6
    if n > 1 then
        low6 = hourglassNoSkip(n-1,256,numOut,low5)
    else
        -- Merge into one mini-batch
        local x1_ = nn.Transpose({2,3},{3,4})(low5)
        local x1 = nn.View(-1,256)(x1_)
        
        -- LSTM
        local x2 = nn.View(-1,1,256)(x1)
        local hiddenSize = 256
        local numLayers = 1
        local hid = cudnn.LSTM(256,hiddenSize,numLayers,true,0)(x2)
        local h1 = nn.View(-1,hiddenSize)(hid)

        -- Split from one mini-batch
        local h2_ = nn.View(-1,4,4,256)(h1)
        local h2 = nn.Transpose({3,4},{2,3})(h2_)

        low6 = Residual(256,numOut)(h2)
    end
    local low7 = Residual(numOut,numOut)(low6)
    return nn.SpatialUpSamplingNearest(2)(low7)
    -- local up5 = nn.SpatialUpSamplingNearest(2)(low7)

    -- Bring two branches together
    -- return nn.CAddTable()({up4,up5})
end

local function lin(numIn,numOut,inp)
    -- Apply 1x1 convolution, no stride, no padding
    local l_ = nnlib.SpatialConvolution(numIn,numOut,1,1,1,1,0,0)(inp)
    return nnlib.ReLU(true)(nn.SpatialBatchNormalization(numOut)(l_))
end

function createModel()

    local inp = nn.Identity()()

    -- Initial processing of the image
    local cnv1_ = nnlib.SpatialConvolution(3,64,7,7,2,2,3,3)(inp)           -- 128
    local cnv1 = nnlib.ReLU(true)(nn.SpatialBatchNormalization(64)(cnv1_))
    local r1 = Residual(64,128)(cnv1)
    local pool = nnlib.SpatialMaxPooling(2,2,2,2)(r1)                       -- 64
    local r4 = Residual(128,128)(pool)
    local r5 = Residual(128,128)(r4)
    local r6 = Residual(128,256)(r5)

    -- First hourglass
    local hg1 = hourglassNoSkip(4,256,512,r6)

    -- Linear layers to produce first set of predictions
    local l1 = lin(512,512,hg1)
    local l2 = lin(512,512,l1)

    -- Output heatmaps
    local out = nnlib.SpatialConvolution(512,outputDim[1],1,1,1,1,0,0)(l2)

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
