import UIKit
import Charts
import FirebaseStorage
import FirebaseFirestore

class PortfolioView: UIViewController, UICollectionViewDelegate{
    let balanceLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "MulishRoman-Bold", size: 25.0)
        return view
    }()
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
    
    let pieChartView = PieChartView()
    
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
        setupPieChart()
     
    }
    
    @objc func refresh() {
        presenter?.loadValue()
        refresher.endRefreshing()
    }
    
    @objc func addButtonTapped() {
        presenter?.addTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(123)
    }
    
    @objc private func didTabLogout() {
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
        view.backgroundColor = UIColor.white
        view.addSubview(balanceLabel)
        view.addSubview(collectionView)
        collectionView.addSubview(refresher)
        
        let backColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        view.backgroundColor = backColor
        collectionView.backgroundColor = backColor
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 400, left:0 , bottom: 80, right: 0))
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

    }


    
    private func setUpTableViewView() {
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    func updateView() {
        collectionView.reloadData()
        activityIndicator.stopAnimating()
        setupPieChart()
        if presenter?.userTickers?.isEmpty ?? true {
                pieChartView.data?.dataSets.removeAll()
                pieChartView.data?.notifyDataChanged()
                pieChartView.data?.setDrawValues(false)
                pieChartView.centerText = "No Data"
            } else {
                pieChartView.centerText = nil
            }
        
      
    }
    
    func updateCell(for indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
           setupPieChart()
        if presenter?.userTickers?.isEmpty ?? true {
                pieChartView.data?.dataSets.removeAll()
                pieChartView.data?.notifyDataChanged()
                pieChartView.data?.setDrawValues(false)
                pieChartView.centerText = "No Data"
            } else {
                pieChartView.centerText = nil
            }
    
    }
    
  
    
    func generateChartData() -> [PieChartDataEntry] {
        var entries = [PieChartDataEntry]()
        
        guard let tickers = presenter?.userTickers else {
            return entries
        }
        
        let totalValue = tickers.reduce(0.0) { $0 + $1.totals! }
        
        if totalValue == 0 {
            let entry = PieChartDataEntry(value: 1.0, label: "No Data")
            entries.append(entry)
        } else {
            for ticker in tickers {
                let percentage = (ticker.totals! / totalValue)
                let label = ticker.name
                let entry = PieChartDataEntry(value: percentage, label: label)
                entries.append(entry)
            }
        }
        
        return entries
    }

     
    func setupPieChart() {
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pieChartView)
        
        NSLayoutConstraint.activate([
            pieChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pieChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pieChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
        balanceLabel.snp.makeConstraints{make in
            make.bottom.equalTo(pieChartView.snp.top)
            make.centerX.equalTo(view.center.x)
        }
        
        if presenter?.userTickers?.isEmpty == true {
           
            pieChartView.noDataText = "No data available"
            pieChartView.noDataFont = UIFont.systemFont(ofSize: 16)
            pieChartView.noDataTextColor = UIColor.gray
            pieChartView.noDataTextAlignment = .center
            pieChartView.data = nil
        } else {
            let chartDataSet = PieChartDataSet(entries: generateChartData(), label: "Data")
            chartDataSet.colors = ChartColorTemplates.material()
            chartDataSet.valueColors = [.white]
            chartDataSet.drawValuesEnabled = true
            
            let chartData = PieChartData(dataSet: chartDataSet)
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.percentSymbol = "%"
            chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            
            pieChartView.data = chartData
            pieChartView.legend.enabled = false
        }
        
        pieChartView.animate(xAxisDuration: 0.5)
    }


}

extension PortfolioView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tick = presenter?.userTickers {
            return tick.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else {
            
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 10
        presenter?.getImageForCoin(id: presenter!.userTickers![indexPath.row].id, indexPath: indexPath)
        cell.image.setImage(from: presenter!.userTickers![indexPath.row].logo, placeholder: UIImage(named: "error"))
        cell.configure(with: presenter!.model(for: indexPath.row))
 
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTicker = presenter!.userTickers![indexPath.row]
        presenter?.openCell(with: selectedTicker)
    }
    
}

extension PortfolioView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 88.0)
    }
}


extension PortfolioView: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetThreshold: CGFloat = -100
        
        if scrollView.contentOffset.y < offsetThreshold {
            presenter?.loadValue()
        }
    }
}


