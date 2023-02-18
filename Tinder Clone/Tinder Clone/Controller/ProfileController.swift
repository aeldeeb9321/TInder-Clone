//
//  ProfileController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/15/23.
//

import UIKit

private let reuseIdentifier = "reuse Id"

protocol ProfileControllerDelegate: AnyObject {
   
}

class ProfileController: UIViewController {
    
    //MARK: - Properties
    
    private let user: User
    
    private lazy var viewModel = ProfileViewModel(user: user)
    
    weak var delegate: ProfileControllerDelegate?
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let effect = UIVisualEffectView(effect: blur)
        return effect
    }()
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.isPagingEnabled = true
        return cv
    }()
    
    private lazy var barStackView: SegmentedBarView = {
        let stack = SegmentedBarView(numberOfSegments: viewModel.imageURLs.count)
        stack.setDimensions(height: 4)
        return stack
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton().makeButton(withImage: UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal))
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.setDimensions(height: 44, width: 44)
        return button
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .label, withFont: UIFont.boldSystemFont(ofSize: 20))
        label.attributedText = viewModel.userDetailsAttributedString
        return label
    }()
    
    private lazy var professionLabel: UILabel = {
        let label = UILabel().makebodyLabel(withText: viewModel.profession)
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel().makebodyLabel(withText: viewModel.bio)
        return label
    }()
    
    private lazy var dislikeButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "dismiss_circle"))
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        return button
    }()
    
    private lazy var superLikeButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "super_like_circle"))
        button.addTarget(self, action: #selector(handleSuperLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "like_circle"))
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBarStackView()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: collectionView.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: -20, paddingTrailing: 16)
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel, professionLabel, bioLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 5
        
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 12, paddingLeading: 12, paddingTrailing: 12)
        
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        configureBottomControls()
    }
    
    private func configureBottomControls() {
        let stack = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stack.distribution = .fillEqually
        stack.spacing = -32
        stack.setDimensions(height: 80, width: 300)

        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
    }

    private func configureBarStackView() {
        view.addSubview(barStackView)
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingTrailing: 8)
    }
    
    //MARK: - Selectors
    
    @objc private func handleDismissal() {
        dismiss(animated: true)
    }
    
    @objc private func handleDislike() {
        
    }
    
    @objc private func handleSuperLike() {
        
    }
    
    @objc private func handleLike() {
        
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        Service.shared.fetchImageData(imageUrl: viewModel.imageURLs[indexPath.item]) { result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: imageData)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlighted(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
