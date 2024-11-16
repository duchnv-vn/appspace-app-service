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
    local index = 0
    while currNode ~= nil do
        index = index + 1
        cb(currNode, index)
        currNode = currNode.next
    end
end

---@param data any
function module:insertToHead(data)
    self.head = {
        data = data,
        next = self.head
    }
end

---@param data any
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
end

---@param index number
---@param data any
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
            break
        end

        currNode = currNode.next
    end
end

---@param index number
---@param data any
function module:updateByIndex(index, data)
    local currNode = self.head
    local count = 0
    while currNode ~= nil do
        count = count + 1

        if count == index then
            currNode.data = data
            break
        end

        currNode = currNode.next
    end
end

---@param index number
function module:deleteByIndex(index)
    local currNode = self.head
    local count = 0
    while currNode.next ~= nil do
        count = count + 1

        if (count + 1) == index then
            currNode.next = currNode.next.next
            break
        end

        currNode = currNode.next
    end
end

---@param data any
function module:deleteByValue(data)
    local currNode = self.head

    while currNode.next ~= nil do
        if currNode.next.data == data then
            currNode.next = currNode.next.next
            break
        end

        currNode = currNode.next
    end
end

function module:deleteFirst()
    if self.head.next then
        self.head = self.head.next
    end
end

function module:deleteLast()
    local currNode = self.head
    while currNode.next.next ~= nil do
        currNode = currNode.next
    end
    currNode.next = nil
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
