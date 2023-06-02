//
//  PortfolioPresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 30.05.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

protocol PortfolioPresenterProtocol: AnyObject{
    var portfolioView: PortfolioView? {get set}
}

class PortfolioPresenter: PortfolioPresenterProtocol {
    weak var portfolioView: PortfolioView?
    var tickers: [Ticker]?
    var userTickers: [Ticker]? = []
    private let dataService: DataModel
    var router: MainRouterProtocol?
    init(dataService: DataModel) {
        self.dataService = dataService
    }
    func addTapped() {
        let vc = MainModuleAssembly.configureList()
        portfolioView?.navigationController?.present(vc, animated: true)
    }

    func loadValue() {
        AuthService.shared.fetchUser { [weak self] user, error in
            if let user = user {
                let db = Firestore.firestore()
                let userDocument = db.collection("users").document(user.userUID)
                let tokenCollection = userDocument.collection("tokens")
                
                // Получить все токены из Firestore
                tokenCollection.getDocuments { [weak self] snapshot, error in
                    if let error = error {
                        print("Ошибка при получении токенов: \(error.localizedDescription)")
                        return
                    }
                    
                    var totalValue: Double = 0.0 // Общая стоимость токенов
                    
                    guard let self = self else { return }
                    
                    // Пройти по каждому документу токена из Firestore
                    for document in snapshot?.documents ?? [] {
                        if let documentSnapshot = document as? DocumentSnapshot {
                            let tokenId = documentSnapshot.documentID
                            // Найти соответствующий объект ticker с использованием идентификатора токена
                            if let ticker = self.tickers?.first(where: { $0.id == tokenId }),
                               let quantity = documentSnapshot.data()?["quantity"] as? Double,
                               let price = ticker.quotes.first?.value.price {
                                
                                let tokenValue = quantity * price
                                totalValue += tokenValue
                                if ((self.userTickers?.contains(where: {$0.id == ticker.id})) == false) {
                                    self.userTickers?.append(ticker)
                                }
                            }
                            
                        }
                    }
                    self.portfolioView?.updateView()
                    // Отобразить общую стоимость токенов на экране
                    DispatchQueue.main.async {
                        self.portfolioView?.balanceLabel.text = "$\(round(totalValue * 100) / 100.0)"
                        
                    }
                }
            }
        }
    }
    func addToken(ticker: Ticker, amount: Double){
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
        self.portfolioView?.updateView()
    }
    func loadView() {
    
    }
    
    func openCell(with ticker: Ticker) {
//        let vc = AmountViewController(ticker: ticker)
//        vc.presenter = self
//        listView?.navigationController?.present(vc, animated: true)
    }
    
    func model(for indexPath: Int) -> Ticker {
        userTickers![indexPath]
    }
    
    func getImageForCoin(id: String, indexPath: IndexPath) {
        if let cachedImageURL = ImageHelper.shared.getCachedImageURL(for: id) {
            // Если кешированное изображение найдено, используем его
            self.userTickers![indexPath.row].logo = cachedImageURL
        } else {
            dataService.getImageURL(with: id) { result in
                switch result {
                case .success(let image):
                    self.userTickers![indexPath.row].logo = image.logo
                    // Кеширование ссылки на изображение
                    ImageHelper.shared.cacheImageURL(for: id, link: image.logo)
                case .failure(let error):
                    // Обработка ошибки
                    print("Ошибка при загрузке изображения: \(error.localizedDescription)")
                    // Установка плейсхолдер-изображения
                    self.userTickers![indexPath.row].logo = "https://www.svgrepo.com/show/135240/bitcoin-placeholder.svg"
                }
            }
        }
    }
}
