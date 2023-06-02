//
//  TokenListPresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 01.06.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol ListPresenterProtocol {
    var tickers: [Ticker] {get}
    var listView: ListViewController? {get set}
    func loadView()
    func search(for query: String)
    func cancelSearch()
    func model(for indexPath: Int) -> Ticker
    func getImageForCoin(id: String, indexPath: IndexPath)
    func openCell(with ticker: Ticker)
}


class ListPresenter: ListPresenterProtocol {
    var originalTickers: [Ticker]?
    func search(for query: String) {
        let filteredTickers = tickers.filter { $0.name.lowercased().contains(query.lowercased()) }
        self.tickers = filteredTickers
        listView?.updateView()
    }
    
    func cancelSearch() {
        self.tickers = originalTickers!
        listView?.updateView()
    }
    
    
    private let dataService: DataModel
    var router: MainRouterProtocol?
    var tickers: [Ticker] = []
    weak var listView: ListViewController?
    init(dataService: DataModel) {
        self.dataService = dataService
    }
    
    func loadView() {
        dataService.fetchDataTickers {result in
            self.listView?.updateView()
            self.tickers = result
            self.originalTickers = result
            print("trying to load view")
            self.listView?.updateView()
        }
    }
    
    func openCell(with ticker: Ticker) {
        let vc = AmountViewController(ticker: ticker)
        vc.presenter = self
        listView?.navigationController?.present(vc, animated: true)
    }
    
    func model(for indexPath: Int) -> Ticker {
        tickers[indexPath]
    }
    
    func getImageForCoin(id: String, indexPath: IndexPath) {
        if let cachedImageURL = ImageHelper.shared.getCachedImageURL(for: id) {
            // Если кешированное изображение найдено, используем его
            self.tickers[indexPath.row].logo = cachedImageURL
        } else {
            dataService.getImageURL(with: id) { result in
                switch result {
                case .success(let image):
                    self.tickers[indexPath.row].logo = image.logo
                    // Кеширование ссылки на изображение
                    ImageHelper.shared.cacheImageURL(for: id, link: image.logo)
                case .failure(let error):
                    // Обработка ошибки
                    print("Ошибка при загрузке изображения: \(error.localizedDescription)")
                    // Установка плейсхолдер-изображения
                    self.tickers[indexPath.row].logo = "https://www.svgrepo.com/show/135240/bitcoin-placeholder.svg"
                }
            }
        }
    }
    func addButtonTapped(ticker: Ticker, amount: Double) {
        print(ticker.name, amount)
        AuthService.shared.fetchUser { [weak self] user, error in
            if let user = user {
                let db = Firestore.firestore()
                let userDocument = db.collection("users").document(user.userUID)
                let tokenCollection = userDocument.collection("tokens")
                let tokenId = "\(ticker.id)" // Token identifier
                let amount = amount // Quantity to add
                
                let tokenDocument = tokenCollection.document(tokenId)
                tokenDocument.getDocument { document, error in
                    if let document = document, document.exists {
                        // Token document already exists, update the quantity
                        if let currentQuantity = document.data()?["quantity"] as? Double {
                            let newQuantity = currentQuantity + amount
                            
                            tokenDocument.updateData(["quantity": newQuantity]) { error in
                                if let error = error {
                                    print("Error updating token: \(error.localizedDescription)")
                                } else {
                                    print("Token quantity successfully updated in Firestore")
                                }
                            }
                        }
                    } else {
                        // Token document doesn't exist, create it with the initial quantity
                        let data: [String: Any] = ["quantity": amount]
                        
                        tokenDocument.setData(data, merge: true) { error in
                            if let error = error {
                                print("Error adding token: \(error.localizedDescription)")
                            } else {
                                print("Token added to Firestore")
                            }
                        }
                    }
                }
            }
        }


        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            if let rootViewController = window.rootViewController {
                rootViewController.dismiss(animated: true, completion: nil)
            }
        }
        
        

    }
}



