//
//  MysteryButton.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import Foundation
import UIKit

class MysteryButton: UIButton {
    var onClick: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setImage(UIImage(systemName: "questionmark.diamond"), for: .normal)
        imageView?.tintColor = .white
        backgroundColor = .blue
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        onClick?()
    }
}
