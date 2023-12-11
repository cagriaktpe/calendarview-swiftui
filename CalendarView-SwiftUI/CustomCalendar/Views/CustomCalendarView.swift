//
//  CustomCalendarView.swift
//  CalendarView-SwiftUI
//
//  Created by Samet Çağrı Aktepe on 11.12.2023.
//

import SwiftUI

struct CustomCalendarView: View {
    
    @StateObject private var viewModel = CustomCalendarViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        withAnimation {
                            viewModel.previousMonth()
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    })
                    
                    .padding(.leading, 16)

                    Spacer()

                    Text(viewModel.selectedDate.monthAndYear())
                        .font(.title2)
                        .foregroundStyle(.primary)
                        .fontWeight(.semibold)

                    Spacer()

                    Button(action: {
                        withAnimation {
                            viewModel.nextMonth()
                        }
                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    })
                    .padding(.trailing, 16)
                }

                HStack {
                    ForEach(viewModel.days, id: \.self) { day in

                        Text(day)
                            .font(.callout)
                            .foregroundStyle(.gray.opacity(0.5))
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                TabView(selection: $viewModel.selectedDate) {
                    ForEach(viewModel.months, id: \.self) { month in
                        MonthView(month: month)
                            .tag(month)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 420)
                
            }
            .onAppear {
                viewModel.updateMonths()
            }
            .padding(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

#Preview {
    CustomCalendarView()
}
