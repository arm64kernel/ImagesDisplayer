//
//  MysteryBottomSheetView.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import Foundation

import UIKit

class MysteryBottomSheetViewController: UIViewController {
    private let statistics: (itemCount: Int, topCharacters: [(character: Character, count: Int)])
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Useful Information"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(statistics: (itemCount: Int, topCharacters: [(character: Character, count: Int)])) {
        self.statistics = statistics
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        setupView()
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(statsLabel)
        
        let statsText = "This list consists of \(statistics.itemCount) item(s)\n" +
            statistics.topCharacters.map { "The occurrence of: '\($0.character)' is \($0.count)" }.joined(separator: "\n")
        statsLabel.text = statsText
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
