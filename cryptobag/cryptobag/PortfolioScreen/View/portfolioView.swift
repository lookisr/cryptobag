import UIKit
import FirebaseStorage
import FirebaseFirestore

class PortfolioView: UIViewController {
    
    let balanceLabel = UILabel()
    let refresher: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    let addButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.image = UIImage(systemName: "plus.circle.fill")
        view.tintColor = .systemGreen
        return view
    }()
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: 88.0)
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let table = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        table.register(CustomCell.self, forCellWithReuseIdentifier: String(describing: CustomCell.self))
        return table
    }()
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .systemGreen
        indicator.style = .medium
        return indicator
    }()
    var data = [String]()
    var presenter: PortfolioPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewView()
        setupUI()
    }
    @objc func refresh() {
        presenter?.loadValue()
        refresher.endRefreshing()
    }
    
    @objc func addButtonTapped() {
        presenter?.addTapped()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(123)
        
    }
    
    @objc private func didTabLogout(){
        AuthService.shared.signOut { [weak self] error in
                   guard let self = self else { return }
                   if let error = error {
                       AlertManager.showLogoutError(on: self, with: error)
                       return
                   }
                   
                   if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                       sceneDelegate.checkAuthentication()
                   }
               }
    }

    
    func setupUI() {
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        self.navigationController?.isNavigationBarHidden = false
        presenter?.loadValue()
        balanceLabel.frame = CGRect(x: 20, y: 50, width: 200, height: 30)
        
        // Настройка текста и внешнего вида элементов
        AuthService.shared.fetchUser { [weak self] user, error in
                         guard let self = self else { return }
                         if let error = error {
                             AlertManager.showFetchingUserError(on: self, with: error)
                             return
                         }
                         
                         if let user = user {
                             print("\(user.username)\n\(user.email)")
                             self.balanceLabel.text = "\(user.cost)"
                         }
                     }
        

               
       
        self.navigationItem.rightBarButtonItem = addButton
        
        // Изменение цвета верхней части экрана
        view.backgroundColor = UIColor.white
        
        // Добавление элементов на экран
        view.addSubview(balanceLabel)
        view.addSubview(collectionView)
        collectionView.addSubview(refresher)
        
        
        let backColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        view.backgroundColor = backColor
        collectionView.backgroundColor = backColor
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        collectionView.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(400)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints{make in
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(view.center.y)
        }
       
        
        
    }
    private func setUpTableViewView() {
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func updateView() {
        print("view updated")
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func updateCell(for indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    func test(){
        print(123)
    }
    
}
    
extension PortfolioView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tick = presenter!.userTickers {
            return presenter!.userTickers!.count
        } else {return 0}
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 10
        presenter!.getImageForCoin(id: presenter!.userTickers![indexPath.row].id, indexPath: indexPath)
        cell.image.setImage(from: presenter!.userTickers![indexPath.row].logo, placeholder: UIImage(named: "error"))
        cell.configure(with: presenter!.model(for: indexPath.row))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTicker = presenter!.userTickers![indexPath.row]
        presenter!.openCell(with: selectedTicker)
    }

}
extension PortfolioView: UICollectionViewDelegate {
    func tableView(_ tableView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
        
}

