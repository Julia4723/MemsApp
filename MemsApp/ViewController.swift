//
//  ViewController.swift
//  MemsApp
//
//  Created by user on 03.02.2025.
//

import UIKit
import AlamofireImage

protocol ViewControllerDelegate: AnyObject {
    func add(mem: Meme, text: String)
    
}

final class ViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    private var dataModel: [Meme] = []
    private var textModel: [String] = []
    private let storageManager = StorageManager.shared
    
    private let textFieldView = UITextField()
    private let button = UIButton()
    private let image = UIImageView()
    private let buttonLike = UIButton()
    private let buttonUnlike = UIButton()
    private let stackView = UIStackView()
    private let infoMessage = UILabel()
    private var currentMem: Meme!
    private var currentText = String()
    
    weak var delegate: ViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        textFieldView.delegate = self
        view.backgroundColor = .white
    }
    
    
    
    func fetchMems() {
        networkManager.fetchAF { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let mem):
                    print("Success: \(mem)")
                    self?.dataModel = mem
                    self?.configure(with: mem)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func configure(with models: [Meme]) {
        guard let randomElement = models.randomElement(),
              let imageURL = URL(string: randomElement.url) else {
            print("Return nil")
            return
        }
        
        image.af.setImage(withURL: imageURL)
        currentMem = randomElement
        print("SetImage")
    }
    
    
    
    @objc func buttonTapped() {
        let text = textFieldView.text ?? ""
        if text.isEmpty {
            infoMessage.isHidden = false
            image.image = UIImage(systemName: "xmark")
        } else {
            textFieldView.resignFirstResponder()
            fetchMems()
        }
    }
    
    @objc func buttonLikeTapped() {
        guard let meme = currentMem else {
            print("no mem")
            return
        }
        guard let text = textFieldView.text, !text.isEmpty else {
            infoMessage.isHidden = false
            image.image = UIImage(systemName: "xmark")
            return
        }
        
        storageManager.save(mem: meme, text: currentText)
        print("Saved mem")
        
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textFieldView.text ?? ""
        if !text.isEmpty {
            infoMessage.isHidden = true
        }
        currentText = text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldView.resignFirstResponder()
        return true
    }
    
}

private extension ViewController {
    func setupView() {
        addSubviews()
        setupNavigationBar()
        setupTextField()
        setupButton()
        setupImage()
        setupButtonLike()
        setupButtonUnlike()
        setupInfoLabel()
        setupStackView()
        setupLayout()
    }
    
    func addSubviews() {
        [textFieldView, button, image, buttonLike, buttonUnlike, infoMessage, stackView].forEach {
            view.addSubview($0)
        }
    }
    
    @objc func doneButtonTapped() {
        
        let savedVC = SavedViewController(newMems: storageManager.fetchMems())
        navigationController?.pushViewController(savedVC, animated: true)
        print("Done button tapped")
    }
    
    func setupNavigationBar() {
        navigationItem.title = "View Controller"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
    }
    
    func setupInfoLabel() {
        infoMessage.text = "Введите текст"
        infoMessage.font = .systemFont(ofSize: 14)
        infoMessage.textColor = .black
        infoMessage.isHidden = true
    }
    
    func setupTextField() {
        textFieldView.backgroundColor = .systemGray4
        textFieldView.textColor = .black
        textFieldView.layer.cornerRadius = 12
    }
    
    func setupButton() {
        button.backgroundColor = .systemBlue
        button.setTitle("Получить предсказание", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupImage() {
        image.heightAnchor.constraint(equalToConstant: 300).isActive = true
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.contentMode = .scaleAspectFill
    }
    
    func setupButtonLike() {
        buttonLike.backgroundColor = .systemGreen
        buttonLike.setTitle("👍🏻", for: .normal)
        buttonLike.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        buttonLike.layer.cornerRadius = 12
        
        buttonLike.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonLike.heightAnchor.constraint(equalToConstant: 100).isActive = true
        buttonLike.addTarget(self, action: #selector(buttonLikeTapped), for: .touchUpInside)
    }
    
    func setupButtonUnlike() {
        buttonUnlike.backgroundColor = .systemRed
        buttonUnlike.setTitle("👎🏻", for: .normal)
        buttonUnlike.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        buttonUnlike.layer.cornerRadius = 12
        
        buttonUnlike.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonUnlike.heightAnchor.constraint(equalToConstant: 100).isActive = true
        buttonUnlike.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupStackView() {
        stackView.addArrangedSubview(buttonLike)
        stackView.addArrangedSubview(buttonUnlike)
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 24
        
    }
}


private extension ViewController {
    func setupLayout() {
        [textFieldView, button, image, buttonLike, buttonUnlike, infoMessage, stackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            textFieldView.heightAnchor.constraint(equalToConstant: 52),
            
            infoMessage.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 4),
            infoMessage.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 2),
            infoMessage.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -2),
            
            button.topAnchor.constraint(equalTo: infoMessage.bottomAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            button.heightAnchor.constraint(equalToConstant: 52),
            
            image.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            
        ])
    }
}
