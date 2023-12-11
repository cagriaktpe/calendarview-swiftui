//
//  ContentView.swift
//  CalendarView-SwiftUI
//
//  Created by Samet Çağrı Aktepe on 5.12.2023.
//

import SwiftUI

struct ContentView: View {
    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    @State private var selectedDate = Date()
    @State private var months: [Date] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
                        months = getAllMonthBetweenToDates(dates: calcStartAndEndDate())
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    })
                    
                    .padding(.leading, 16)

                    Spacer()

                    Text(selectedDate.monthAndYear())
                        .font(.title2)
                        .foregroundStyle(.primary)
                        .fontWeight(.semibold)

                    Spacer()

                    Button(action: {
                        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
                        months = getAllMonthBetweenToDates(dates: calcStartAndEndDate())
                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    })
                    .padding(.trailing, 16)
                }

                HStack {
                    ForEach(days, id: \.self) { day in

                        Text(day)
                            .font(.callout)
                            .foregroundStyle(.gray.opacity(0.5))
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                TabView(selection: $selectedDate) {
                    ForEach(months, id: \.self) { date in
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 50) {
                            ForEach(fetchDaysOfMonth(date: date), id: \.self) { calendarDate in
                                if calendarDate.day == 0 {
                                    Text("0")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.primary)
                                        .opacity(0)
                                } else {
                                    Text("\(calendarDate.day)")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(isSameDay(date: calendarDate.date) ? .blue : .primary)
                                        
                                }
                            }
                        }
                        .tag(date)
                        .padding(.bottom, 90)
                    }
                }
                .transaction { transaction in
                                transaction.animation = nil
                            }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 510, alignment: .top)
                
            }
            .onAppear {
                months = getAllMonthBetweenToDates(dates: calcStartAndEndDate())
            }
            .padding(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }

    func calcStartAndEndDate() -> [Date] {
        let calendar = Calendar.current

        let sizMonthsAgo = calendar.date(byAdding: .month, value: -6, to: selectedDate) ?? Date().addingTimeInterval(-1000000)
        let twelveMonthsLater = calendar.date(byAdding: .month, value: 12, to: selectedDate) ?? Date().addingTimeInterval(1000000)

        return [sizMonthsAgo, twelveMonthsLater]
    }

    func getAllMonthBetweenToDates(dates: [Date]) -> [Date] {
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

        print(zeroCount)

        while zeroCount < 11 {
            calendarDates.append(CalendarDate(day: 0, date: dates.last!))
            zeroCount += 1
        }

        return calendarDates
    }

    func isSameDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, equalTo: .now, toGranularity: .day) && calendar.isDate(date, equalTo: .now, toGranularity: .month) && calendar.isDate(date, equalTo: .now, toGranularity: .year)
    }
}

struct CalendarDate: Identifiable, Hashable {
    let id = UUID()
    var day: Int
    var date: Date
}

#Preview {
    ContentView()
}

extension Date {
    var year: Int { Calendar.current.component(.year, from: self) }
    var month: Int { Calendar.current.component(.month, from: self) }

    func datesOfMonth() -> [Date] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)

        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear
        startDateComponents.month = currentMonth
        startDateComponents.day = 1
        let startDate = calendar.date(from: startDateComponents)!

        var endDateComponents = DateComponents()
        endDateComponents.month = 1
        endDateComponents.day = -1
        let endDate = calendar.date(byAdding: endDateComponents, to: startDate)!

        var dates: [Date] = []
        var currentDate = startDate

        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return dates
    }

    func monthAndYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }

    func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }

    func addMonth(_ month: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = month
        return calendar.date(byAdding: dateComponents, to: self)!
    }
    
}
