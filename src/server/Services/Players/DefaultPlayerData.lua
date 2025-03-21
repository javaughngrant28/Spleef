
export type DataTemplate = {
	Keybinds: {
		[string]: {
			PC: string,
			Xbox: string,
		}
	},
}

export type DataInstance = {
	InMacth: boolean,
	Keybinds: {
		[string]: {
			PC: string,
			Xbox: string,
		}
	},
}

local DefaultPlayerData = {}

DefaultPlayerData.Instances = {
    FinishedLoading = false,
	InMacth = false,
	Keybinds = {},
}

DefaultPlayerData.Template = {
	Keybinds = {
		Attack = {
			PC = 'M1',
			Xbox = 'B Button'
		},
	},
}

function DefaultPlayerData.GetInstanceDataSyncedWithSavedData(dataStoreData: DataTemplate): DataInstance
	local dataInstance = DefaultPlayerData.Instances

	for index, value in pairs(dataStoreData) do
		if dataInstance[index] then
			dataInstance[index] = value
		end
	end

	return dataInstance
end

return DefaultPlayerData