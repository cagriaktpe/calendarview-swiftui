//
//  MonthView.swift
//  CalendarView-SwiftUI
//
//  Created by Samet Çağrı Aktepe on 11.12.2023.
//

import SwiftUI

struct MonthView: View {
    
    @StateObject private var viewModel = CustomCalendarViewModel()
    let month: Date
    
    var body: some View {
        LazyVGrid(columns: viewModel.columns, spacing: 50) {
            ForEach(viewModel.fetchDaysOfMonth(date: month), id: \.self) { calendarDate in
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
                        .foregroundStyle(calendarDate.date.isToday() ? .blue : .primary)
                        
                }
            }
        }
    }
}

#Preview {
    MonthView(month: Date())
}
