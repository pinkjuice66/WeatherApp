import UIKit

class WeatherListViewController: UIViewController {

    let weatherViewModel = WeatherViewModel.shared
    var timeUpdateTimer :Timer?
    var weatherUpdateTimer: Timer?
    var isAlertPresented: Bool = false
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    deinit {
        weatherUpdateTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
        setUpUI()
        addWeatherInfoArrivingObserver()
        addNetworkIsntConnectedObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 도시의 현재 시간을 업데이트 시키기 위해 15초 간격으로 타이머를 동작시킨다.
        timeUpdateTimer = Timer.scheduledTimer(timeInterval: 15,
                                     target: self,
                                     selector: #selector(updateCurrentTime),
                                     userInfo: nil,
                                     repeats: true)
        // 도시의 기상 정보를 업데이트 시키기 위해 30분(1800초) 간격으로 타이머를 동작시킨다.
        weatherUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1800,
                                                  repeats: true) { timer in
            self.weatherViewModel.updateCheck()
        }
        weatherViewModel.updateCheck(within: 30)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCurrentTime()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timeUpdateTimer?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination
                as? DetailWeatherViewController else { return }
        guard let index = sender as? IndexPath else { return }
        
        destinationVC.initialIndex = index.row
    }
    
    // 각 도시의 현재시간을 나타내는 레이블을 업데이트 시킨다
    @objc func updateCurrentTime() {
        for i in 0..<weatherViewModel.getCities().count {
            let idx = IndexPath(row: i, section: 0)
            guard let cell = citiesTableView.cellForRow(at: idx) as? WeatherCell
            else { return }
            let timeZone = weatherViewModel.getCities()[i].timeZone
            cell.currentTimeLabel.text = Date().currentTime(timeZone: timeZone!)
        }
    }
    
    @objc func searchButtonClicked() {
        performSegue(withIdentifier: "searchButtonClickedSegue", sender: nil)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
}

extension WeatherListViewController {
    
    private func setUpUI() {
        citiesTableView.rowHeight = 120
        
        let rect = CGRect(x: 0, y: 0, width: citiesTableView.frame.width, height: 70)
        let footerView = UIView(frame: rect)
        footerView.backgroundColor = .black
        citiesTableView.tableFooterView = footerView
        
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = """
            Weather
            Service
        """
        footerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle")
        button.isUserInteractionEnabled = true
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFill
        footerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -15).isActive = true
        button.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 15).isActive = true
        button.addTarget(self, action: #selector(searchButtonClicked),
                         for: .touchUpInside)
        
    }
    
    // 날씨 정보가 도착하면 테이블뷰를 업데이트 시키는 Observer를 추가한다.
    private func addWeatherInfoArrivingObserver() {
        let notificationName = NSNotification.Name("weatherInfoArrived")
        NotificationCenter.default.addObserver(forName: notificationName,
                                               object: nil,
                                               queue: .main) { _ in
            self.citiesTableView.reloadData()
            // WeatherPageItemViewController(날씨 상세 정보)에게 날씨 정보가 업데이트 되었다는 것을 알려서 뷰의 데이터를 업데이트 하도록 한다.
            let notificationName = NSNotification.Name("weatherInfoUpdated")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    // 네트워크에 연결되어 있지 않다는 알림을 받으면 알림창을 뛰운다.
    private func addNetworkIsntConnectedObserver() {
        let notificationName = NSNotification.Name("networkIsntConnected")
        NotificationCenter.default.addObserver(forName: notificationName,
                                               object: nil,
                                               queue: .main) { notification in
            guard let alert = notification.object as? UIAlertController else { return }
            if self == self.navigationController?.topViewController! &&
                alert.presentingViewController == nil {
                    self.isAlertPresented = true
                    self.present(alert, animated: true)
            }
        }
    }
    
}

extension WeatherListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherViewModel.getCities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherCell else { return UITableViewCell() }
        let city = weatherViewModel.getCities()[indexPath.row]
        cell.currentTimeLabel.text = Date().currentTime(timeZone: city.timeZone!)
        cell.currentTemperatureLabel.text = (city.currentWeather?.temperature?.roundedString())! + "℃"
        cell.nameLabel.text = city.name
        
        return cell
    }
    
}

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailWeatherSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete",
                handler: {
                (action: UIContextualAction, view: UIView, success: (Bool) -> Void) -> Void in
                let city = self.weatherViewModel.getCities()[indexPath.row]
                self.weatherViewModel.removeCity(city)
                tableView.deleteRows(at: [indexPath], with: .none)
                success(true)
                                        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
