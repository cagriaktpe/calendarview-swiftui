//
//  CalendarDate.swift
//  CalendarView-SwiftUI
//
//  Created by Samet Çağrı Aktepe on 11.12.2023.
//

import Foundation

struct CalendarDate: Identifiable, Hashable {
    let id = UUID()
    var day: Int
    var date: Date
}
