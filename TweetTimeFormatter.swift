//
//  TweetTimeFormatter.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/21/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import Foundation

class TweetTimeFormatter {
    
    class func timeAgoFormat(tweet: Tweet) -> String {
        let current = generateComponents(NSDate())
        let created = generateComponents(tweet.createdAt!)
        
        return compareDates(created, current: current)
    }
    
    private class func generateComponents(date: NSDate) -> NSDateComponents {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        
        return components
    }
    
    private class func compareDates(created: NSDateComponents, current: NSDateComponents) -> String {
//        let year = (current.year - created.year)
//        let month = abs(current.month - created.month + 12)
        let day = abs(current.day - created.day)
        let hour = calcHours(created, current: current)
        let min = calcMinutes(created, current: current)
        
        // expand this logic later
        
        if day > 0 {
            return "\(day)d"
        } else if hour > 0 {
            return "\(hour)h"
        } else {
            return "\(min)m"
        }
    }
    
    private class func calcMinutes(created: NSDateComponents, current: NSDateComponents) -> Int {
        if created.minute > current.minute {
            return (current.minute - (created.minute - 60))
        } else {
            return (current.minute - created.minute)
        }
    }
    
    private class func calcHours(created: NSDateComponents, current: NSDateComponents) -> Int {
        if created.hour > current.hour {
            return (current.hour - (created.hour - 12))
        } else {
            return (current.hour - created.hour)
        }
    }
}
