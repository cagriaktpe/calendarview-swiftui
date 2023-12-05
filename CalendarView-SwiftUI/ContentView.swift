//
//  ContentView.swift
//  CalendarView-SwiftUI
//
//  Created by Samet Çağrı Aktepe on 5.12.2023.
//

import SwiftUI

struct ContentView: View {
    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    @State private var selectedMonth = 0
    @State private var selectedYear = 0
    @State private var selectedDate = Date()
    @State private var showDatePicker: Bool = false

    let monthSymbols = Calendar.current.monthSymbols
    let years = Array(Date().year ..< Date().year + 10)

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showDatePicker.toggle()
                    } label: {
                        HStack {
                            Text(selectedDate.monthAndYear())
                                .font(.title3)
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)

                            Image(systemName: "chevron.right")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                        }
                    }

                    Spacer()

                    Button(action: {
                        withAnimation {
                            selectedMonth -= 1
                        }

                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)

                    })
                    .opacity(showDatePicker ? 0 : 1)

                    Spacer()
                        .frame(width: 28)

                    Button(action: {
                        withAnimation {
                            selectedMonth += 1
                        }

                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    })
                    .opacity(showDatePicker ? 0 : 1)
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
                .opacity(showDatePicker ? 0 : 1)

                ZStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 50) {
                        ForEach(fetchDates()) { value in
                            if value.day != 0 {
                                Text("\(value.day)")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(value.date.string() == Date().string() ? .blue : .black)
                            } else {
                                Text("")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .opacity(showDatePicker ? 0 : 1)
                    .frame(height: showDatePicker ? 0 : .infinity)
                    
                    // TODO: IMPLEMENT
                    HStack(spacing: 0) {
                        Picker("", selection: $selectedMonth) {
                            ForEach(0 ..< monthSymbols.count, id: \.self) { index in
                                Text(monthSymbols[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.wheel)

                        Picker("", selection: $selectedYear) {
                            ForEach(years, id: \.self) { year in
                                Text(String(year))
                                    .tag(year)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    
                    .opacity(showDatePicker ? 1 : 0)
                }
            }
            .padding()
        }
        .onChange(of: selectedMonth) { _, _ in

            selectedDate = fetchSelectedMonth()
        }
    }

    func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.current
        let currentMonth = fetchSelectedMonth()

        var dates = currentMonth.datesOfMonth().map({ CalendarDate(day: calendar.component(.day, from: $0), date: $0) })

        let firstDayOfMonth = calendar.component(.weekday, from: dates.first?.date ?? Date())

        for _ in 1 ..< firstDayOfMonth {
            dates.insert(CalendarDate(day: 0, date: Date()), at: 0)
        }

        let lastDayOfMonth = calendar.component(.weekday, from: dates.last!.date)

        for _ in lastDayOfMonth ..< 7 {
            dates.append(CalendarDate(day: 0, date: Date()))
        }

        return dates
    }

    func fetchSelectedMonth() -> Date {
        let calendar = Calendar.current

        let month = calendar.date(byAdding: .month, value: selectedMonth, to: Date())

        return month!
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
}
