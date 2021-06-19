//
//  StockModal.swift
//  Spoton-Test
//
//  Created by Navroz on 19/06/21.
//

import Foundation

// MARK: - Stock
struct Stock: Codable {
    let id, rank, symbol, name: String?
    let supply, maxSupply, marketCapUsd, volumeUsd24Hr: String?
    let priceUsd, changePercent24Hr, vwap24Hr: String?
    let explorer: String?
}


struct StockContainer: Codable {
    let data: [Stock]
    let timestamp: Int?
}
