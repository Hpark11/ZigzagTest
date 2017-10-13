//
//  FilterAgeTableViewCell.swift
//  ZigZagTest
//
//  Created by hPark_ipl on 2017. 10. 12..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit
import Action
import RxSwift
import RxCocoa

class FilterTableViewCell: UITableViewCell, NibLoadable {

  @IBOutlet weak var mainStackView: UIStackView!
  
  var disposedBag = DisposeBag()
  
  lazy var subStackViews: (Filter.Category, Action<Setter, Void>) -> ([UIStackView]) = { [weak self] type, action in
    var stackViews: [UIStackView] = []
    let colForRow: Int = Filter.rows(type)
    
    Filter.list(type).enumerated().forEach { offset, value in
      let index = offset % colForRow
      if index == 0 {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        stackViews.append(stackView)
      }
      var button = RoundedButton(value, color: Filter.keyColor(type))
      
      if type == .age {
        button.rx.bind(to: action, input: (key: type, value: offset))
      } else {
        
      }
      
      stackViews.last!.insertArrangedSubview(button, at: index)
    }
  
    return stackViews
  }
  
  func configure(type: Filter.Category, update: Action<Setter, Void>) {
    let stackViews = subStackViews(type, update)
    for (i, sub) in stackViews.enumerated() {
      mainStackView.insertArrangedSubview(sub, at: i)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func prepareForReuse() {
    mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    disposedBag = DisposeBag()
    super.prepareForReuse()
  }
}
