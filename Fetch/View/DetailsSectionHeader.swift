//
//  DetailsSectionHeader.swift
//  Fetch
//
//  Created by Shane Brelesky on 8/2/24.
//

import Foundation
import UIKit

class MealDetailSectionHeader: UIView {
    
    let label: UILabel = {
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.Fonts.main(size: 26.0, weight: .black)
        l.textColor = Theme.Colors.purple
        
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
