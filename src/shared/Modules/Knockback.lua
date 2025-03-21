


local Knockback = {}

function Knockback.ServerSided(targetModel: Model, diraction: Vector3, distance: number, targetPlayer: Player?, duration: number?)
    task.spawn(function()
        local duration = duration or 0.4

        local rootPart = targetModel:FindFirstChild('HumanoidRootPart') :: Part
        rootPart:SetNetworkOwner(nil)
        local humanoid = targetModel:FindFirstChild('Humanoid') :: Humanoid
        
        local force = (diraction * distance) / duration +  Vector3.new(0,workspace.Gravity * duration * 0.5,0)
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        rootPart:ApplyImpulse(force * rootPart.AssemblyMass)
    
        if targetPlayer then
            task.wait(duration)
            rootPart:SetNetworkOwner(targetPlayer)
        end
    end)
end

return Knockback
