//
//  ViewController.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import UIKit

import UIKit

class ViewController: UIViewController, CarouselViewControllerDelegate, UIScrollViewDelegate {
    private let scrollView = UIScrollView()
    private let searchInputField = SearchInputField()
    private let mysteryButton = MysteryButton()
    private var carouselViewController: CarouselViewController!
    private var descriptionListViewController: DescriptionListViewController!
    private var bottomSheetViewController: MysteryBottomSheetViewController!
    private var imagesDataArray: [ImageData] = []
    private var currentIndex: Int = 0
    private var searchQuery: String = ""
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        loadImagesData()
        setupScrollView()
        setupStackView()
        setupCarouselView()
        setupSearchInputField()
        setupDescriptionListView()
        setupMysteryButton()
        setupBottomSheetView()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true  // Ensure vertical scrolling

        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
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
        
        // searchInputField.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor).isActive = true
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

        descriptionListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        ])
    }

    private func setupMysteryButton() {
        mysteryButton.layer.cornerRadius = 30
        mysteryButton.onClick = { [weak self] in
            self?.presentBottomSheet()
        }

        mysteryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mysteryButton)

        NSLayoutConstraint.activate([
            mysteryButton.widthAnchor.constraint(equalToConstant: 64),
            mysteryButton.heightAnchor.constraint(equalToConstant: 64),
            mysteryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            mysteryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -52)
        ])
    }

    private func setupBottomSheetView() {
        bottomSheetViewController = MysteryBottomSheetViewController(statistics: calculateStatistics())
    }

    private func presentBottomSheet() {
        guard let bottomSheetViewController = bottomSheetViewController else { return }
        bottomSheetViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = bottomSheetViewController.sheetPresentationController {
            sheet.detents = [.custom { _ in return 300 }]
            sheet.prefersGrabberVisible = true
        }
        
        present(bottomSheetViewController, animated: true, completion: nil)
    }

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
        bottomSheetVC.updateStatistics(updatedStatistics)
    }

    func carouselViewController(_ carouselViewController: CarouselViewController, didScrollToIndex index: Int) {
        currentIndex = index
        descriptionListViewController.currentIndex = index
        descriptionListViewController.tableView.reloadData()
        updateBottomSheetStatistics()
    }

    private func loadImagesData() {
        imagesDataArray = ImageLoader.loadAllImageData(fromDirectory: "SampleImages")
    }
}
