//
//  SearchBar.swift
//  Components
//
//  Created by Sameh Mabrouk on 12/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import RxSwift

public class SearchBar: UIView, SearchBarDelegate {
    
    public enum State {
        case normal
        case focused
    }
    
    // MARK: - Internal properties
    
    let textField: SearchBarTextField
    
    // MARK: - Public properties

    /// The sate of search bar
    public var state: State = .normal {
        didSet {
            switch state {
            case .normal:
                border.borderColor = DesignSystem.Colors.Palette.gray100.color.cgColor
            case .focused:
                border.borderColor = DesignSystem.Colors.Palette.secondary400.color.cgColor
            }
        }
    }
    
    /// The text of the searchbar. Defaults to nil.
    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    /// The placeholder of the searchbar. Defaults to nil.
    public var placeholder: String? {
        set {
            textField.placeholder = newValue
            textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: config.placeholderAttributes)
        }
        get { textField.placeholder }
    }
    
    /// The text alignment of the searchbar.
    public var textAlignment: NSTextAlignment {
        set { textField.textAlignment = newValue }
        get { textField.textAlignment }
    }
    
    /// The enabled state of the searchbar.
    public var isEnabled: Bool {
        set { textField.isEnabled = newValue }
        get { textField.isEnabled }
    }
    
    /// The delegate which informs the user about important events.
    public weak var delegate: SearchBarDelegate?
    
    // MARK: - Private properties
        
    /// configures all searchbar parameters.
    private var config: SearchBarConfiguration
    
    private let borderWidth: CGFloat = 1.0    
    private let cornerRadius: CGFloat = 4.0
    private let border = CALayer()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle

    public init(config: SearchBarConfiguration) {
        self.config = config
        textField = SearchBarTextField()
        
        super.init(frame: CGRect.zero)
        
        delegate = self
        setupUI()
        setubObservers()
    }
    
    func setupTextField(withConfig config: SearchBarConfiguration) {
        textField.delegate = self
        textField.font = Font(type: .body(.regular)).instance
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.clipsToBounds = true
        textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
        
        let textColor = config.textAttributes[.foregroundColor] as? UIColor ?? SearchBarConfiguration.defaultTextForegroundColor
        
        textField.tintColor = textColor // set cursor color
        textField.textColor = textColor
        
        textField.leftView = config.leftView
        textField.leftViewMode = config.leftViewMode
        
        config.rightView?.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        textField.rightView = config.rightView
        
        textField.rightViewMode = config.rightViewMode
        
        textField.clearButtonMode = config.clearButtonMode

        textField.defaultTextAttributes = config.textAttributes
        
        if let textContentType = config.textContentType {
            textField.textContentType = UITextContentType(rawValue: textContentType)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    // MARK: - First Responder Handling
    
    override public var isFirstResponder: Bool {
        textField.isFirstResponder
    }
    
    @discardableResult
    override public func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    override public var canResignFirstResponder: Bool {
        textField.canResignFirstResponder
    }
    
    override public var canBecomeFirstResponder: Bool {
        textField.canBecomeFirstResponder
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setupBorder()
        
    }
    
    // MARK: - Handle Text Changes
    
    @objc func didChangeTextField(_ textField: UITextField) {
        let newText = textField.text ?? ""
        delegate?.searchBar(self, textDidChange: newText)
    }
    
    @objc func closeButtonTapped() {
        delegate?.searchBarDidTapClearButton()
    }
}

// MARK: - Setup UI

private extension SearchBar {
    
    func setupUI() {
        setupTextField(withConfig: config)
        setupSubviews()
        setupConstraints()
        
        state = .normal
    }
    
    func setupSubviews() {
        backgroundColor = DesignSystem.Colors.Palette.gray100.color
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        addSubview(textField)
    }
    
    func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupBorder() {
        border.borderColor = DesignSystem.Colors.Palette.gray100.color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        border.borderWidth = borderWidth
        border.cornerRadius = cornerRadius
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    func setubObservers() {
        config.rightView?.rx.tap.subscribe(onNext: { [weak self] in
            self?.text = ""
            }, onDisposed: {
                print("onDisposed")
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITextFieldDelegate

extension SearchBar: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.searchBarShouldBeginEditing(self) ?? searchBarShouldBeginEditing(self)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .focused
        delegate?.searchBarDidBeginEditing(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.searchBarShouldEndEditing(self) ?? searchBarShouldEndEditing(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        state = .normal
        delegate?.searchBarDidEndEditing(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let delegate = delegate else {
            return searchBar(self, shouldChangeCharactersIn: range, replacementString: string)
        }
        return delegate.searchBar(self, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.searchBarShouldClear(self) ?? searchBarShouldClear(self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.searchBarShouldReturn(self) ?? searchBarShouldReturn(self)
    }
}
