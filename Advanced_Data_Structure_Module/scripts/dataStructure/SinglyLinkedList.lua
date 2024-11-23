---@diagnostic disable: need-check-nil
local module = {
    head = {
        data = nil,
        next = nil
    }
}

---@param cb function
function module:forEach(cb)
    local currNode = self.head
    local index = 1
    while currNode ~= nil do
        index = index + 1
        cb(currNode, index)
        currNode = currNode.next
    end
end

---@param index number
---@return table|nil
function module:searchByIndex(index)
    local currNode = self.head
    local count = 1

    while currNode ~= nil do
        if count == index then
            return currNode
        end

        count = count + 1
        currNode = currNode.next
    end

    return nil
end

---@param data any
---@return boolean
function module:insertToHead(data)
    self.head = {
        data = data,
        next = self.head
    }
    return true
end

---@param data any
---@return boolean
function module:insertToLast(data)
    local currNode = self.head
    while currNode.next ~= nil do
        currNode = currNode.next
    end

    local newLastNode = {
        data = data,
        head = nil
    }
    currNode.next = newLastNode
    return true
end

---@param index number
---@param data any
---@return boolean
function module:insertByIndex(index, data)
    local newNode = {
        data = data,
        next = nil
    }
    local currNode = self.head
    local count = 0
    while currNode.next ~= nil do
        count = count + 1

        if (count + 1) == index then
            newNode.next = currNode.next
            currNode.next = newNode
            return true
        end

        currNode = currNode.next
    end

    return false
end

---@param index number
---@param data any
---@return boolean
function module:updateByIndex(index, data)
    local currNode = self.head
    local count = 0
    while currNode ~= nil do
        count = count + 1

        if count == index then
            currNode.data = data
            return true
        end

        currNode = currNode.next
    end

    return false
end

---@param value any
---@param data any
function module:updateManyByValue(value, data)
end

---@param index number
---@return boolean
function module:removeByIndex(index)
    local currNode = self.head
    local count = 0
    while currNode.next ~= nil do
        count = count + 1

        if (count + 1) == index then
            currNode.next = currNode.next.next
            return true
        end

        currNode = currNode.next
    end

    return false
end

---@return boolean
function module:removeFirst()
    if self.head.next ~= nil then
        self.head = self.head.next
        return true
    end

    return false
end

---@return boolean
function module:removeLast()
    local currNode = self.head
    while currNode.next.next ~= nil do
        currNode = currNode.next
    end
    currNode.next = nil

    return true
end

---@param value any
---@return boolean
function module:removeManyByValue(value)
    local currNode = self.head

    while currNode ~= nil do
        if currNode.next.data == value then
            currNode = currNode.next.next
        end

        currNode = currNode.next
    end

    return true
end

---@param data any
function module.new(data)
    local instance = setmetatable({}, {
        __index = module
    })

    instance.head.data = data
    return instance
end

return module
