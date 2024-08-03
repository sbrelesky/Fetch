//
//  IngredientCell.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/31/24.
//

import Foundation
import UIKit

class IngredientCell: UITableViewCell {
    
    let measurmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Colors.orange
        label.font = Theme.Fonts.main(size: 22.0, weight: .black)
        label.textAlignment = .right
        
        return label
    }()
    
    var ingredient: Ingredient? {
        didSet {
            guard let ingredient = ingredient else { return }
            
            measurmentLabel.text = ingredient.measurement
            setText(ingredient.name)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(measurmentLabel)
        
        NSLayoutConstraint.activate([
            measurmentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            measurmentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setText(_ text: String) {
        var config = defaultContentConfiguration()
        config.textProperties.font = Theme.Fonts.main(size: 18.0, weight: .heavy)
        config.textProperties.color = Theme.Colors.text
        config.textProperties.numberOfLines = 0
        config.text = text
        
        contentConfiguration = config
    }
}
