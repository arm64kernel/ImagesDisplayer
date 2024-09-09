//
//  ViewController.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import UIKit

class ViewController: UIViewController, CarouselViewControllerDelegate {

    // MARK: - Properties
    private let searchInputField = SearchInputField()
    private let mysteryButton = MysteryButton()
    private var carouselViewController: CarouselViewController!
    private var descriptionListViewController: DescriptionListViewController!
    private var bottomSheetViewController: MysteryBottomSheetViewController!

    // Dummy data for demonstration
    private var imagesDataArray: [ImageData] = []
    private var currentIndex: Int = 0
    private var searchQuery: String = ""

    // Main vertical stack view to hold everything
    private let stackView = UIStackView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        
        loadImagesData()

        setupStackView()
        setupCarouselView()
        setupSearchInputField()
        setupDescriptionListView()
        setupMysteryButton()
        setupBottomSheetView()
    }

    // MARK: - Setup Methods
    private func setupStackView() {
        // Configure stack view properties
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupSearchInputField() {
        searchInputField.onTextChanged = { [weak self] query in
            self?.searchQuery = query
            self?.descriptionListViewController.searchQuery = query
            self?.descriptionListViewController.tableView.reloadData()
        }

        searchInputField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.addArrangedSubview(searchInputField)
    }

    private func setupCarouselView() {
        let imageArray = imagesDataArray.map { $0.image }
        carouselViewController = CarouselViewController(images: imageArray)
        carouselViewController.delegate = self

        addChild(carouselViewController)
        stackView.addArrangedSubview(carouselViewController.view)
        carouselViewController.didMove(toParent: self)

        carouselViewController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    private func setupDescriptionListView() {
        descriptionListViewController = DescriptionListViewController()
        descriptionListViewController.imageDataArray = imagesDataArray
        descriptionListViewController.currentIndex = currentIndex
        descriptionListViewController.searchQuery = searchQuery

        addChild(descriptionListViewController)
        stackView.addArrangedSubview(descriptionListViewController.view)
        descriptionListViewController.didMove(toParent: self)
    }

    private func setupMysteryButton() {
        mysteryButton.layer.cornerRadius = 30
        mysteryButton.onClick = { [weak self] in
            self?.presentBottomSheet()
        }

        mysteryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mysteryButton)

        // Floating button positioned manually (not in stack view)
        NSLayoutConstraint.activate([
            mysteryButton.widthAnchor.constraint(equalToConstant: 64),
            mysteryButton.heightAnchor.constraint(equalToConstant: 64),
            mysteryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            mysteryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -52)
        ])
    }

    private func setupBottomSheetView() {

    }

    private func presentBottomSheet() {
        guard let bottomSheetViewController = bottomSheetViewController else { return }
        bottomSheetViewController.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheetViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(bottomSheetViewController, animated: true, completion: nil)
    }

    // MARK: - CarouselViewControllerDelegate
    func carouselViewController(_ carouselViewController: CarouselViewController, didScrollToIndex index: Int) {
        currentIndex = index
        descriptionListViewController.currentIndex = index
        descriptionListViewController.tableView.reloadData()  // Reload the list
    }

    // MARK: - Dummy Data Loading
    private func loadImagesData() {
        imagesDataArray = ImageLoader.loadAllImageData(fromDirectory: "SampleImages")
    }
}

