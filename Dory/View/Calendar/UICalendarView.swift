//
//  UICalendarView.swift
//  Dory
//
//  Created by itay gervash on 18/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

class UICalendarView: UIView, UICollectionViewDelegate {
    
    private var baseDate: Date {
        didSet {
            days = getMonthDaysFrom(baseDate: baseDate)
            collectionView.reloadData()
        }
    }
    
    private lazy var days = getMonthDaysFrom(baseDate: baseDate)
    
    var selectedDate = Date()
    
    private let calendar = Calendar(identifier: .gregorian)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    
    
    
    
    //MARK: - inits
    
    init(baseDate: Date) {
        
        self.baseDate = baseDate
        
        super.init(frame: .zero)
        
        collectionView.register(
          CalendarDateCollectionViewCell.self,
          forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier
        )
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.backgroundColor = .white
        
        collectionView.reloadData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Day Generation

extension UICalendarView {
    
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))?.inCurrentTimeZone
        else {
            throw CalendarDataError.metadataGeneration
        }
        
        print("first day", firstDayOfMonth)
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    
    enum CalendarDataError: Error {
        case metadataGeneration
    }
    
    
    private func getMonthDaysFrom(baseDate date: Date) -> [Day] {
        
        guard let metadata = try? monthMetadata(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
            
            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth.inCurrentTimeZone)
        
        return days
        
    }
    
    func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate)?.inCurrentTimeZone ?? baseDate
        print("date:", date, "number:", dateFormatter.string(from: date))
        
        return Day(date: date, number: dateFormatter.string(from: date), isSelected: calendar.isDate(date, inSameDayAs: selectedDate), isWithinDisplayedMonth: isWithinDisplayedMonth)
    }
    
    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard
            let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth)
        else { return [] }
        
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else { return [] }
        
        let days: [Day] = (1...additionalDays).map {
            generateDay(
                offsetBy: $0,
                for: lastDayInMonth,
                isWithinDisplayedMonth: false)
        }
        
        return days
    }
}

extension UICalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let day = days[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
            for: indexPath) as! CalendarDateCollectionViewCell
        
        cell.day = day
        print(collectionView.numberOfItems(inSection: 0))
        return cell
    }
    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didSelectItemAt indexPath: IndexPath
//    ) {
//        let day = days[indexPath.row]
//        selectedDateChanged(day.date)
//        dismiss(animated: true, completion: nil)
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        let width = Int(collectionView.frame.width / 7)
//        let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
//        return CGSize(width: width, height: height)
//    }
}

