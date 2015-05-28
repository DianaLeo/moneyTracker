//
//  BIMonthCalendar.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
class BIMonthCalender:NSObject {
    var calendar: NSCalendar?
    var date: NSDate?
    convenience init(dateForMonthCalender date: NSDate) {
        println("BIMonthCalender Will Init")
        // call designated init first
        self.init()
        // other init job in phase 2
        calendar = NSCalendar.autoupdatingCurrentCalendar()
        self.date = date
    }
    override init() {
        // init property before call super.init()
        date = NSDate()
        // call super.init(),delegate up to super
        super.init()
        println("BIMonthCalender Did Init")
    }
    deinit {
        println("BIMonthCalender Deinit")
    }
    func monthCalender() -> Array<String> {
        // make special date as mark
        var dateComponents = NSDateComponents()
        dateComponents.day = calendar!.component(NSCalendarUnit.CalendarUnitDay, fromDate: date!)
        dateComponents.month = calendar!.component(NSCalendarUnit.CalendarUnitMonth, fromDate: date!)
        dateComponents.year = calendar!.component(NSCalendarUnit.CalendarUnitYear, fromDate: date!)
        dateComponents.hour = calendar!.component(NSCalendarUnit.CalendarUnitHour, fromDate: date!)
        dateComponents.minute = calendar!.component(NSCalendarUnit.CalendarUnitMinute, fromDate: date!)
        dateComponents.second = calendar!.component(NSCalendarUnit.CalendarUnitSecond, fromDate: date!)
        dateComponents.nanosecond = calendar!.component(NSCalendarUnit.CalendarUnitNanosecond, fromDate: date!)
        
        //current date
        let currentDate: NSDate = self.calendar!.dateFromComponents(dateComponents)!
        let weekday = self.calendar!.component(NSCalendarUnit.CalendarUnitWeekday, fromDate: date!)
        //println(weekday)
        //println(currentDate.description)
        
        // date tmps for use
        let dayTemps = dateComponents.day
        let monthTemps = dateComponents.month
        let yearTemps = dateComponents.year
        
        //first day in current month
        dateComponents.day = 1
        let firstDateOfCurrentMonth: NSDate = self.calendar!.dateFromComponents(dateComponents)!
        let weekdayOfFirstDate = self.calendar!.component(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDateOfCurrentMonth)
        dateComponents.day = dayTemps
        dateComponents.month = monthTemps
        dateComponents.year = yearTemps
        //println(weekdayOfFirstDate)
        //println(firstDateOfCurrentMonth.description)
        
        //first day in last month
        dateComponents.day = 1
        if dateComponents.month != 1 {
            dateComponents.month -= 1
        }else {
            dateComponents.month = 1
            dateComponents.year -= 1
        }
        let firstDateOfLastMonth: NSDate = self.calendar!.dateFromComponents(dateComponents)!
        let weekdayOfFirstDateInLastMonth = self.calendar!.component(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDateOfLastMonth)
        dateComponents.day = dayTemps
        dateComponents.month = monthTemps
        dateComponents.year = yearTemps
        //println(weekdayOfFirstDateInLastMonth)
        //println(firstDateOfLastMonth.description)
        
        //first day in next month
        dateComponents.day = 1
        if dateComponents.month != 12 {
            dateComponents.month += 1
        }else{
            dateComponents.month = 1
            dateComponents.year += 1
        }
        let firstDateOfNextMonth: NSDate = self.calendar!.dateFromComponents(dateComponents)!
        let weekdayOfFirstDateInNextMonth = self.calendar!.component(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDateOfNextMonth)
        dateComponents.day = dayTemps
        dateComponents.month = monthTemps
        dateComponents.year = yearTemps
        //println(weekdayOfFirstDateInNextMonth)
        //println(firstDateOfNextMonth.description)
        
        //calculte numOfDays between 2 months
        var differentialCompsFromLastToCurrent:NSDateComponents = self.calendar!.components(NSCalendarUnit.CalendarUnitDay, fromDate: firstDateOfLastMonth, toDate: firstDateOfCurrentMonth, options: NSCalendarOptions.WrapComponents)
        //println("differ days from last to current are =\(differentialCompsFromLastToCurrent.day)")
        var differentialCompsFromCurrentToNext:NSDateComponents = self.calendar!.components(NSCalendarUnit.CalendarUnitDay, fromDate: firstDateOfCurrentMonth, toDate: firstDateOfNextMonth, options: NSCalendarOptions.WrapComponents)
        //println("differ days from current to next are =\(differentialCompsFromCurrentToNext.day)")

        
        //data generate
        var formattedDateTable: Array<String> = []
        let startIndex:Int = weekdayOfFirstDate
        let endIndex:Int = weekdayOfFirstDate + differentialCompsFromCurrentToNext.day - 1
        //println("start at \(startIndex). end at \(endIndex) ")
        if startIndex != 1 {
            var dayOfLastMonth = differentialCompsFromLastToCurrent.day - (weekdayOfFirstDate-1) + 1 // Max Day In last Month - numsOfDaysCanShowInCalendar + 1
            for i in 1...startIndex-1 {
                formattedDateTable.append("\(dayOfLastMonth++)")
            }
            var day = 1
            var weekday = weekdayOfFirstDate
            for i in startIndex...endIndex {
                formattedDateTable.append("\(day)")
                day++
                if weekday == 7 {
                    weekday = 1
                }else {
                    weekday++
                }
            }
            var dayOfNextMonth = 1
            for i in endIndex+1...42 {
                formattedDateTable.append("\(dayOfNextMonth++)")
            }
        }else {
            var day = 1
            var weekday = weekdayOfFirstDate
            for i in startIndex...endIndex {
                formattedDateTable.append("\(day)")
                day++
                if weekday == 7 {
                    weekday = 1
                }else {
                    weekday++
                }
            }
            var dayOfNextMonth = 1
            for i in endIndex+1...42 {
                formattedDateTable.append("\(dayOfNextMonth++)")
            }
        }
        //println(formattedDateTable)
        return formattedDateTable
    }
}

func dateFor(#year:Int, #month:Int,day:Int = 1 ) -> NSDate {
    var dateComps = NSDateComponents()
    let calendar = NSCalendar.currentCalendar()
    let currentDate = NSDate()
    dateComps.day = calendar.component(NSCalendarUnit.CalendarUnitDay, fromDate: currentDate)
    dateComps.month = calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: currentDate)
    dateComps.year = calendar.component(NSCalendarUnit.CalendarUnitYear, fromDate: currentDate)
    dateComps.hour = calendar.component(NSCalendarUnit.CalendarUnitHour, fromDate: currentDate)
    dateComps.minute = calendar.component(NSCalendarUnit.CalendarUnitMinute, fromDate: currentDate)
    dateComps.second = calendar.component(NSCalendarUnit.CalendarUnitSecond, fromDate: currentDate)
    dateComps.nanosecond = calendar.component(NSCalendarUnit.CalendarUnitNanosecond, fromDate: currentDate)
    
    //make a date
    dateComps.year = year
    dateComps.month = month
    dateComps.day = day
    let constructedDate = calendar.dateFromComponents(dateComps)
    let weekdayOfConstructedDate = calendar.component(NSCalendarUnit.CalendarUnitWeekday, fromDate: currentDate)
    println(weekdayOfConstructedDate)
    println(constructedDate!.description)
    return constructedDate!
}