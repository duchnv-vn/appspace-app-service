local module = {
    year = nil,
    month = nil,
    date = nil,
    hour = nil,
    minute = nil,
    second = nil,
    millisecond = nil,
    dayInWeek = nil,
    dayOfYear = nil,
    timestamp = nil,
    isLeapYear = false,
    daysInMonths = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
}

-- ********************** START CLASS FUNCTIONS **********************

--- Calculate difference between two datetime objects
---@param date1 table
---@param date2 table
function module.calcDifference(date1, date2)
    local yearsDiff, monthsDiff, daysDiff = 0, 0, 0
    local hoursDiff, minutesDiff, secondsDiff, miliSecondsDiff = 0, 0, 0, 0

    local timestamp = date1:getTimestamp() - date2:getTimestamp()
    local isPrevious = timestamp < 0
    timestamp = math.abs(timestamp)

    local baseYear = isPrevious and date1.year or date2.year
    local dayTimestamp = 24 * 60 * 60 * 1000
    while timestamp >= 365 * dayTimestamp do
        local currentYearDays = module.isLeapYear(baseYear + yearsDiff) and 366 or 365
        local yearTimestamp = currentYearDays * dayTimestamp
        if timestamp >= yearTimestamp then
            timestamp = timestamp - yearTimestamp
            yearsDiff = yearsDiff + 1
        else
            break
        end
    end

    local baseMonth = isPrevious and date1.month or date2.month
    while timestamp >= 28 * dayTimestamp do
        local currMonth = baseMonth + monthsDiff
        if currMonth > 12 then
            currMonth = currMonth - 12
        end

        local currentMonthDays = module.getDaysInMonth(baseYear + yearsDiff, currMonth)
        local monthTimestamp = currentMonthDays * dayTimestamp
        if timestamp >= monthTimestamp then
            timestamp = timestamp - monthTimestamp
            monthsDiff = monthsDiff + 1
            if monthsDiff > 12 then
                monthsDiff = monthsDiff - 12
                yearsDiff = yearsDiff + 1
            end
        else
            break
        end
    end

    while timestamp >= dayTimestamp do
        timestamp = timestamp - dayTimestamp
        daysDiff = daysDiff + 1
    end

    local hourTimestamp = 60 * 60 * 1000
    while timestamp >= hourTimestamp do
        timestamp = timestamp - hourTimestamp
        hoursDiff = hoursDiff + 1
    end

    local minuteTimestamp = 60 * 1000
    while timestamp >= hourTimestamp do
        timestamp = timestamp - minuteTimestamp
        minutesDiff = minutesDiff + 1
    end

    while timestamp >= 1000 do
        timestamp = timestamp - 1000
        secondsDiff = secondsDiff + 1
    end

    miliSecondsDiff = timestamp

    return {
        yearsDiff = yearsDiff,
        monthsDiff = monthsDiff,
        daysDiff = daysDiff,
        hoursDiff = hoursDiff,
        minutesDiff = minutesDiff,
        secondsDiff = secondsDiff,
        miliSecondsDiff = miliSecondsDiff,
        isPrevious = isPrevious
    }
end

--- Check if year is leap year
function module.isLeapYear(year)
    return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
end

--- Get day number in a month
--- @param year number
--- @param month number
function module.getDaysInMonth(year, month)
    if month == 2 and module.isLeapYear(year) then
        return 29
    end
    return module.daysInMonths[month]
end

-- ********************** END CLASS FUNCTIONS **********************

-- ********************** START INSTANCE FUNCTIONS **********************

--- Add time value to datetime object by unit
---@param value number
---@param unit 'year' | 'month' | 'date' | 'hour' | 'minute' | 'second' | 'millisecond'
function module:addByUnit(value, unit)
    if unit == 'year' then
        self.year = self.year + value
    end

    if unit == 'month' then
        local newMonth = self.month + value
        if newMonth > 12 then
            while newMonth > 12 do
                newMonth = newMonth - 12
                self.year = self.year + 1
            end
        end
        self.month = newMonth
    end

    if unit == 'date' then
        local newDate = self.date + value
        if newDate > self.daysInMonths[self.month] then
            while newDate > self.daysInMonths[self.month] do
                newDate = newDate - self.daysInMonths[self.month]
                self.month = self.month + 1
                if self.month > 12 then
                    self.month = 1
                    self.year = self.year + 1
                end
            end
        end
        self.date = newDate
    end

    if unit == 'hour' then
        local newHour = self.hour + value
        if newHour > 23 then
            while newHour > 23 do
                newHour = newHour - 24
                self.date = self.date + 1
                if self.date > self.daysInMonths[self.month] then
                    self.date = 1
                    self.month = self.month + 1
                    if self.month > 12 then
                        self.month = 1
                        self.year = self.year + 1
                    end
                end
            end
        end
        self.hour = newHour
    end

    if unit == 'minute' then
        local newMinute = self.minute + value
        if newMinute > 59 then
            while newMinute > 59 do
                newMinute = newMinute - 60
                self.hour = self.hour + 1
                if self.hour > 23 then
                    self.hour = 0
                    self.date = self.date + 1
                    if self.date > self.daysInMonths[self.month] then
                        self.date = 1
                        self.month = self.month + 1
                        if self.month > 12 then
                            self.month = 1
                            self.year = self.year + 1
                        end
                    end
                end
            end
        end
        self.minute = newMinute
    end

    if unit == 'second' then
        local newSecond = self.second + value
        if newSecond > 59 then
            while newSecond > 59 do
                newSecond = newSecond - 60
                self.minute = self.minute + 1
                if self.minute > 59 then
                    self.minute = 0
                    self.hour = self.hour + 1
                    if self.hour > 23 then
                        self.hour = 0
                        self.date = self.date + 1
                        if self.date > self.daysInMonths[self.month] then
                            self.date = 1
                            self.month = self.month + 1
                            if self.month > 12 then
                                self.month = 1
                                self.year = self.year + 1
                            end
                        end
                    end
                end
            end
        end
        self.second = newSecond
    end

    if unit == 'millisecond' then
        local newMillisecond = self.millisecond + value
        if newMillisecond > 999 then
            while newMillisecond > 999 do
                newMillisecond = newMillisecond - 1000
                self.second = self.second + 1
                if self.second > 59 then
                    self.second = 0
                    self.minute = self.minute + 1
                    if self.minute > 59 then
                        self.minute = 0
                        self.hour = self.hour + 1
                        if self.hour > 23 then
                            self.hour = 0
                            self.date = self.date + 1
                            if self.date > self.daysInMonths[self.month] then
                                self.date = 1
                                self.month = self.month + 1
                                if self.month > 12 then
                                    self.month = 1
                                    self.year = self.year + 1
                                end
                            end
                        end
                    end
                end
            end
        end
        self.millisecond = newMillisecond
    end

    self:checkLeapYear()
    self:getTimestamp(true)
    return self
end

--- Subtract datetime object by time value and unit
---@param value number
---@param unit 'year' | 'month' | 'date' | 'hour' | 'minute' | 'second' | 'millisecond'
function module:subtractByUnit(value, unit)
    if unit == 'year' then
        self.year = self.year - value
    end

    if unit == 'month' then
        local newMonth = self.month - value
        if newMonth < 1 then
            while newMonth < 1 do
                newMonth = newMonth + 12
                self.year = self.year - 1
            end
        end
        self.month = newMonth
    end

    if unit == 'date' then
        local newDate = self.date - value
        if newDate < 1 then
            while newDate < 1 do
                self.month = self.month - 1
                newDate = newDate + self.daysInMonths[self.month]
                if self.month < 1 then
                    self.month = 12
                    self.year = self.year - 1
                end
            end
        end
        self.date = newDate
    end

    if unit == 'hour' then
        local newHour = self.hour - value
        if newHour < 0 then
            while newHour < 0 do
                newHour = newHour + 24
                self.date = self.date - 1
                if self.date < 1 then
                    self.month = self.month - 1
                    if self.month < 1 then
                        self.month = 12
                        self.year = self.year - 1
                    end
                    self.date = self.daysInMonths[self.month]
                end
            end
        end
        self.hour = newHour
    end

    if unit == 'minute' then
        local newMinute = self.minute - value
        if newMinute < 0 then
            while newMinute < 0 do
                newMinute = newMinute + 60
                self.hour = self.hour - 1
                if self.hour < 0 then
                    self.date = self.date - 1
                    if self.date < 1 then
                        self.month = self.month - 1
                        if self.month < 1 then
                            self.month = 12
                            self.year = self.year - 1
                        end
                        self.date = self.daysInMonths[self.month]
                    end
                    self.hour = 23
                end
            end
        end
        self.minute = newMinute
    end

    if unit == 'second' then
        local newSecond = self.second - value
        if newSecond < 0 then
            while newSecond < 0 do
                newSecond = newSecond + 60
                self.minute = self.minute - 1
                if self.minute < 0 then
                    self.hour = self.hour - 1
                    if self.hour < 0 then
                        self.date = self.date - 1
                        if self.date < 1 then
                            self.month = self.month - 1
                            if self.month < 1 then
                                self.month = 12
                                self.year = self.year - 1
                            end
                            self.date = self.daysInMonths[self.month]
                        end
                        self.hour = 23
                    end
                    self.minute = 59
                end
            end
        end
        self.second = newSecond
    end

    if unit == 'millisecond' then
        local newMillisecond = self.millisecond - value
        if newMillisecond < 0 then
            while newMillisecond < 0 do
                newMillisecond = newMillisecond + 1000
                self.second = self.second - 1
                if self.second < 0 then
                    self.minute = self.minute - 1
                    if self.minute < 0 then
                        self.hour = self.hour - 1
                        if self.hour < 0 then
                            self.date = self.date - 1
                            if self.date < 1 then
                                self.month = self.month - 1
                                if self.month < 1 then
                                    self.month = 12
                                    self.year = self.year - 1
                                end
                                self.date = self.daysInMonths[self.month]
                            end
                            self.hour = 23
                        end
                        self.minute = 59
                    end
                    self.second = 59
                end
            end
        end
        self.millisecond = newMillisecond
    end

    self:checkLeapYear()
    self:getTimestamp(true)
    return self
end

--- Check if year is leap year
function module:checkLeapYear()
    self.isLeapYear = module.isLeapYear(self.year)
    if self.isLeapYear then
        self.daysInMonths[2] = 29
    else
        self.daysInMonths[2] = 28
    end
end

--- Get timestamp in milliseconds
--- @param forceCreate? boolean
function module:getTimestamp(forceCreate)
    if forceCreate or not self.timestamp then
        local timestamp

        if self.year < 1970 then
            timestamp = 0
        else
            local days = 0
            for i = 1970, self.year - 1 do
                local isLeapYear = i % 4 == 0 and (i % 100 ~= 0 or i % 400 == 0)
                if isLeapYear then
                    days = days + 366
                else
                    days = days + 365
                end
            end

            for i = 1, self.month - 1 do
                days = days + self.daysInMonths[i]
            end
            days = days + self.date - 1

            local hours = self.hour
            local minutes = self.minute
            local seconds = self.second
            local milliseconds = self.millisecond

            timestamp = days * 24 * 60 * 60 * 1000 + hours * 60 * 60 * 1000 + minutes * 60 * 1000 + seconds * 1000 +
                            milliseconds
        end

        self.timestamp = timestamp
    end

    return self.timestamp
end

--- Get day in week (0 - Sunday, 1 - Monday, ..., 6 - Saturday)
function module:getDayInWeek()
    if not self.dayInWeek then
        local dateInWeek

        if self.year < 1970 then
            dateInWeek = 0
        else
            local days = 0
            for i = 1970, self.year - 1 do
                local isLeapYear = i % 4 == 0 and (i % 100 ~= 0 or i % 400 == 0)
                if isLeapYear then
                    days = days + 366
                else
                    days = days + 365
                end
            end

            for i = 1, self.month - 1 do
                days = days + self.daysInMonths[i]
            end
            days = days + self.date - 1

            dateInWeek = (days + 4) % 7
        end

        self.dayInWeek = dateInWeek
    end

    return self.dayInWeek
end

--- Get day of year (1 - 365/366)
function module:getDayOfYear()
    if not self.dayOfYear then
        local days = 0
        for i = 1, self.month - 1 do
            days = days + self.daysInMonths[i]
        end
        days = days + self.date

        self.dayOfYear = days
    end

    return self.dayOfYear
end

--- Get ISO 8601 string representation of datetime object
function module:toISOString()
    local format = 'YYYY-MM-DDTHH:mm:ss.SSSZ'
    format = format:gsub('YYYY', self.year)
    format = format:gsub('MM', string.format('%02d', self.month))
    format = format:gsub('DD', string.format('%02d', self.date))
    format = format:gsub('HH', string.format('%02d', self.hour))
    format = format:gsub('mm', string.format('%02d', self.minute))
    format = format:gsub('ss', string.format('%02d', self.second))
    format = format:gsub('SSS', string.format('%03d', self.millisecond))

    return format
end

--- Get date string representation of datetime object
--- @param dateFormat string
function module:toDateString(dateFormat)
    local dateString = dateFormat

    dateString = dateString:gsub("YYYY", tostring(self.year))
    dateString = dateString:gsub("YY", tostring(self.year):len() == 4 and string.sub(tostring(self.year), 3, 4) or
        tostring(self.year))
    dateString = dateString:gsub("MM", string.format("%02d", self.month))
    dateString = dateString:gsub("DD", string.format("%02d", self.date))

    return dateString
end

-- ********************** END INSTANCE FUNCTIONS **********************

--- Create new UTC datetime object
--- @param year? number
--- @param month? number
--- @param date? number
--- @param hour? number
--- @param minute? number
--- @param second? number
--- @param millisecond? number
function module.new(year, month, date, hour, minute, second, millisecond)
    if month and (month > 12 or month < 1) then
        return nil
    end
    if hour and (hour > 23 or hour < 0) then
        return nil
    end
    if minute and (minute > 59 or minute < 0) then
        return nil
    end
    if second and (second > 59 or second < 0) then
        return nil
    end
    if millisecond and (millisecond > 999 or millisecond < 0) then
        return nil
    end

    local instance = setmetatable({}, {
        __index = module
    })

    if not year then
        date, month, year, hour, minute, second, millisecond = DateTime.getDateTimeValuesUTC()

        instance.timestamp = DateTime.getUnixTimeMilliseconds()
        instance.dayInWeek = DateTime.calcDayOfWeek(DateTime.getUnixTime())
    end

    if year and not month then
        month = 1
    end

    if year and not date then
        date = 1
    end

    instance.year = year
    instance.month = month
    instance.date = date
    instance.hour = hour or 0
    instance.minute = minute or 0
    instance.second = second or 0
    instance.millisecond = millisecond or 0

    instance:checkLeapYear()
    instance:getTimestamp()

    if instance.date > instance.daysInMonths[instance.month] then
        instance.date = instance.daysInMonths[instance.month]
    end

    return instance
end

return module
