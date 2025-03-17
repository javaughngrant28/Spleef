type ItemName = string
type Chance = number

export type RandomChanceInput = { 
    ItemName: Chance
}

--> Variables
local _L = _G._L

--> Constants
local RandomChance

RandomChance = {
    GetResults = function(data: RandomChanceInput, ResultAmount: number): {string}
        assert(typeof(data) == "table", "Input data must be a table with string keys and numeric values.")
        assert(typeof(ResultAmount) == "number" and ResultAmount > 0, "ResultAmount must be a positive number.")

        local results = {}
        local items = {}
        local totalWeight = 0

        for name, weight in pairs(data) do
            assert(typeof(name) == "string", "Keys in the input table must be strings.")
            assert(typeof(weight) == "number" and weight > 0, "All weights must be positive numbers.")
            totalWeight += weight
            table.insert(items, {name = name, cumulativeWeight = totalWeight})
        end

        if #items == 0 then
            warn("Input table contains no valid items with positive weights.")
            return {}
        end

        local function getRandomItem()
            local rand = Random.new():NextNumber(0, totalWeight)
            for _, item in ipairs(items) do
                if rand <= item.cumulativeWeight then
                    return item.name
                end
            end
        end

        while #results < ResultAmount and #results < #items do
            local selected = getRandomItem()
            if not table.find(results, selected) then
                table.insert(results, selected)
            end
        end

        return results
    end,
}

return RandomChance

