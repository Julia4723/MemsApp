//
//  CustomView.swift
//  MemsApp
//
//  Created by user on 07.02.2025.
//

import UIKit
import Alamofire

final class CustomView: UIView {
    private let nameLabel = UILabel.makeLabel(font: .systemFont(ofSize: 16, weight: .regular), textColor: .black)
    private let imageView = UIImageView()
    private let storageManager = StorageManager.shared

    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func configure(model: Meme) {
        nameLabel.text = model.name

        if let url = URL(string: model.url) {
            let placeholder = UIImage(systemName: "photo") // Замените на свой placeholder
            imageView.af.setImage(withURL: url, placeholderImage: placeholder)
        } else {
            imageView.image = UIImage(systemName: "photo") // Если URL некорректный, показываем заглушку
        }
    }
}

private extension CustomView {
    func setup() {
        addSubviews()
        setupImage()
        setupLayout()
    }
    
    func addSubviews() {
        [nameLabel, imageView].forEach { view in
            addSubview(view)
        }
    }
}

private extension CustomView {
    
    func setupImage() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
    }
}


private extension CustomView {
    func setupLayout() {
        [nameLabel, imageView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 140),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            
        ])
    }
}
