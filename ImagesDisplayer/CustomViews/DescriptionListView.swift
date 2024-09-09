//
//  DescriptionListView.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import Foundation

import UIKit

class DescriptionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var imageDataArray: [ImageData] = []
    var currentIndex: Int = 0
    var searchQuery: String = ""
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard currentIndex < imageDataArray.count else { return 0 }
        return filteredDescriptions(from: imageDataArray[currentIndex].description).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DescriptionCell")
        if let currentData = imageDataArray[safe: currentIndex] {
            let descriptions = filteredDescriptions(from: currentData.description)
            let description = descriptions[indexPath.row]
            cell.imageView?.image = currentData.image
            cell.textLabel?.text = description.keys.joined(separator: ", ")
            cell.detailTextLabel?.text = description.values.joined(separator: ", ")
        }
        return cell
    }
    
    private func filteredDescriptions(from descriptions: [[String: String]]) -> [[String: String]] {
        guard !searchQuery.isEmpty else {
            return descriptions
        }
        
        return descriptions.filter { description in
            description.values.contains { value in
                value.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}
