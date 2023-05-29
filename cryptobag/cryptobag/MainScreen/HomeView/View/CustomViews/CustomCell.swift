//
//  CustomCell.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 24.04.2023.
//

import Foundation
import UIKit
//import SnapKit


class CustomCell: UICollectionViewCell {
    lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let viewContainer: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 93.0/255.0, green: 92.0/255.0, blue: 93.0/255.0, alpha: 1.0)
        label.font = UIFont(name: "MulishRoman-Regular", size: 16.0)
        
        return label
    }()
    
    private lazy var coinSymbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 21.0/255.0, green: 44.0/255.0, blue: 7.0/255.0, alpha: 1.0)
        label.font = UIFont(name: "MulishRoman-Bold", size: 20.0)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 21.0/255.0, green: 44.0/255.0, blue: 7.0/255.0, alpha: 1.0)
        label.font = UIFont(name: "MulishRoman-Bold", size: 16.0)

        return label
    }()
    
    private lazy var coinChange1dLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var imageContainer: UIView = {
        let imageview = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        imageview.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        imageview.layer.cornerRadius = 10
        imageview.addSubview(image)
        return imageview
    }()
    func configure(with model: Ticker){
        self.coinNameLabel.text = model.name
        self.coinSymbolLabel.text = "\(model.symbol)/USDT"
        self.priceLabel.text = "$\(round(model.quotes.first!.value.price * 100) / 100.0)"
    }
    
    private func setUpViews() {
        
        contentView.addSubview(cellView)
        cellView.layer.cornerRadius = 10
        let cellSubViews = [coinNameLabel, priceLabel, coinChange1dLabel, imageContainer, coinSymbolLabel]
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
        }
        imageContainer.snp.makeConstraints{make in
            make.top.equalTo(cellView.snp.top).offset(12)
            make.left.equalTo(cellView.snp.left).offset(16)
            imageContainer.snp.makeConstraints { make in
                make.width.equalTo(64)
                make.height.equalTo(64)
            }
        }
        coinSymbolLabel.snp.makeConstraints{make in
            make.top.equalTo(cellView.snp.top).offset(16)
            make.left.equalTo(imageContainer.snp.right).offset(16)
        }
        coinNameLabel.snp.makeConstraints{make in
            make.top.equalTo(coinSymbolLabel.snp.bottom).offset(4)
            make.left.equalTo(imageContainer.snp.right).offset(16)
        }
        priceLabel.snp.makeConstraints{make in
            make.top.equalTo(cellView.snp.top).offset(18)
            make.right.equalTo(cellView.snp.right).offset(-16)
        }
        image.snp.makeConstraints{make in
            make.center.equalTo(imageContainer.snp.center)
            make.top.equalTo(imageContainer.snp.top).offset(10)
            make.left.equalTo(imageContainer.snp.left).offset(10)
            make.right.equalTo(imageContainer.snp.right).offset(-10)
            make.bottom.equalTo(imageContainer.snp.bottom).offset(-10)

        }
    }
}
