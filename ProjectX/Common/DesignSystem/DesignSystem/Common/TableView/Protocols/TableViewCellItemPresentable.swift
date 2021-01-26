//
//  CellItemPresentable.swift
//  Filters
//
//  Created by Sameh Mabrouk on 08/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol TableViewCellItemPresentable {
    var itemType: CellItemType { get set }
    var title: String { get set }
    var id: String? { get set }
    var subtitle: String? { get set }
    var details: String? { get set }
    var titleFont: UIFont? { get set }
    var titleTextColor: UIColor? { get set }
    var sliderValue: Float? { get set }
    var icon: Icon? { get set }
    var isChecked: Bool { get set }
    var hasSeparator: Bool { get set }
    var backgroundCorner: ItemBackgroundCorner? { get set }
    var didChangeSliderValue: PublishSubject<Int>? { get set }
    var textAlignment: NSTextAlignment { get set }
    var cellSelectionStyle: CellSelectionStyle { get set }
}

extension TableViewCellItemPresentable {

    public var icon: Icon? {
        get { return nil }
        set {}
    }
    
    public var isChecked: Bool {
        get { return false }
        set {}
    }
    
    public var sliderValue: Float? {
        get { return nil }
        set {}
    }
    
    public var hasSeparator: Bool {
        get { return true }
        set {}
    }
    
    public var backgroundCorner: ItemBackgroundCorner? {
        get { return nil }
        set {}
    }

    public var actionListener: PublishSubject<Void>? {
        get { return nil }
        set {}
    }

    public var didChangeSliderValue: PublishSubject<Int>? {
        get { return nil }
        set {}
    }

    public var titleFont: UIFont? {
        get { return nil }
        set {}
    }

    public var titleTextColor: UIColor? {
        get { return nil }
        set {}
    }

    public var textAlignment: NSTextAlignment {
        get { return .left }
        set {}
    }
    public var cellSelectionStyle: CellSelectionStyle {
        get { return .checkMark }
        set {}
    }
}

public struct CellItem: TableViewCellItemPresentable, Equatable {
    public static func == (lhs: CellItem, rhs: CellItem) -> Bool {
        return lhs.itemType == rhs.itemType &&
            lhs.title == rhs.title &&
            lhs.subtitle == rhs.subtitle &&
            lhs.details == rhs.details &&
            lhs.sliderValue == rhs.sliderValue &&
            lhs.backgroundCorner == rhs.backgroundCorner &&
            lhs.isChecked == rhs.isChecked &&
            lhs.hasSeparator == rhs.hasSeparator &&
            lhs.hasSeparator == rhs.hasSeparator &&
            lhs.textAlignment == rhs.textAlignment &&
            lhs.cellSelectionStyle == rhs.cellSelectionStyle &&
            lhs.titleFont == rhs.titleFont &&
            lhs.titleTextColor == rhs.titleTextColor
    }

    public var itemType: CellItemType
    public var title: String
    public var id: String?
    public var subtitle: String?
    public var details: String?
    public var sliderValue: Float?
    public var didChangeSliderValue: PublishSubject<Int>?
    public var backgroundCorner: ItemBackgroundCorner?
    public var isChecked: Bool
    public var hasSeparator: Bool
    public var textAlignment: NSTextAlignment
    public var cellSelectionStyle: CellSelectionStyle
    public var titleFont: UIFont?
    public var titleTextColor: UIColor?
    public var actionListener: PublishSubject<Void>?
    public var icon: Icon?
    
    public init(itemType: CellItemType, title: String = "", id: String? = nil, subtitle: String? = nil, icon: Icon? = nil, details: String? = nil, titleFont: UIFont? = nil, titleTextColor: UIColor? = nil, sliderValue: Float? = nil, didChangeSliderValue: PublishSubject<Int>? = nil, backgroundCorner: ItemBackgroundCorner? = ItemBackgroundCorner.none, isChecked: Bool = false, hasSeparator: Bool = true, textAlignment: NSTextAlignment = .left, selectionStyle: CellSelectionStyle = .checkMark, actionButtonListener: PublishSubject<Void>? = nil, leftButtonEnabled: Bool = false, rightButtonEnabled: Bool = false, leftButtonTapHandler: (() -> Void)? = nil, rightButtonTapHandler: (() -> Void)? = nil, textChangedEventListener: BehaviorRelay<String?>? = nil, handleErrorVisibility: PublishSubject<(shouldShow: Bool, errorMessage: String?)>? = nil) {

        self.itemType = itemType
        self.title = title
        self.id = id
        self.subtitle = subtitle
        self.details = details
        self.icon = icon
        self.sliderValue = sliderValue
        self.backgroundCorner = backgroundCorner
        self.isChecked = isChecked
        self.didChangeSliderValue = didChangeSliderValue
        self.hasSeparator = hasSeparator
        self.textAlignment = textAlignment
        self.cellSelectionStyle = selectionStyle
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
        self.actionListener = actionButtonListener
    }
}
