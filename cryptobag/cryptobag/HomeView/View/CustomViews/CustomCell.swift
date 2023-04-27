//
//  CustomCell.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 24.04.2023.
//

import Foundation
import UIKit
//import SnapKit


class CustomCell: UITableViewCell {
    lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let viewContainer: [UIView] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 21.0/255.0, green: 44.0/255.0, blue: 7.0/255.0, alpha: 1.0)
        label.font = UIFont(name: "MulishRoman-Bold", size: 16.0)

        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 21.0/255.0, green: 44.0/255.0, blue: 7.0/255.0, alpha: 1.0)
        return label
    }()
    
    private lazy var coinChange1dLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func configure(with model: Ticker){
        self.coinNameLabel.text = model.name
        self.priceLabel.text = "$\(round(model.quotes.first!.value.price * 100) / 100.0)"
    }
    
    private func setUpViews() {
        
        contentView.addSubview(cellView)
        
        let cellSubViews = [coinNameLabel, priceLabel, coinChange1dLabel]
        cellSubViews.forEach { subView in
            cellView.addSubview(subView)
        }
    }
    private func setUpConstraints(){
        
        cellView.snp.makeConstraints{make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(48)
        }
        coinNameLabel.snp.makeConstraints{make in
            make.top.equalTo(cellView.snp.top)
            make.leading.equalTo(cellView.snp.leading).offset(10)
        }
        priceLabel.snp.makeConstraints{make in
            make.top.equalTo(cellView.snp.top)
            make.trailing.equalTo(cellView.snp.trailing).offset(16)
        }
    }
}
