//
//  DessertDetailController.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/30/24.
//

import Foundation
import UIKit

class MealDetailController: UIViewController {
    
    private enum Section: Int, CaseIterable {
        case header = 0
        case ingredients = 1
        case instructions = 2
        case video = 3
        case source = 4
    }
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.generic)
        tv.register(IngredientCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.MealDetails.ingredientsCell)
        tv.register(MealDetailHeaderCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.MealDetails.headerCell)

        tv.estimatedRowHeight = 100
        tv.backgroundColor = .clear
        tv.separatorColor = .lightGray.withAlphaComponent(0.3)
        
        return tv
    }()
    
    private let meal: Meal
    private let networkManager: NetworkManagerProtocol
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var details: MealDetails?
    
    // MARK: Init -
    
    init(meal: Meal, networkManager: NetworkManagerProtocol) {
        self.meal = meal
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: LifeCycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = Theme.Colors.orange
                
        setupViews()
        fetchDetails()
        updateLayoutForOrientation()
    }
    
    // MARK: UI Methods -
    
    private func setupViews() {
        view.addSubview(mealImageView)
        view.addSubview(tableView)
  
        portraitConstraints.append(contentsOf: [
            mealImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mealImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
                
        landscapeConstraints.append(contentsOf: [
            mealImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mealImageView.widthAnchor.constraint(equalTo: mealImageView.heightAnchor),
            mealImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.5),
            mealImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
                                
        setImageView()
    }
    
    private func setImageView() {
        guard let url = URL(string: meal.imageUrl) else { return }
        
        do {
            try mealImageView.setImage(from: url)
        } catch {
            self.showErrorAlert(error)
        }
    }
    
    private func setTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.removeLoadingIndicator()
            strongSelf.tableView.reloadData()
            strongSelf.tableView.contentInset.top = UIWindow.isLandscape ? .zero : strongSelf.mealImageView.bounds.height * 0.35
            strongSelf.tableView.setContentOffset(CGPoint(x: 0.0, y: -strongSelf.mealImageView.bounds.height), animated: false)
        }
    }
    
    // MARK: Network Requests -
    
    private func fetchDetails() {
        let mealId = meal.id
        
        tableView.showLoadingIndicator()
                
        Task { [weak self] in
            guard let strongSelf = self else { return }

            do {
                strongSelf.details = try await strongSelf.networkManager.fetchMealDetails(for: mealId).first
                strongSelf.setTableView()
               
            } catch {
                strongSelf.showErrorAlert(error, retryAction: { [weak strongSelf] in
                    strongSelf?.fetchDetails()
                }, cancelAction: {
                    strongSelf.tableView.removeLoadingIndicator()
                })
            }
        }
    }
  
    // MARK: Helper Methods -
    
    private func updateLayoutForOrientation() {
        
        if UIWindow.isLandscape {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
            tableView.contentInset.top = .zero
       } else {
           NSLayoutConstraint.deactivate(landscapeConstraints)
           NSLayoutConstraint.activate(portraitConstraints)
           tableView.contentInset.top = mealImageView.bounds.height * 0.35
       }
    }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateLayoutForOrientation()
    }
    
    func openURLInSafari(_ urlString: String) {
        
        guard let url = URL(string: urlString) else {
            self.showErrorAlert(NetworkError.badURL, retryAction: {
                self.openURLInSafari(urlString)
            })
            
            return
        }
        
        guard UIApplication.shared.canOpenURL(url) else {
            self.showErrorAlert(NetworkError.generic, retryAction: {
                self.openURLInSafari(urlString)
            })
            
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
            if !success {
                self.showErrorAlert(NetworkError.generic, retryAction: {
                    self.openURLInSafari(urlString)
                })
            }
        })
    }
}

extension MealDetailController: UITableViewDataSource, UITableViewDelegate {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return details == nil ? 0 : Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let details = details else {
            return 0
        }
        
        switch Section(rawValue: section) {
        case .ingredients:
            return details.ingredients.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.MealDetails.headerCell, for: indexPath) as! MealDetailHeaderCell
            cell.nameLabel.text = meal.name
            return cell
            
        case .ingredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.MealDetails.ingredientsCell, for: indexPath) as! IngredientCell
            cell.ingredient = details?.ingredients[indexPath.row] ?? nil
            
            return cell
        case .instructions, .video, .source:
            return setupGenericCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch Section(rawValue: indexPath.section) {
        case .video:
            guard let videoUrlString = details?.youtubeUrl else { return }
            openURLInSafari(videoUrlString)
            
        case .source:
            guard let sourceUrlString = details?.sourceUrl else { return }
            openURLInSafari(sourceUrlString)
            
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch Section(rawValue: indexPath.section) {
        case .ingredients:
            return max(tableView.bounds.height * 0.08, 68)
        case .header, .instructions, .video, .source:
           return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch Section(rawValue: section) {
        case .ingredients, .instructions:
            
            let header = MealDetailSectionHeader()
            header.label.text = Section(rawValue: section) == .ingredients ? Constants.SectionHeaders.ingredients : Constants.SectionHeaders.instructions
   
            return header
            
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch Section(rawValue: section) {
        case .instructions, .ingredients:
            return max(tableView.bounds.height * 0.058, 70)
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    private func setupGenericCell(for indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.generic, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        var config = cell.defaultContentConfiguration()
        config.textProperties.font = Theme.Fonts.main(size: 16.0, weight: .medium)
        config.textProperties.color = Theme.Colors.text
        
        switch Section(rawValue: indexPath.section) {
        case .instructions:
            
            config.text = details?.instructions
            config.textProperties.numberOfLines = 0
            config.textProperties.lineBreakMode = .byWordWrapping
            
        case .video:
            config.text = Constants.Text.youtubeVideoText
            config.image = UIImage(systemName: "play.square")
            config.imageProperties.tintColor = Theme.Colors.orange
            
        case .source:
            config.text = Constants.Text.sourceText
            config.image = UIImage(systemName: "globe")
            config.imageProperties.tintColor = details?.sourceUrl != nil ? Theme.Colors.orange : .lightGray
            config.textProperties.color = details?.sourceUrl != nil ? Theme.Colors.text : .lightGray
        default: break
        }
        
        cell.contentConfiguration = config
        return cell
    }
}
