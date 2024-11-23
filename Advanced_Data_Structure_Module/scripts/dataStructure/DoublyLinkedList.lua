local module = {
    head = {
        data = nil,
        next = nil,
        prev = nil
    },
    tail = {
        data = nil,
        next = nil,
        prev = nil
    }
}

---@param instance table
---@param cb function
local function traverseFromHead(instance, cb)
    local currNode = instance.head
    local index = 1

    while currNode ~= nil do
        cb(currNode, index)
        index = index + 1
        currNode = currNode.next
    end
end

---@param instance table
---@param cb function
local function traverseFromTail(instance, cb)
    local currNode = instance.tail

    while currNode ~= nil do
        cb(currNode)
        currNode = currNode.prev
    end
end

---@param cb function
---@param fromTail? boolean
function module:forEach(cb, fromTail)
    if fromTail then
        traverseFromTail(self, cb)
    else
        traverseFromHead(self, cb)
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
    local newHead = {
        data = data,
        next = self.head,
        prev = nil
    }
    self.head.prev = newHead
    self.head = newHead

    return true
end

---@param data any
---@return boolean
function module:insertToTail(data)
    local newTail = {
        data = data,
        prev = self.tail,
        next = nil
    }
    self.tail.next = newTail
    self.tail = newTail

    return true
end

---@param index number
---@param data any
---@return boolean
function module:insertByIndex(index, data)
    if index == 1 then
        return self:insertToHead(data)
    end

    local newNode = {
        data = data,
        next = nil,
        prev = nil
    }

    local currNode = self.head
    local count = 1

    while currNode ~= nil do
        if count == index then
            newNode.next = currNode
            newNode.prev = currNode.prev
            currNode.prev.next = newNode
            return true
        end

        count = count + 1
        currNode = currNode.next
    end

    return false
end

---@param index number
---@param data any
---@return boolean
function module:updateByIndex(index, data)
    local currNode = self.head
    local count = 1

    while currNode ~= nil do
        if count == index then
            currNode.data = data
            return true
        end

        count = count + 1
        currNode = currNode.next
    end

    return false
end

---@param value any
---@param data any
---@return boolean
function module:updateManyByValue(value, data)
    local currNode = self.head

    while currNode ~= nil do
        if currNode.data == value then
            currNode.data = data
        end

        currNode = currNode.next
    end

    return true
end

---@return boolean
function module:removeHead()
    if self.head.next ~= nil then
        self.head.next.prev = nil
        self.head = self.head.next
        return true
    end

    return false
end

---@return boolean
function module:removeTail()
    if self.tail.prev ~= nil then
        self.tail.prev.next = nil
        self.tail = self.tail.prev
        return true
    end

    return false
end

---@param index number
---@return boolean
function module:removeByIndex(index)
    if index == 1 then
        return self:removeHead()
    end

    local count = 1
    local currNode = self.head

    while currNode ~= nil do
        if count == index then
            if currNode.prev ~= nil then
                currNode.prev.next = currNode.next
            end
            if currNode.next ~= nil then
                currNode.next.prev = currNode.prev
            end
            return true
        end

        count = count + 1
        currNode = currNode.next
    end

    return false
end

---@param value any
---@return boolean
function module:removeManyByValue(value)
    local currNode = self.head

    while currNode ~= nil do
        if currNode.data == value then
            if currNode.prev ~= nil then
                currNode.prev.next = currNode.next
            end
            if currNode.next ~= nil then
                currNode.next.prev = currNode.prev
            end
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
    instance.tail = instance.head

    return instance
end

return module
