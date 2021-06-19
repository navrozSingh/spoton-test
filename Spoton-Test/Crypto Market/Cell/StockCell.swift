//
//  StockCell.swift
//  Spoton-Test
//
//  Created by Navroz on 19/06/21.
//

import UIKit

class StockCell: UITableViewCell {
    
    let name: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    let hours: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        mainStack.addArrangedSubview(name)
        mainStack.addArrangedSubview(hours)
        mainStack.addArrangedSubview(price)
        self.contentView.addSubview(mainStack)
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    
    func configureCell(stock: Stock?) {
        name.text = stock?.name
        hours.text = Descriptor.getPercentage(amount: stock?.changePercent24Hr ?? "")
        price.text = Descriptor.currency(amount: stock?.priceUsd ?? "")
        
        if hours.text?.contains("-") ?? false {
            hours.textColor = .red
            price.textColor = .red
        } else {
            hours.textColor = .green
            price.textColor = .green
        }
    }
}

class Descriptor {
    
    static func currency(amount: String) -> String {
        guard let doubleAmount = Double(amount)
        else {
            return ""
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        return currencyFormatter.string(from: NSNumber(value: doubleAmount)) ?? ""
    }
    
    static func getPercentage(amount: String) -> String {
        guard let doubleAmount = Double(amount)
        else {
            return ""
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: doubleAmount)) ?? ""
    }
    
}
