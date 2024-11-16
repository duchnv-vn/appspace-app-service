---@diagnostic disable: need-check-nil, param-type-mismatch
local CalendarHandler = require('Calendar')

--- Test for addByUnit function
local function testAddByUnit()
    local datetimeObj = CalendarHandler.new(2023, 12, 31, 23, 59, 59, 999)

    -- Test adding seconds that rollover to the next minute
    datetimeObj:addByUnit(1, 'second')
    assert(datetimeObj.second == 0 and datetimeObj.minute == 0 and datetimeObj.hour == 0 and datetimeObj.date == 1 and
               datetimeObj.month == 1 and datetimeObj.year == 2024, 'Failed: Adding seconds rollover')

    -- Test adding days that roll over to the next month
    datetimeObj = datetimeObj.new(2023, 1, 30, 0, 0, 0, 0)
    datetimeObj:addByUnit(2, 'date')
    assert(datetimeObj.date == 1 and datetimeObj.month == 2 and datetimeObj.year == 2023, 'Failed: Adding days rollover')

    -- Test adding months that rollover to the next year
    datetimeObj = datetimeObj.new(2023, 11, 1, 0, 0, 0, 0)
    datetimeObj:addByUnit(2, 'month')
    assert(datetimeObj.month == 1 and datetimeObj.year == 2024, 'Failed: Adding months rollover')

    print('All addByUnit tests passed!')
end

--- Test for subtractByUnit function
local function testSubtractByUnit()
    local datetimeObj = CalendarHandler.new(2024, 1, 1, 0, 0, 0, 0)

    -- Test subtracting seconds that rollover to the previous minute
    datetimeObj:subtractByUnit(1, 'second')
    assert(
        datetimeObj.second == 59 and datetimeObj.minute == 59 and datetimeObj.hour == 23 and datetimeObj.date == 31 and
            datetimeObj.month == 12 and datetimeObj.year == 2023, 'Failed: Subtracting seconds rollover')

    -- Test subtracting days that roll over to the previous month
    datetimeObj = CalendarHandler.new(2023, 3, 1, 0, 0, 0, 0)
    datetimeObj:subtractByUnit(1, 'date')
    assert(datetimeObj.date == 28 and datetimeObj.month == 2 and datetimeObj.year == 2023,
        'Failed: Subtracting days rollover')

    -- Test subtracting months that roll over to the previous year
    datetimeObj = CalendarHandler.new(2023, 1, 15, 0, 0, 0, 0)
    datetimeObj:subtractByUnit(2, 'month')
    assert(datetimeObj.month == 11 and datetimeObj.year == 2022, 'Failed: Subtracting months rollover')

    print('All subtractByUnit tests passed!')
end

--- Test for calcDifference function
local function testCalcDifference()
    local datetime1 = CalendarHandler.new(2024, 1, 1, 0, 0, 0, 0)
    local datetime2 = CalendarHandler.new(2023, 12, 31, 0, 0, 0, 0)

    local difference = CalendarHandler.calcDifference(datetime1, datetime2)
    assert(difference.daysDiff == 1, 'Failed: Difference calculation between dates')

    print('All calcDifference tests passed!')
end

--- Test for leap year detection
local function testLeapYear()
    local datetimeObj = CalendarHandler.new(2024, 1, 1, 0, 0, 0, 0)
    assert(datetimeObj.isLeapYear, 'Failed: 2024 should be a leap year')

    datetimeObj = CalendarHandler.new(2023, 1, 1, 0, 0, 0, 0)
    assert(not datetimeObj.isLeapYear, 'Failed: 2023 should not be a leap year')

    print('All leap year tests passed!')
end

--- Test for getTimestamp function
local function testGetTimestamp()
    local datetimeObj = CalendarHandler.new(1970, 1, 1, 0, 0, 0, 0)
    assert(datetimeObj:getTimestamp() == 0, 'Failed: Unix epoch timestamp')

    datetimeObj = CalendarHandler.new(2024, 1, 1, 0, 0, 0, 0)
    assert(datetimeObj:getTimestamp() > 0, 'Failed: Positive timestamp for 2024')

    print('All getTimestamp tests passed!')
end

--- Test for getDayInWeek function
local function testGetDayInWeek()
    local datetimeObj = CalendarHandler.new(2024, 1, 1, 0, 0, 0, 0)
    assert(datetimeObj:getDayInWeek() == 1, 'Failed: 2024-01-01 should be Monday')

    datetimeObj = CalendarHandler.new(2023, 12, 31, 0, 0, 0, 0)
    assert(datetimeObj:getDayInWeek() == 0, 'Failed: 2023-12-31 should be Sunday')

    print('All getDayInWeek tests passed!')
end

--- Test for getDayOfYear function
local function testGetDayOfYear()
    local datetimeObj = CalendarHandler.new(2024, 1, 1, 0, 0, 0, 0)
    assert(datetimeObj:getDayOfYear() == 1, 'Failed: 2024-01-01 should be the 1st day of the year')

    datetimeObj = CalendarHandler.new(2024, 12, 31, 0, 0, 0, 0)
    assert(datetimeObj:getDayOfYear() == 366, 'Failed: 2024-12-31 should be the 366th day of the year')

    print('All getDayOfYear tests passed!')
end

--- Test for toISOString function
local function testToISOString()
    local datetimeObj = CalendarHandler.new(2024, 1, 1, 12, 0, 0, 0)
    assert(datetimeObj:toISOString() == '2024-01-01T12:00:00.000Z', 'Failed: ISO string format')

    datetimeObj = CalendarHandler.new(2023, 12, 31, 23, 59, 59, 999)
    assert(datetimeObj:toISOString() == '2023-12-31T23:59:59.999Z', 'Failed: ISO string format with milliseconds')

    print('All toISOString tests passed!')
end

local function main()
    --- Start execute testing
    testAddByUnit()
    testSubtractByUnit()
    testCalcDifference()
    testLeapYear()
    testGetTimestamp()
    testGetDayInWeek()
    testGetDayOfYear()
    testToISOString()
    --- End execute testing
end
Script.register('Engine.OnStarted', main)
