//
//  UILabel+DesignSystem.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 25/01/2021.
//

import UIKit

public extension UILabel {
    func addPadding(withNumberNumberOfSpaces spaces: Int) {
        let currentText = text ?? ""
        text = ""
        
        appendSpaces(count: spaces)
        self.text?.append(currentText)
        appendSpaces(count: spaces)
    }
    
    func appendSpaces(count: Int) {
        for _ in 1...count {
            text?.append(" ")
        }
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0,
                        lineHeightMultiple: CGFloat = 0.0,
                        minimumLineHeight: CGFloat = 0.0,
                        baseLineOffset: CGFloat = 0.0) {
        guard let labelText = text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.minimumLineHeight = minimumLineHeight
        
        let attributedString: NSMutableAttributedString
        
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                        NSAttributedString.Key.baselineOffset: baseLineOffset],
                                       range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}
