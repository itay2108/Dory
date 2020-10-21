//
//  CalendarDateCollectionViewCell.swift
//  Dory
//
//  Created by itay gervash on 19/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {
    
  let fontType = FontTypes()
    
  static let reuseIdentifier = String(describing: CalendarDateCollectionViewCell.self)
    
    var day: Day? {
      didSet {
        guard let day = day else { return }

        numberLabel.text = day.number
        accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
        updateSelectionState()
      }
    }
    
    private lazy var selectionBackgroundView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true
      view.backgroundColor = .systemRed
      return view
    }()

    private lazy var numberLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textAlignment = .center
      label.font = fontType.h2_medium
      label.textColor = .label
      return label
    }()

    private lazy var accessibilityDateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
      return dateFormatter
    }()
    
    private func setCellConstraints() {
        
        let size = traitCollection.horizontalSizeClass == .compact ?
          min(min(frame.width, frame.height) - 10, 60) : 45
        
        numberLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        selectionBackgroundView.snp.makeConstraints { (make) in
            make.center.equalTo(numberLabel.snp.center)
            
            make.width.equalTo(size)
            make.height.equalTo(size)
        }
    }


  override init(frame: CGRect) {
    super.init(frame: frame)

    isAccessibilityElement = true
    accessibilityTraits = .button
    
    contentView.addSubview(selectionBackgroundView)
    contentView.addSubview(numberLabel)
    
    self.backgroundColor = .blue
    
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
    setCellConstraints()
    self.selectionBackgroundView.layer.cornerRadius = self.bounds.height / 2
    print(self.bounds.height)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    layoutSubviews()
  }
}

private extension CalendarDateCollectionViewCell {
  // 1
  func updateSelectionState() {
    guard let day = day else { return }

    if day.isSelected {
      applySelectedStyle()
    } else {
      applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
    }
  }

  // 2
  var isSmallScreenSize: Bool {
    let isCompact = traitCollection.horizontalSizeClass == .compact
    let smallWidth = UIScreen.main.bounds.width <= 350
    let widthGreaterThanHeight =
      UIScreen.main.bounds.width > UIScreen.main.bounds.height

    return isCompact && (smallWidth || widthGreaterThanHeight)
  }

  // 3
  func applySelectedStyle() {
    accessibilityTraits.insert(.selected)
    accessibilityHint = nil

    numberLabel.textColor = isSmallScreenSize ? .systemRed : .white
    selectionBackgroundView.isHidden = isSmallScreenSize
  }

  // 4
  func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
    accessibilityTraits.remove(.selected)
    accessibilityHint = "Tap to select"

    numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
    selectionBackgroundView.isHidden = true
  }
}

