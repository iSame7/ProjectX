//
//  BannerCell.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 15/05/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import DesignSystem
import Utils
import RxSwift

class BannerCell: UITableViewCell {
    
    public var data: BannerItem? {
        didSet {
            setViewData()
        }
    }
    
    let disposeBag = DisposeBag()
    
    lazy open var bannerView: BannerView = {
        BannerFactory(Emoji.party.toImage())
            .title(title: "Short title, 2 lines max")
            .message(message: "Try to keep the message as short as possible. 2 lines is the best!")
            .buttonTitle(title: "CTA").build()
        
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }
}

// MARK: - Setup UI

private extension BannerCell {
    
    func setupUI() {
        selectionStyle = .none

        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(bannerView)
    }
    
    func setupConstraints() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            bannerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}

private extension BannerCell {
    func setViewData() {
        guard let guardedData = data else { return }
        
        bannerView.setTitle(guardedData.title)
        bannerView.setMessage(guardedData.subtitle)
        bannerView.setPrimaryButtonTitle(guardedData.buttonTitle)
        bannerView.setImage(guardedData.icon)
    }
}
