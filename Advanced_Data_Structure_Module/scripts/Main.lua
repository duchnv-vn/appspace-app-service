local SinglyLinkedList = require('dataStructure.SinglyLinkedList')
local DoublyLinkedList = require("dataStructure.DoublyLinkedList")

local function testSinglyLinkedList()
    local list = SinglyLinkedList.new(5)

    -- Test inserting to head
    assert(list:insertToHead(10) == true, 'Test inserting to head failed')
    assert(list.head.data == 10, 'Test inserting to head failed')

    -- Test inserting to last
    assert(list:insertToLast(20) == true, 'Test inserting to last failed')
    assert(list.head.next.data == 5, 'Test inserting to last failed')

    -- Test inserting by index
    assert(list:insertByIndex(2, 15) == true, 'Test inserting by index failed')
    assert(list:searchByIndex(2).data == 15, 'Test inserting by index failed')

    -- Test updating by index
    assert(list:updateByIndex(2, 25) == true, 'Test updating by index failed')
    assert(list:searchByIndex(2).data == 25, 'Test updating by index failed')

    -- Test removing by index
    assert(list:removeByIndex(2) == true, 'Test removing by index failed')
    assert(list:searchByIndex(2).data == 5, 'Test removing by index failed')

    -- Test removing first
    assert(list:removeFirst() == true, 'Test removing first failed')
    assert(list.head.data == 5, 'Test removing first failed')

    -- Test removing last
    assert(list:removeLast() == true, 'Test removing last failed')
    assert(list.head.next == nil, 'Test removing last failed')

    print("All singly linked list tests passed!")
end

local function testDoublyLinkedList()
    local list = DoublyLinkedList.new(10)

    -- Test insert to head
    assert(list:insertToHead(5) == true, 'Test insert to head failed')
    assert(list.head.data == 5, 'Test insert to head failed')

    -- Test insert to tail
    assert(list:insertToTail(20) == true, 'Test insert to tail failed')
    assert(list.tail.data == 20, 'Test insert to tail failed')

    -- Test insert by index
    assert(list:insertByIndex(2, 15) == true, 'st insert by index failed')
    assert(list:searchByIndex(2).data == 15, 'st insert by index failed')

    -- Test update by index
    assert(list:updateByIndex(2, 25) == true, 'Test update by index failed')
    assert(list:searchByIndex(2).data == 25, 'Test update by index failed')

    -- Test remove head
    assert(list:removeHead() == true, 'Test remove head failed')
    assert(list.head.data == 25, 'Test remove head failed')

    -- Test remove tail
    assert(list:removeTail() == true, 'Test remove tail failed')
    assert(list.tail.data == 10, 'Test remove tail failed')

    -- Test remove by index
    list:insertToTail(30)
    assert(list:removeByIndex(2) == true, 'Test remove by index failed')
    assert(list.tail.data == 30, 'Test remove by index failed')

    -- Test remove many by value
    list:insertToTail(30)
    assert(list:removeManyByValue(30) == true, 'Test remove many by value failed')
    assert(list.tail.data ~= 25, 'Test remove many by value failed')

    print("All doubly linked list tests passed!")
end

local function main()
    testSinglyLinkedList()
    testDoublyLinkedList()
end
Script.register("Engine.OnStarted", main)
