//
//  SavedViewController.swift
//  MemsApp
//
//  Created by user on 07.02.2025.
//

import UIKit
import Alamofire

class SavedViewController: UIViewController {
    
    private let tableView = UITableView()
    private var savedMems: [Meme] = []
    private let cellIdentifier = "Mem"
    private let storageManager = StorageManager.shared
    
    
    init(newMems: [Meme]) {
        self.savedMems = newMems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        savedMems = storageManager.fetchMems()
        setupTableView()
        
        tableView.reloadData()
    }
}


extension SavedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedMems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomCell else { return UITableViewCell()}
        
        let mem = savedMems[indexPath.row]
        cell.configure(model: mem)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedMems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.delete(at: indexPath.row)
        }
    }
}


extension SavedViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


extension SavedViewController: ViewControllerDelegate {
    func add(mem: Meme) {
        savedMems.append(mem)
        print("Add mem \(mem.name)")
        tableView.reloadData()
    }
}
