//
//  SettingsController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/7/23.
//

import UIKit

private let reuseId = "reuseId"

class SettingsController: UITableViewController {
    
    //MARK: - Properties
    
    private lazy var headerView: SettingsHeader = {
        let header = SettingsHeader()
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        return header
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Settings"
        let nav = navigationController?.navigationBar
        nav?.prefersLargeTitles = true
        nav?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    //MARK: - Selectors
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleDone() {
        print("DEBUG: Handle did tap done..")
    }
}

//MARK: - TableView DataSource/Delegate methods

extension SettingsController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
