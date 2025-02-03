//
//  MemsModel.swift
//  MemsApp
//
//  Created by user on 03.02.2025.
//

import UIKit

struct Meme: Codable {
    let id: String
    let name: String
    let url: String
    let width: Int
    let height: Int
    let box_count: Int
}

struct DataClass: Codable {
    let memes: [Meme]
}

struct ResponseWrapper: Codable {
    let success: Bool
    let data: DataClass
}


