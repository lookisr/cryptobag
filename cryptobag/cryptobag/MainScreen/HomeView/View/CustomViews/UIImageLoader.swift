//
//  UIImageLoader.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 28.04.2023.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(from source: String?, placeholder: UIImage?) {
        guard let urlString = source, let url = URL(string: urlString) else { return }
        
        kf.setImage(with: .network(url), placeholder: placeholder)
    }
}
