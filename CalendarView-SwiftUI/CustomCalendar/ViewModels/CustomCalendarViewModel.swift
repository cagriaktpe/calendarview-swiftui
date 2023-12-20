//
//  CustomCalendarViewModel.swift
//  CalendarView-SwiftUI
//
//  Created by Samet Çağrı Aktepe on 11.12.2023.
//

import Foundation
import SwiftUI

class CustomCalendarViewModel: ObservableObject {
    
    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @Published var selectedDate = Date()
    @Published var calendarEndDate = Date().addingTimeInterval(1000000)
    @Published var calendarStartDate = Date().addingTimeInterval(-1000000)
    @Published var months: [Date] = []
    
    init() {
        months = getAllMonthBetweenTwoDates(dates: calcStartAndEndDate())
    }
    
    func nextMonth() {
        if selectedDate.monthAndYear() == calendarEndDate.monthAndYear() {
            return
        }
        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
        
    }
    
    func previousMonth() {
        if selectedDate.monthAndYear() == calendarStartDate.monthAndYear() {
            return
        }
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
       
    }
    
    func calcStartAndEndDate() -> [Date] {
        let calendar = Calendar.current

        calendarStartDate = calendar.date(byAdding: .month, value: -6, to: selectedDate) ?? Date().addingTimeInterval(-1000000)
        calendarEndDate = calendar.date(byAdding: .month, value: 12, to: selectedDate) ?? Date().addingTimeInterval(1000000)

        return [calendarStartDate, calendarEndDate]
    }

    func getAllMonthBetweenTwoDates(dates: [Date]) -> [Date] {
        guard dates.count == 2 else { return [] }

        let calendar = Calendar.current
        
        guard let startDate = dates.first else { return [] }
        guard let endDate = dates.last else { return [] }

        var months: [Date] = []
        var currentDate = startDate

        while currentDate <= endDate {
            months.append(currentDate)
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? Date()
        }

        return months
    }

    func fetchDaysOfMonth(date: Date) -> [CalendarDate] {
        let calendar = Calendar.current
        let dates = date.datesOfMonth()
        
        guard let firstDate = dates.first else { return [] }
        guard let lastDate = dates.last else { return [] }
        
        let firstDay = calendar.component(.weekday, from: firstDate)
        let lastDay = calendar.component(.weekday, from: lastDate)

        var calendarDates: [CalendarDate] = []

        for _ in 1 ..< firstDay {
            calendarDates.append(CalendarDate(day: 0, date: dates.first!))
        }

        for date in dates {
            calendarDates.append(CalendarDate(day: calendar.component(.day, from: date), date: date))
        }

        for _ in lastDay ..< 7 {
            calendarDates.append(CalendarDate(day: 0, date: dates.last!))
        }
        
        
        var zeroCount = calendarDates.filter({ $0.day == 0 }).count

        while zeroCount < 11 {
            calendarDates.append(CalendarDate(day: 0, date: dates.last!))
            zeroCount += 1
        }

        return calendarDates
    }
    
    func updateMonths() {
        months = getAllMonthBetweenTwoDates(dates: calcStartAndEndDate())
    }
    
}
