////
////  DailyPlan.swift
////  Energram
////
////  Created by Alex Antipov on 05.02.2023.
////
//
//import Foundation
//import SwiftUI
//
//
//enum DailyPlanType {
//    case normal, preview
//}
//
//class DailyPlan: ObservableObject {
//
//    @Published var price: DayPrice?
//
//    @Published var lastFetch: Date?
//
//    @Published var randomStupidHack: Double = 0.0  // to push value here after appliance assignung. Without this, totalCoet in DayPlanView.swift not updating in the view...
//
//    @Published var appliedAppliances = AppliedAppliances()
//    private var appliancesListViewModel = AppliancesListViewModel()
//
//    @Published var selectedApplianceToEdit: Appliance?
//
//    // MARK: Init
//    init(type: DailyPlanType = .normal) {
//        switch type {
//        case .normal:
//            appliancesListViewModel.fetchAppliances()
//        case .preview:
//            self.price = DayPrice.mocked.day1
//            self.appliedAppliances.items = [AppliedAppliance.mocked.aa1, AppliedAppliance.mocked.aa2, AppliedAppliance.mocked.aa3, AppliedAppliance.mocked.aa4, AppliedAppliance.mocked.aa5]
//        }
//    }
//
//    func priceReceived(price data:DayPrice) {
//        self.price = data
//        //self.fillPrices(dayPrice: data)
//
//        self.lastFetch = Date()
//        Notification.fire(name: .latestPriceRecieved)
//    }
//
//    // MARK: Interaction
//    
//    func getAppliancebyId(_ str: String) -> Appliance? {
//        let uuid = UUID(uuidString: str)
//        if let idx: Int = self.appliancesListViewModel.appliances.firstIndex(where: {$0.id == uuid}) {
//            return self.appliancesListViewModel.appliances[idx]
//        }
//
//        print("Can't find apliance with requested uuid")
//        return nil
//    }
//
//    func isApplianceApplied(_ appliance: Appliance) -> Bool {
//        if let _: Int = self.appliedAppliances.items.firstIndex(where: {$0.appliance.id == appliance.id}) {
//            return true
//        }
//        return false
//    }
//
//    func applianceModified(appliance: Appliance) {
//        self.unassignAppliance(appliance: appliance)
//        self.assignAppliance(appliance: appliance)
//    }
//
//    func toggleApplianceLabel(applianceLabel: ApplianceLabel) {
//        applianceLabel.isSelected.toggle()
//        if (applianceLabel.isSelected){
//            self.assignAppliance(appliance: applianceLabel.appliance)
//        } else {
//            self.unassignAppliance(appliance: applianceLabel.appliance)
//        }
//    }
//
//    func applyTimeDiffAfterDrag(aa: AppliedAppliance, diffRecieved: Int?) {
//        guard var diff = diffRecieved else {
//            log("Received nil time diff")
//            return
//        }
//
//
//
//        if diff < -15 {
//            //print("correcting minus")
//            diff = diff + 15
//        }
////        if diff > 30 {
////            print("correcting plus")
////            diff = diff - 30
////        }
////
//
//
//
//        guard let newStart = Calendar.current.date(byAdding: .minute, value: diff, to: aa.start) else {
//            log("Cannot apply diff")
//            return
//        }
//
//        let components = Calendar.current.dateComponents([.hour, .minute], from: newStart)
//        let hour = components.hour ?? 0
//        //let minute = components.minute ?? 0
//
//        //let midnight = Calendar.current.date(bySettingHour: 00, minute: 0, second: 0, of: Date())!
//
//        var newcomponents = DateComponents()
//        newcomponents.hour = hour
//        newcomponents.minute = 0
//
//        //let roundedToHour = Calendar.current.date(byAdding: newcomponents, to: midnight)!
//        self.unassignAppliance(appliance: aa.appliance)
//        self.assignAppliance(appliance: aa.appliance, toHour: hour)
//    }
//
//
//    // MARK: Calculations
//
//    func calculatePricexDuration(startHourIndex: Int, durationMinutes: Int, power: Int) -> Float {
//        let pw: Float = Float(power) / 1000
//
//        guard let prices: [Float] = self.price?.data else {
//            print("Error in set prices in DailyPlan.swift")
//            return 0
//        }
//
//        var sum: Float = 0
//
//        let hours = durationMinutes / 60
//        let andMinutes = durationMinutes % 60
//
//        var lastCompleteHourIndex: Int = startHourIndex
//        if hours > 0 {
//            for index in 0..<hours {
//                sum = sum + prices[startHourIndex + index] * pw
//                lastCompleteHourIndex = index
//            }
//            sum = sum + ((prices[ lastCompleteHourIndex + 1] / 60) * Float(andMinutes)) * pw
//        } else {
//            sum = (prices[ startHourIndex ] / 60) * Float(andMinutes) * pw
//        }
//        return sum
//    }
//
//    func findMinimumPriceInDay(durationMinutes: Int, power: Int) -> (hour: Int, price: Float) {
//        var minimumStartHour: Int = 0
//        var minimumFound = calculatePricexDuration(startHourIndex: 0, durationMinutes: durationMinutes, power: power)
//
//        let hours = durationMinutes / 60
//        let andMinutes = durationMinutes % 60
//
//        if hours > 0 {
//
//            var minutesPadding = 0
//            if andMinutes > 0 {
//                minutesPadding = 1
//            }
//
//
//            for hour in 0...24-hours-minutesPadding {
//                let candidate: Float = calculatePricexDuration(startHourIndex: hour, durationMinutes: durationMinutes, power: power)
//                if candidate < minimumFound {
//                    minimumFound = candidate
//                    minimumStartHour = hour
//                }
//            }
//        } else {
//            for hour in 0..<24 {
//                let candidate: Float = calculatePricexDuration(startHourIndex: hour, durationMinutes: durationMinutes, power: power)
//                if candidate < minimumFound {
//                    minimumFound = candidate
//                    minimumStartHour = hour
//                }
//
//            }
//
//        }
//        return (hour: minimumStartHour, price: minimumFound)
//    }
//
//
//    private func assignAppliance(appliance: Appliance, toHour: Int? = nil) {
//        //log("> assignAppliance")
//        guard let _ = self.price else {
//            log("Don't have a price data so ca't do anything")
//            return
//        }
//
//        var timeslotIndex: Int = 0
//        if let forcedHour = toHour {
//            timeslotIndex = forcedHour
//        } else {
//            let minimum = findMinimumPriceInDay(durationMinutes: appliance.typical_duration, power: appliance.power)
//            timeslotIndex = minimum.hour
//        }
//
//        let cost = calculatePricexDuration(startHourIndex: timeslotIndex, durationMinutes: appliance.typical_duration, power: appliance.power)
//        self.appliedAppliances.add(appliance: appliance, hour: timeslotIndex, cost: cost)
//
//        self.randomStupidHack = Double.random(in: 1...100) // without this, totalCoet in DayPlanView.swift not updating in the view...
//    }
//
//    private func unassignAppliance(appliance: Appliance) {
//        //log("> unassignAppliance")
//        self.appliedAppliances.remove(appliance: appliance)
//        self.randomStupidHack = Double.random(in: 1...100) // without this, totalCoet in DayPlanView.swift not updating in the view...
//    }
//
//}
