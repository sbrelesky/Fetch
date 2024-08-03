//
//  ViewController.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/30/24.
//

import UIKit

class MealListController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.delegate = self
        sb.sizeToFit()
        sb.placeholder = Constants.Text.searchPlaceholder
        sb.searchTextField.tintColor = Theme.Colors.orange
        sb.searchTextField.backgroundColor = .white
        sb.searchTextField.font = Theme.Fonts.main(size: 16.0, weight: .book)
        
        return sb
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(MealCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.generic)
        tv.separatorInset.left = 120
        tv.contentInset.top = 20
        
        return tv
    }()
    
    var meals: [Meal] = []
    var filteredMeals: [Meal] = []
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Theme.Colors.orange ?? .orange
        ]
        
        title = Constants.Text.listTitle
        view.backgroundColor = .white
        
        hideKeyboardOnTap()
        setupViews()
        fetchMeals()
    }
    
    // MARK: Setup UI -
    
    private func setupViews() {
        setupSearchBar()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
       ])
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        
        let heightConstraint = searchBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08)
        heightConstraint.priority = .defaultHigh
          
        let minSearchBarHeight = searchBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 68)
        minSearchBarHeight.priority = .required
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightConstraint,
            minSearchBarHeight
        ])
    }
    
    // MARK: Netowrk Requests -
    
    private func fetchMeals() {
        tableView.showLoadingIndicator()
    
        Task {
            do {
                self.meals = try await networkManager.fetchMeals()
                self.filteredMeals = self.meals
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.removeLoadingIndicator()
                    self?.tableView.reloadData()
                }
            } catch {
                self.showErrorAlert(error, retryAction: fetchMeals) {
                    self.tableView.removeLoadingIndicator()
                }
            }
        }
    }
    
    // MARK: Keyboard Handling -
    
    private func hideKeyboardOnTap() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Helper Methods -
    
    private func goToDetails(for meal: Meal) {
        navigationController?.pushViewController(MealDetailController(meal: meal, networkManager: networkManager), animated: true)
    }
}

extension MealListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMeals(for: searchText)
    }

    private func filterMeals(for searchText: String) {
        if searchText.isEmpty {
            filteredMeals = meals
        } else {
            filteredMeals = meals.filter { meal in
                meal.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
}


extension MealListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.generic, for: indexPath) as! MealCell
        cell.meal = filteredMeals[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return max(tableView.bounds.height * 0.13, 110)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetails(for: filteredMeals[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
