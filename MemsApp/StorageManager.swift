//
//  StorageManager.swift
//  MemsApp
//
//  Created by user on 06.02.2025.
//

import UIKit

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let memsKey = "mems"
    private let textKey = "text"
    
    private init() {}
    
    func fetchMems() -> [Meme] {
        guard let data = userDefaults.data(forKey: memsKey) else { return []}
        guard let mems = try? JSONDecoder().decode([Meme].self, from: data) else { return []}
        print("Загружено мемов: \(mems.count)")
        return mems
    }
    
    func fetchText() -> [String] {
        guard let data = userDefaults.data(forKey: textKey) else { return []}
        guard let text = try? JSONDecoder().decode([String].self, from: data) else { return []}
        print("Загружено text: \(text.count)")
        return text
    }
    
    func save(mem: Meme, text: String) {
        var mems = fetchMems()
        mems.append(mem)
        
        var texts = fetchText()
        texts.append(text)
        
        guard let data = try? JSONEncoder().encode(mems) else {return}
        userDefaults.set(data, forKey: memsKey)
        
        guard let data = try? JSONEncoder().encode(texts) else {return}
        userDefaults.set(data, forKey: textKey)
    }
    
    func delete(at index: Int) {
        var mems = fetchMems()
        mems.remove(at: index)
        
        guard let data = try? JSONEncoder().encode(mems) else {return}
        userDefaults.set(data, forKey: memsKey)
    }
}
