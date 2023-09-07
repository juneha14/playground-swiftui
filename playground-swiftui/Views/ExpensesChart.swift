//
//  ExpensesChart.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-09-06.
//

import SwiftUI
import Charts

struct ExpensesChart: View {
    @State private var selectedDay: Spending.DayOfWeek? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LabeledContent {
                    ZStack {
                        Circle().stroke(.white, lineWidth: 3).offset(x: -20)
                        Circle().fill(.black).frame(width: 40)
                    }
                    .frame(width: 40, height: 40)
                } label: {
                    Text("My balance")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.bottom, 1)
                    Text("$921.48")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
                .background(Theme.softRed)
                .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text("Spending - Last 7 days")
                        .font(.title2)
                        .bold()
                        .padding(.bottom)
                    
                    Chart {
                        ForEach(SPENDINGS, id: \.day.rawValue) { spending in
                            BarMark(x: .value("day", spending.day.rawValue), y: .value("amount", spending.amount))
                                .annotation(alignment: .top) {
                                    if selectedDay == spending.day {
                                        let amount = spending.amount
                                        let formatted = amount.formatted(.currency(code: "USD"))
                                        Text(formatted)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding(4)
                                            .background(.primary)
                                            .cornerRadius(4)
                                    }
                                }
                                .cornerRadius(4)
                                .foregroundStyle(selectedDay == spending.day ? Theme.cyan : Theme.softRed)
                        }
                    }
                    .frame(minHeight: 250)
                    .chartOverlay { chart in
                      GeometryReader { geometry in
                          Rectangle()
                              .fill(.clear)
                              .contentShape(Rectangle())
                              .onTapGesture { location in
                                  let origin = geometry[chart.plotAreaFrame].origin
                                  let position = CGPoint(x: location.x - origin.x, y: location.y - origin.y)
                                  
                                  guard let day: String = chart.value(atX: position.x) else { return }
                                  
                                  let newSelection = Spending.DayOfWeek(rawValue: day)
                                  if newSelection != selectedDay {
                                      selectedDay = newSelection
                                  } else {
                                      selectedDay = nil
                                  }
                              }
                      }
                    }
                    
                    Divider()
                    
                    LabeledContent {
                        VStack(alignment: .trailing) {
                            Text("+2.4%")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.primary)
                            Text("from last month")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    } label: {
                        Text("Total this month")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$478.33")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                    }
                    .padding(.top)
                }
                .padding()
                .background(.white)
                .cornerRadius(8)
                .padding(.top)
            }
            .padding(.horizontal)
            .background(Theme.cream)
            .navigationTitle("Expenses")
        }
    }
}

struct ExpensesChart_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesChart()
    }
}

struct Spending {
    enum DayOfWeek: String {
        case monday = "mon"
        case tuesday = "tues"
        case wednesday = "wed"
        case thursday = "thurs"
        case friday = "fri"
        case saturday = "sat"
        case sunday = "sun"
    }
    
    let day: DayOfWeek
    let amount: Double
}

let SPENDINGS: [Spending] = [
    .init(day: .monday, amount: 17.45),
    .init(day: .tuesday, amount: 34.91),
    .init(day: .wednesday, amount: 52.36),
    .init(day: .thursday, amount: 31.07),
    .init(day: .friday, amount: 23.39),
    .init(day: .saturday, amount: 43.28),
    .init(day: .sunday, amount: 25.48)
]

fileprivate struct Theme {
    static let softRed = Color(red: 236/255, green: 119/255, blue: 95/255)
    static let cyan = Color(red: 118/255, green: 181/255, blue: 188/255)
    static let cream = Color(red: 248/255, green: 233/255, blue: 221/255)
}
