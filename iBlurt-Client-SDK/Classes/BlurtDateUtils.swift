//
//  BlurtDateUtils.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 27/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

import UIKit

class BlurtDateUtils {
    
    static let SERVER_DATE_FORMAT = "yyyy-MM-dd HH:mm:ss"
    static let SERVER_ONLY_DATE_FORMAT = "dd-MM-yyyy"
    static let SIMPLE_DATE_FORMAT_WITH_TIME = "dd/MM/yyyy HH:mm:ss"
    static let SIMPLE_DATE_FORMAT = "dd/MM/yyyy"
    static let FORECAST_DATE_FORMAT = "yyyy-MM-dd"
    static let DOB_DATE_FORMAT = "dd MMM, yyyy"
    static let TIME_PICKED_FORMAT = "EEE MMM dd HH:mm:ss Z yyyy"
    static let TIME_FORMAT = "hh:mm a"
    static let TRANSACTION_FORMAT = "dd MMM yyyy, hh:mm aa"
    static let CHAT_HISTORY_DATE_FORMAT = "hh:mmaa dd-MMM-yy"
    static let SINGLE_CHAT_DATE_FORMAT = "dd MMM yy"
    static let CHAT_DISPLAY_DATE_FORMAT = "hh:mm a"
    
    
    static func parseStringDate(dateToConvert : String, inputDateFormat :  String , outputDateFormat : String) -> String{
        let inputFormat = DateFormatter()
        inputFormat.dateFormat = inputDateFormat
        
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = outputDateFormat
        
        let date = inputFormat.date(from: dateToConvert)
        return outputFormat.string(from: date!)
    }
    
    static func getDateWithSuffix(date : String) -> String {
        
        if !date.contains(" ") {
            return date
        }
        
        let dateSplit = date.split(separator: " ")
        
        let getDayWithSuffix = getDayOfMonthSuffix(value : Int(dateSplit[0])!)
        
        return "\(dateSplit[0])\(getDayWithSuffix) \(dateSplit[1]) \(dateSplit[2])"
        
    }
    
    static func getDayOfMonthSuffix(value : Int) -> String{
        
        if (value >= 11 && value <= 13) {
            return "th"
        }
        switch (value % 10) {
        case 1:
            return "st"
        case 2:
            return "nd"
        case 3:
            return "rd"
        default:
            return "th"
        }
    }
    
    static func getDOBTime(dateToConvert : String) -> String {
        if !dateToConvert.contains(" ") {
            return dateToConvert
        }
        var splitDate = dateToConvert.split(separator: " ")
        var splitTime = splitDate[1].split(separator: ":")
        var amPM = "";
        if (Int(splitTime[0])! >= 12) {
            amPM = " PM";
        } else {
            amPM = " AM";
        }
        return "\(splitTime[0]) : \(splitTime[1]) \(amPM)";
    }
    
    static func getAge(dob: String, inputDateFormat :String)  -> String{
        
        let inputFormat = DateFormatter()
        inputFormat.dateFormat = inputDateFormat
        
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = SIMPLE_DATE_FORMAT
        
        
        let dobDate = inputFormat.date(from: dob)
        
        let currentTimeInMiliseconds = Date().timeIntervalSince1970
        let currentDate = Date.init(timeIntervalSince1970: currentTimeInMiliseconds)
        
        let dobYear = outputFormat.string(from: dobDate!)
        let currentYear = outputFormat.string(from: currentDate)
        
        let splitDobDate = dobYear.split(separator: "/")
        let splitCurrentDate = currentYear.split(separator: "/")
        
        let year = Int(splitCurrentDate[2])! - Int(splitDobDate[2])!
        
        if (year == 0) {
            let month = Int(splitCurrentDate[1])! - Int(splitDobDate[1])!
            if (month == 0) {
                let day = Int(splitCurrentDate[0])! - Int(splitDobDate[0])!
                if (day == 0) {
                    return "0 Yrs";
                } else {
                    return "\(day) Days";
                }
            } else {
                return "\(month) Months";
            }
            
        } else {
            return "\(year) Yrs";
        }
        
    }
    
    static func getDate(format :  String) -> String{
        let inputFormat = DateFormatter()
        inputFormat.dateFormat = format
        
        let currentTimeInMiliseconds = Date().timeIntervalSince1970
        let currentDate = Date.init(timeIntervalSince1970: currentTimeInMiliseconds)
        return inputFormat.string(from: currentDate)
    }
    
    //    public static String convertDateForChatDisplay(Date dateToConvert, String toDateFormat) {
    //    SimpleDateFormat outputFormat = new SimpleDateFormat(toDateFormat, Locale.getDefault());
    //    return outputFormat.format(dateToConvert);
    //    }
    
    
    static func convertDateForChatDisplay(timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp/1000)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.locale = NSLocale.current
        dayTimePeriodFormatter.dateFormat = CHAT_HISTORY_DATE_FORMAT
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    
    static func convertDateForChatMessageDisplay(timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp/1000)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.locale = NSLocale.current
        dayTimePeriodFormatter.dateFormat = CHAT_DISPLAY_DATE_FORMAT
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    
    static func convertDateForChatFeedbackDisplay(timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp/1000)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.locale = NSLocale.current
        dayTimePeriodFormatter.dateFormat = DOB_DATE_FORMAT
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    static func isHandlerAvailable() -> Bool {
        var available = false
        let componets = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let currentHour = componets.hour
        print(currentHour)
        if currentHour! > 9 && currentHour! > 21 {
            available = true
            print ("do something")
        } else {
            available = false
            print ("do nothing")
        }
        
        return available
    }
    
}
