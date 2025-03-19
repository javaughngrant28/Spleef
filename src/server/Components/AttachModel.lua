
export type AttachModel = {
    _Model: Model,
    _Character: Model,

    Type: {[string]: string},

    _Attach: (self: AttachModel,type: string) -> (),

    __RightHand: (self: AttachModel) -> (),
    __Torso: (self: AttachModel) -> (),

    __CreateWild: (self: AttachModel, p1: BasePart, p0: BasePart) -> Motor6D,
}

local AttachModel = {}

AttachModel.Type = {
    Torso = '__Torso',
    RightHand = '__RightHand'
}




local function Attach(type: string, model: Model, character: Model)
    local attachmentFunction = AttachModel[type]
    assert(attachmentFunction)

    model.Parent = character
    attachmentFunction(model,character)
end

local function CreateWild(p1: BasePart?, p0: BasePart?) : Motor6D
    assert(p1 and p0)
    local moter6D = Instance.new('Motor6D')
    moter6D.Part0 = p0
    moter6D.Part1 = p1
    return moter6D
end

function AttachModel.Fire(character: Model, model: Model, attachmentType: string)
    assert(model and model:IsA('Model'), 'Module Property Missing Or Wrong Type')
    assert(model.PrimaryPart, `{model} Model Has No PrimaryPart`)
    assert(attachmentType and typeof(attachmentType) == "string", 'Missing Or Wong Type')
    assert(character,"Character Missing")

    Attach(attachmentType,model,character)
end

function AttachModel.__Torso(model: Model, character: Model)
    local UpperTorso = character:FindFirstChild('UpperTorso') :: BasePart
    assert(UpperTorso,`{character} :UpperTorso Not Found`)

    local weld = CreateWild(model.PrimaryPart,UpperTorso) :: Motor6D
    weld.Parent = model.PrimaryPart
end

function AttachModel.__RightHand(model: Model, character: Model)
    local RightHand = character:FindFirstChild('RightHand') :: BasePart
    assert(RightHand,`{character} :RightHand Not Found`)

    local weld = CreateWild(model.PrimaryPart, RightHand) :: Motor6D
    weld.Parent = model.PrimaryPart
end


return AttachModel