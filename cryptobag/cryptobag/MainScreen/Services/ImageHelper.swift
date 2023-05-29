//
//  ImageHelper.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 25.05.2023.
//

import Foundation
import CoreData


class ImageHelper {
    static let shared = ImageHelper()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "cryptobag")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Не удалось загрузить хранилище Core Data: \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func cacheImageURL(for id: String, link: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ImageCache> = ImageCache.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let coins = try context.fetch(fetchRequest)
            if let coin = coins.first {
                coin.link = link
            } else {
                let newCoin = ImageCache(context: context)
                newCoin.id = id
                newCoin.link = link
            }

            try context.save()
        } catch {
            print("Ошибка при сохранении ссылки на изображение: \(error.localizedDescription)")
        }
    }

    func getCachedImageURL(for id: String) -> String? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ImageCache> = ImageCache.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        do {
            let coins = try context.fetch(fetchRequest)
            if let coin = coins.first, let cachedImageURL = coin.link {
                return cachedImageURL
            }
        } catch {
            print("Ошибка при получении кешированной ссылки на изображение: \(error.localizedDescription)")
        }

        return nil
    }
}
