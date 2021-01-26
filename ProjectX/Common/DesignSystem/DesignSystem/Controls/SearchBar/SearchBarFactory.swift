//
//  SearchBarFactory.swift
//  Components
//
//  Created by Sameh Mabrouk on 12/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import RxSwift

public class SearchBarFactory<T>: Factory {
    
    public lazy var playbookPresentationSize = {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 48, height: 56)
    }()
    
    public typealias ComponentType = T
    
    private var searchBar: SearchBar!
    
    private let disposeBag = DisposeBag()
        
    private lazy var leftView: UIImageView = {
        let leftView = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        leftView.contentMode = .scaleAspectFit
        leftView.image = IconFactory(icon: .search).build()
        
        return leftView
    }()
    
    private lazy var clearButton: UIButton = {
        let closeButton = UIButton(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        closeButton.setImage(IconFactory(icon: .searchBarClose).build(), for: .normal)
        
        return closeButton
    }()
    
    public init() {
        let config = SearchBarConfiguration(leftView: leftView, rightView: clearButton)
        searchBar = SearchBar(config: config)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func build() -> T {
        return searchBar as! T
    }
}
