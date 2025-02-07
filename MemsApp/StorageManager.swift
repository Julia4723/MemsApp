//
//  StorageManager.swift
//  MemsApp
//
//  Created by user on 06.02.2025.
//

import UIKit

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let memsKey = "mems"
    
    private init() {}
    
    func fetchMems() -> [Meme] {
        guard let data = userDefaults.data(forKey: memsKey) else { return []}
        guard let mems = try? JSONDecoder().decode([Meme].self, from: data) else { return []}
        print("Загружено мемов: \(mems.count)")
        return mems
    }
    
    func save(mem: Meme) {
        var mems = fetchMems()
        mems.append(mem)
        
        guard let data = try? JSONEncoder().encode(mems) else {return}
        userDefaults.set(data, forKey: memsKey)
    }
    
    func delete(at index: Int) {
        var mems = fetchMems()
        mems.remove(at: index)
        
        guard let data = try? JSONEncoder().encode(mems) else {return}
        userDefaults.set(data, forKey: memsKey)
    }
}
