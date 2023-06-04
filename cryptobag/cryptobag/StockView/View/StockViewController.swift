//
//  StockViewController.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 25.05.2023.
//

import Foundation
import UIKit
import Charts
class StockViewController: UIViewController {
    private let ticker: Ticker
    var presenter: StockPresenterProtocol
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .systemGreen
        indicator.style = .medium
        return indicator
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.082, green: 0.174, blue: 0.026, alpha: 1)
        label.font = UIFont(name: "MulishRoman-Bold", size: 24)
        label.textAlignment = .center
        return label
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.082, green: 0.174, blue: 0.026, alpha: 1)
        label.font = UIFont(name: "MulishRoman-Regular", size: 15)
        label.textAlignment = .center
        return label
    }()
    private var chartView: LineChartView = {
        let view = LineChartView()
        view.frame = CGRect(x: 0, y: 0, width: 350, height: 250)
        view.drawGridBackgroundEnabled = false
        view.xAxis.drawLabelsEnabled = false
        return view
    }()
    private var marketCap: UILabel = {
        let view = UILabel()
        view.layer.frame = CGRect(x: 0, y: 0, width: 155, height: 75)
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 12
        view.font = UIFont(name: "MulishRoman-Bold", size: 15.0)
        view.textColor = .gray
        view.textAlignment = .center
        view.numberOfLines = 2
        
        return view
    }()
    private var totalSup: UILabel = {
        let view = UILabel()
        view.layer.frame = CGRect(x: 0, y: 0, width: 155, height: 75)
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 12
        view.font = UIFont(name: "MulishRoman-Bold", size: 15.0)
        view.textColor = .gray
        view.numberOfLines = 2
        view.textAlignment = .center
        return view
    }()
    private var change7d: UILabel = {
        let view = UILabel()
        view.layer.frame = CGRect(x: 0, y: 0, width: 155, height: 75)
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 12
        view.font = UIFont(name: "MulishRoman-Bold", size: 15.0)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()
    private var change1d: UILabel = {
        let view = UILabel()
        view.layer.frame = CGRect(x: 0, y: 0, width: 155, height: 75)
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 12
        view.font = UIFont(name: "MulishRoman-Bold", size: 15.0)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()
    private lazy var addButton: UIButton = {
        let view = UIButton()
        view.layer.frame = CGRect(x: 0, y: 0, width: 155, height: 75)
        view.layer.backgroundColor = UIColor(named: "systemGreen")?.cgColor
        view.setTitle("Add more", for: .normal)
        view.titleLabel?.font = UIFont(name: "MulishRoman-Bold", size: 15.0)
        return view
    }()
    init(ticker: Ticker, presenter: StockPresenterProtocol) {
        self.ticker = ticker
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupUI()
        presenter.fetchChartData(with: self.ticker)
        activityIndicator.startAnimating()
        updateView()
    }
    func configureView(){
        self.title = "\(ticker.name) \(ticker.symbol)"
        view.addSubview(activityIndicator)
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)
        view.addSubview(marketCap)
        view.addSubview(change1d)
        view.addSubview(change7d)
        view.addSubview(totalSup)
        nameLabel.text = "$\(round(ticker.quotes.first!.value.price * 100) / 100.0)"
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy HH:mm"
        let formattedDateTime = dateFormatter.string(from: currentDate)
        dateLabel.text = formattedDateTime
        marketCap.text = "Marketcap\n$\(ticker.quotes.first!.value.marketCap)"
        if ticker.maxSupply == 0{
            totalSup.text = "Unknown"
        } else { totalSup.text = "Total Supply\n\(ticker.maxSupply)" }
        let value = ticker.quotes.first!.value.percentChange24h as NSDecimalNumber
        let formattedValue = String(format: "%.2f", value.doubleValue)
        let text = "Change 1 day: \(formattedValue)%"
        change1d.text = text
        let weekvalue = ticker.quotes.first!.value.percentChange7d as NSDecimalNumber
        let weekformattedValue = String(format: "%.2f", weekvalue.doubleValue)
        let weektext = "Change 1 week: \(weekformattedValue)%"
        change7d.text = weektext
        
        if ticker.quotes.first!.value.percentChange24h < 0 {
            change1d.layer.backgroundColor = UIColor(red: 0.948, green: 0.401, blue: 0.401, alpha: 0.8).cgColor
        } else { change1d.layer.backgroundColor = UIColor(red: 0, green: 0.796, blue: 0.414, alpha: 0.8).cgColor }
        
        if ticker.quotes.first!.value.percentChange7d < 0 {
            change7d.layer.backgroundColor = UIColor(red: 0.948, green: 0.401, blue: 0.401, alpha: 0.8).cgColor
        } else { change7d.layer.backgroundColor = UIColor(red: 0, green: 0.796, blue: 0.414, alpha: 0.8).cgColor }
    }
    func setupUI(){
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        activityIndicator.snp.makeConstraints{make in
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(view.center.y)
        }
        nameLabel.snp.makeConstraints{make in
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(view.snp.top).offset(123)
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        
        
    }
    func configureChart() {
        activityIndicator.stopAnimating()
        
        guard let graph = presenter.chartData else {
            return
        }
        var dataEntries: [ChartDataEntry] = []
        
        for (index, price) in graph.prices.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index), y: price.price)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        
        chartDataSet.colors = [NSUIColor.systemGreen]
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillColor = .systemRed
        chartView.legend.enabled = false
        chartDataSet.drawValuesEnabled = true
        chartDataSet.valueTextColor = .black
        let chartData = LineChartData(dataSet: chartDataSet)
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawLabelsEnabled = true


        let yAxis = chartView.leftAxis
        yAxis.labelPosition = .outsideChart
        chartView.rightAxis.enabled = false
        xAxis.valueFormatter = WeekdayAxisValueFormatter()
        
        chartView.clipsToBounds = false
        chartView.data = chartData
        view.addSubview(chartView)
        
        chartView.snp.makeConstraints{ make in
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.height.equalTo(240)
            make.width.equalTo(380)
        }
        marketCap.snp.makeConstraints{ make in
            make.left.equalTo(view.snp.left).offset(23)
            make.top.equalTo(chartView.snp.bottom).offset(20)
            make.height.equalTo(85)
            make.width.equalTo(155)
        }
        totalSup.snp.makeConstraints{ make in
            make.right.equalTo(view.snp.right).offset(-23)
            make.top.equalTo(chartView.snp.bottom).offset(20)
            make.height.equalTo(85)
            make.width.equalTo(155)
        }
        change1d.snp.makeConstraints{ make in
            make.left.equalTo(view.snp.left).offset(23)
            make.top.equalTo(marketCap.snp.bottom).offset(20)
            make.height.equalTo(85)
            make.width.equalTo(155)
        }
        change7d.snp.makeConstraints{ make in
            make.right.equalTo(view.snp.right).offset(-23)
            make.top.equalTo(totalSup.snp.bottom).offset(20)
            make.height.equalTo(85)
            make.width.equalTo(155)
        }
        
        
    }
    func updateView() {
        view.setNeedsDisplay()
        configureChart()
    
    }

}
