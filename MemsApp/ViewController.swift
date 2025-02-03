//
//  ViewController.swift
//  MemsApp
//
//  Created by user on 03.02.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    private var dataModel: [Meme]?
    
    private let textField = UITextField()
    private let button = UIButton()
    private let image = UIImageView()
    private let buttonLike = UIButton()
    private let buttonUnlike = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    
        view.backgroundColor = .white
        fetchMems()
    }
    
    func fetchMems() {
        networkManager.fetchAF { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print("Success: \(success)")
                    self?.dataModel = success
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }


}

private extension ViewController {
    func setupView() {
        addSubviews()
        setupTextField()
        setupButton()
        setupImage()
        setupButtonLike()
        setupButtonUnlike()
        setupLayout()
    }
    
    func addSubviews() {
        [textField, button, image, buttonLike, buttonUnlike].forEach {
            view.addSubview($0)
        }
    }
    
    func setupTextField() {
        textField.backgroundColor = .systemGray
        textField.textColor = .black
        textField.layer.cornerRadius = 12
    }
    
    func setupButton() {
        button.backgroundColor = .systemBlue
        button.setTitle("Проверить", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 12
    }
    
    func setupImage() {
        image.heightAnchor.constraint(equalToConstant: 300).isActive = true
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.contentMode = .scaleAspectFill
    }
    
    func setupButtonLike() {
        buttonLike.backgroundColor = .systemYellow
        buttonLike.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        buttonLike.widthAnchor.constraint(equalToConstant: 60).isActive = true
        buttonLike.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupButtonUnlike() {
        buttonUnlike.backgroundColor = .systemYellow
        buttonUnlike.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
        buttonUnlike.widthAnchor.constraint(equalToConstant: 60).isActive = true
        buttonUnlike.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}


private extension ViewController {
    func setupLayout() {
        [textField, button, image, buttonLike, buttonUnlike].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            textField.heightAnchor.constraint(equalToConstant: 52),
            
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            button.heightAnchor.constraint(equalToConstant: 52),
            
            image.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonLike.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            buttonLike.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            buttonUnlike.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            buttonUnlike.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
        ])
    }
}
