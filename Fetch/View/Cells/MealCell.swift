//
//  MealCell.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/31/24.
//

import Foundation
import UIKit

class MealCell: UITableViewCell {

    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Theme.Colors.text
        label.font = Theme.Fonts.main(size: 20.0, weight: .heavy)
        
        return label
    }()
    
    var meal: Meal? {
        didSet {
            guard let meal = meal else { return }
            
            nameLabel.text = meal.name
            guard let url = URL(string: meal.imageUrl) else { return }
            try? mealImageView.setImage(from: url)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let selectedBackground = UIView()
        selectedBackground.backgroundColor = Theme.Colors.orange
        selectedBackgroundView = selectedBackground
        accessoryType = .disclosureIndicator
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(mealImageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mealImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            mealImageView.widthAnchor.constraint(equalTo: mealImageView.heightAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mealImageView.image = nil
    }
}

