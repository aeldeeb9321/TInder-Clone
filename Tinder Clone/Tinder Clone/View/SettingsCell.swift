//
//  SettingsCell.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/9/23.
//

import UIKit

protocol SettingsCellDelegate: AnyObject {
    func settingsCell(_cell: SettingsCell, wantsToUpdateUserWith value: String, forSection section: SettingsSections)
}

class SettingsCell: UITableViewCell {
    
    //MARK: - Properties
    weak var delegate: SettingsCellDelegate?
    
    var viewModel: SettingsViewModel? {
        didSet {
            configureProperties()
        }
    }
    
    private lazy var inputField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "", isSecureField: false)
        tf.addTarget(self, action: #selector(handleUpdateUserInput), for: .editingDidEnd)
        return tf
    }()
    
    private let minAgeLabel: UILabel = {
        let label = UILabel().makebodyLabel(withText: "Min: 18")
        return label
    }()
    
    private let maxAgeLabel: UILabel = {
        let label = UILabel().makebodyLabel(withText: "Max: 60")
        return label
    }()
    
    private lazy var minAgeSlider = createAgeRangeSlider()
    private lazy var maxAgeSlider = createAgeRangeSlider()
    
    private var sliderStack = UIStackView()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureCellUI() {
        backgroundColor = .white
        addSubview(inputField)
        inputField.fillSuperView(inView: self)
        
        let minStack = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
        minStack.spacing = 24
        
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
        maxStack.spacing = 24
        
        sliderStack = UIStackView(arrangedSubviews: [minStack, maxStack])
        sliderStack.axis = .vertical
        sliderStack.distribution = .fillEqually
        sliderStack.spacing = 16
        
        addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingLeading: 24, paddingTrailing: 24)
        
    }
    
    private func createAgeRangeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(handleAgeRangeChanged), for: .valueChanged)
        return slider
    }
    
    private func configureProperties() {
        guard let viewModel = viewModel else { return }
        sliderStack.isHidden = viewModel.shouldHideSlider
        inputField.isHidden = viewModel.shouldHideInputField
        inputField.placeholder = viewModel.placeHolderText
        inputField.text = viewModel.value
    }
    
    //MARK: - Selectors
    
    @objc private func handleAgeRangeChanged(sender: UISlider) {
        
    }
    
    @objc private func handleUpdateUserInput(sender: UITextField) {
        print("DEBUG: Update user info here..")
        guard let value = sender.text, let viewModel = viewModel else { return }
        delegate?.settingsCell(_cell: self, wantsToUpdateUserWith: value, forSection: viewModel.section)
    }
}
