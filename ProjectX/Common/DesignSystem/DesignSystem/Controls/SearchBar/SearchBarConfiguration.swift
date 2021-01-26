//
//  SearchBarConfig.swift
//  Components
//
//  Created by Sameh Mabrouk on 12/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//
import UIKit

public struct SearchBarConfiguration {
    /// The attributes to format the searchbars text.
    public let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: defaultTextForegroundColor]

    /// The attributes to format the searchbars placeholder.
    public let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: DesignSystem.Colors.Palette.gray700.color, .font: Font(type: .body(.regular)).instance]
    
    /// The textContentType property is to provide the keyboard with extra information about the semantic intent of the text document.
    public let textContentType: String? = nil

    /// The left accessory view of the searchbar. For searchbars there is typically a search glass.
    public let leftView: UIView?

    /// The left view mode of the searchbar regarding to a leftView.
    public let leftViewMode: UITextField.ViewMode = .always

    /// The right accessory view of the searchbar. For searchbars there is typically a search glass.
    public let rightView: UIButton?

    /// The right view mode of the searchbar regarding to a rightView.
    public let rightViewMode: UITextField.ViewMode = .whileEditing

    /// Controls when to show the clear button.
    public let clearButtonMode: UITextField.ViewMode = .whileEditing

    /// This is used as the default text foreground color for button and text in the searchbar if nothing has been set by the user.
    public static var defaultTextForegroundColor = DesignSystem.Colors.Palette.brandBlack.color
}
