//
//  EndOfResultsCell.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 21/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

class EndOfResultsCell: NoResultsCell {
    
    override func setupUI() {
        roundedBackgroundView.addSubview(bodyLabel)
        roundedBackgroundView.addSubview(subscribeToWorkOnDayButton)
        contentView.addSubview(roundedBackgroundView)
        selectionStyle = .none
    }
    
    override func setupConstraints() {
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribeToWorkOnDayButton.translatesAutoresizingMaskIntoConstraints = false
        roundedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roundedBackgroundView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 40),
            roundedBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            roundedBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            roundedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            bodyLabel.topAnchor.constraint(equalTo: roundedBackgroundView.topAnchor, constant: 24),
            bodyLabel.heightAnchor.constraint(equalToConstant: 44),
            bodyLabel.leftAnchor.constraint(equalTo: roundedBackgroundView.leftAnchor, constant: 16),
            bodyLabel.rightAnchor.constraint(equalTo: roundedBackgroundView.rightAnchor, constant: -16),
                        
            subscribeToWorkOnDayButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            subscribeToWorkOnDayButton.heightAnchor.constraint(equalToConstant: 22),
            
            subscribeToWorkOnDayButton.bottomAnchor.constraint(equalTo: roundedBackgroundView.bottomAnchor, constant: -22),
            subscribeToWorkOnDayButton.leftAnchor.constraint(equalTo: roundedBackgroundView.leftAnchor, constant: 16),
            subscribeToWorkOnDayButton.rightAnchor.constraint(equalTo: roundedBackgroundView.rightAnchor, constant: -16)
        ])
    }
}
