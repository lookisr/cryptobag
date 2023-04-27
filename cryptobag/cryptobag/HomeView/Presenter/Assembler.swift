//
//  Assembler.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 24.04.2023.
//

import Foundation
import UIKit


class MainModuleAssembly {
    class func configureModule() -> UIViewController {
        let dataModule = DataModel()
        let presenter = MainPresenter(dataService: dataModule)
        let view = MainViewController(presenter: presenter)
        view.presenter = presenter
        presenter.mainView = view
        return view
    }
}
