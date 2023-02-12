//
//  SettingsController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/7/23.
//

import UIKit

private let reuseId = "reuseId"

protocol SettingsControllerDelegate: AnyObject {
    //standard naming convention: name of the file, access to the file, and what it wants to do
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User)
}

class SettingsController: UITableViewController {
    
    //MARK: - Properties
    private var user: User
    
    private var imageIndex = 0
    
    weak var delegate: SettingsControllerDelegate?
    
    private lazy var headerView: SettingsHeader = {
        let header = SettingsHeader()
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        header.delegate = self
        return header
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
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
    
    private func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
     
    //MARK: - Selectors
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleDone() {
        print("DEBUG: Handle did tap done..")
        view.endEditing(true)
        delegate?.settingsController(self, wantsToUpdate: user)
    }
}

//MARK: - TableView DataSource/Delegate methods

extension SettingsController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! SettingsCell
        cell.delegate = self
        guard let section = SettingsSections(rawValue: indexPath.section) else { return cell}
        cell.viewModel = SettingsViewModel(user: user, section: section)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    //Used to dynamically set tableView row heights to tell it which row you want to modify, when you do tableView.rowHeight sets the height for the rows universally
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //lets use know which SettingsSection we are one
        guard let section = SettingsSections(rawValue: indexPath.section) else { return 0}
        //if the section is AgeRange then return a heigh of 96 otherwise return 44
        return section == .AgeRange ? 96: 44
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSections(rawValue: section) else { return nil }
        return section.description
    }
}

//MARK: - SettingsHeaderDelegate

extension SettingsController: SettingsHeaderDelegate {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int) {
        print("Selected button is \(index)")
        self.imageIndex = index
        present(imagePicker, animated: true)
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        //update button photo
        setHeaderImage(selectedImage)
        
        dismiss(animated: true)
    }
}

//MARK: - SettingsCellDelegate

extension SettingsController: SettingsCellDelegate {
    func settingsCell(_ cell: SettingsCell, wantsToUpdateAgeRangeWith sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String, forSection section: SettingsSections) {
        switch section {
        case .Name:
            user.name = value
        case .Profession:
            user.profession = value
        case .Age:
            user.age = Int(value) ?? 18
        case .Bio:
            user.bio = value
        case .AgeRange:
            //need a seperate function to update this
            break
        }
        
        print("DEBUG: User is \(user)")
    }
    
}
