//
//  MealHeaderCell.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/31/24.
//

import Foundation
import UIKit

class MealDetailHeaderCell: UITableViewCell {
    
    let card: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 20.0
        v.layer.borderWidth = 2
        v.layer.borderColor = Theme.Colors.orange?.cgColor
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.2
        v.layer.shadowRadius = 6.0
        v.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        
        return v
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Theme.Colors.orange
        label.font = Theme.Fonts.main(size: 26.0, weight: .black)
        label.textAlignment = .center
        
        return label
    }()
    
    private let mealTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = Theme.Fonts.main(size: 14.0, weight: .medium)
        label.text = "Dessert"
        
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(card)
        card.addSubview(nameLabel)
        card.addSubview(mealTypeLabel)
        
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: topAnchor),
            card.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            card.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            card.bottomAnchor.constraint(equalTo: bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.9),
            
            mealTypeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            mealTypeLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            mealTypeLabel.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -20),
        ])
    }
}

