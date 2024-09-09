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
        setupBottomSheetView()  // Prepare the bottom sheet
    }

    // MARK: - Setup Methods

    // 1. Setting up the main UIStackView
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

    // 2. Search Input Field Setup
    private func setupSearchInputField() {
        searchInputField.onTextChanged = { [weak self] query in
            self?.searchQuery = query
            self?.descriptionListViewController.searchQuery = query
            self?.descriptionListViewController.tableView.reloadData()
        }

        searchInputField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.addArrangedSubview(searchInputField)
    }

    // 3. Carousel View Setup
    private func setupCarouselView() {
        let imageArray = imagesDataArray.map { $0.image }
        carouselViewController = CarouselViewController(images: imageArray)
        carouselViewController.delegate = self

        addChild(carouselViewController)
        stackView.addArrangedSubview(carouselViewController.view)
        carouselViewController.didMove(toParent: self)

        carouselViewController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    // 4. Description List View Setup
    private func setupDescriptionListView() {
        descriptionListViewController = DescriptionListViewController()
        descriptionListViewController.imageDataArray = imagesDataArray
        descriptionListViewController.currentIndex = currentIndex
        descriptionListViewController.searchQuery = searchQuery

        addChild(descriptionListViewController)
        stackView.addArrangedSubview(descriptionListViewController.view)
        descriptionListViewController.didMove(toParent: self)
    }

    // 5. Mystery Button Setup (Floating Button)
    private func setupMysteryButton() {
        mysteryButton.layer.cornerRadius = 30
        mysteryButton.onClick = { [weak self] in
            self?.presentBottomSheet()
        }

        mysteryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mysteryButton)

        // Positioning the mystery button as a floating button
        NSLayoutConstraint.activate([
            mysteryButton.widthAnchor.constraint(equalToConstant: 64),
            mysteryButton.heightAnchor.constraint(equalToConstant: 64),
            mysteryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            mysteryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -52)
        ])
    }

    private func setupBottomSheetView() {
        // Initialize the bottom sheet view controller without statistics
        bottomSheetViewController = MysteryBottomSheetViewController(statistics: calculateStatistics())
    }

    // 7. Present Bottom Sheet
    private func presentBottomSheet() {
        guard let bottomSheetViewController = bottomSheetViewController else { return }
        bottomSheetViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = bottomSheetViewController.sheetPresentationController {
            sheet.detents = [.custom { _ in return 300 }]  // Set height to 300 points
            sheet.prefersGrabberVisible = true  // Enable grabber
        }
        
        present(bottomSheetViewController, animated: true, completion: nil)
    }

    // Function to calculate the statistics
    private func calculateStatistics() -> (itemCount: Int, topCharacters: [(character: Character, count: Int)]) {
        guard let currentPageData = imagesDataArray[safe: currentIndex] else {
            return (0, [])
        }

        let description: [[String: String]] = currentPageData.description
        let itemCount = description.count

        let concatenatedStrings = description.compactMap { $0.values.joined() }.joined()

        let characterCounts = concatenatedStrings.reduce(into: [:]) { counts, character in
            counts[character, default: 0] += 1
        }

        let topCharacters = characterCounts
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { ($0.key, $0.value) }

        return (itemCount, topCharacters)
    }

    private func updateBottomSheetStatistics() {
        guard let bottomSheetVC = bottomSheetViewController else { return }
        let updatedStatistics = calculateStatistics()
        bottomSheetVC.updateStatistics(updatedStatistics)  // Ensure this method is implemented in MysteryBottomSheetViewController
    }

    // MARK: - CarouselViewControllerDelegate
    func carouselViewController(_ carouselViewController: CarouselViewController, didScrollToIndex index: Int) {
        currentIndex = index
        descriptionListViewController.currentIndex = index
        descriptionListViewController.tableView.reloadData()

        // Update bottom sheet statistics
        updateBottomSheetStatistics()
    }

    // MARK: - Dummy Data Loading
    private func loadImagesData() {
        imagesDataArray = ImageLoader.loadAllImageData(fromDirectory: "SampleImages")
    }
}
