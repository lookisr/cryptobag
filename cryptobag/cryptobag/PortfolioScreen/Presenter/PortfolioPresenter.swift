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
                tokenCollection.getDocuments { [weak self] snapshot, error in
                    if let error = error {
                        print("Ошибка при получении токенов: \(error.localizedDescription)")
                        return
                    }
                    
                    var totalValue: Double = 0.0
                    
                    guard let self = self else { return }
                    for document in snapshot?.documents ?? [] {
                        if let documentSnapshot = document as? DocumentSnapshot {
                            let tokenId = documentSnapshot.documentID
          
                            if var ticker = self.tickers?.first(where: { $0.id == tokenId }),
                               let quantity = documentSnapshot.data()?["quantity"] as? Double,
                               let price = ticker.quotes.first?.value.price {
                                
                                let tokenValue = quantity * price
                                totalValue += tokenValue
                                
                                if let existingTickerIndex = self.userTickers?.firstIndex(where: { $0.id == ticker.id }) {
                                    var existingTicker = self.userTickers![existingTickerIndex]
                                    existingTicker.totals = tokenValue
                                    self.userTickers?.remove(at: existingTickerIndex)
                                    self.userTickers?.append(existingTicker)
                                } else {
                                    ticker.totals = tokenValue
                                    self.userTickers?.append(ticker)
                                }
                                
                                self.portfolioView?.updateView()
                            }
                        }
                    }
                    
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
                let tokenId = "\(ticker.id)"
                let amount = amount
                let tokenDocument = tokenCollection.document(tokenId)
                tokenDocument.getDocument { document, error in
                    if let document = document, document.exists {
           
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
        let stockScreen = MainModuleAssembly.configureStockScreen(ticker: ticker)
        portfolioView?.navigationController!.present(stockScreen, animated: true)
        

    }
    
    func model(for indexPath: Int) -> Ticker {
        userTickers![indexPath]
    }
    
    func getImageForCoin(id: String, indexPath: IndexPath) {
        if let cachedImageURL = ImageHelper.shared.getCachedImageURL(for: id) {
        
            self.userTickers![indexPath.row].logo = cachedImageURL
        } else {
            dataService.getImageURL(with: id) { result in
                switch result {
                case .success(let image):
                    self.userTickers![indexPath.row].logo = image.logo
                    ImageHelper.shared.cacheImageURL(for: id, link: image.logo)
                case .failure(let error):
                    print("Ошибка при загрузке изображения: \(error.localizedDescription)")
                    self.userTickers![indexPath.row].logo = "https://www.svgrepo.com/show/135240/bitcoin-placeholder.svg"
                }
            }
        }
    }
    func deleteInitiated(ticker: Ticker) {
        let vc = AmountViewController(ticker: ticker)
        self.portfolioView?.navigationController?.present(vc, animated: true)
    }
}
