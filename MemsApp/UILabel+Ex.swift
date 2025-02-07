//
//  UILabel+Ex.swift
//  MemsApp
//
//  Created by user on 07.02.2025.
//


import UIKit

extension UILabel {
    static func makeLabel(text: String = "", font: UIFont?, textColor: UIColor, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
