import UIKit
import MapKit

class CitySearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let resultsTableView = UITableView()
    let cityViewModel = CityViewModel()
    let weatherViewModel = WeatherViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.register(SearchedCityCell.self,
                                  forCellReuseIdentifier: SearchedCityCell.reuseIdentifier)
        cityViewModel.citySearchManager.searchCompleter.delegate = self
        
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

}

extension CitySearchViewController {
    
    func setUpUI() {
        view.backgroundColor = #colorLiteral(red: 0.2416438467, green: 0.2347165125, blue: 0.2377835956, alpha: 0.8600659014)
        resultsTableView.backgroundColor = #colorLiteral(red: 0.2416438467, green: 0.2347165125, blue: 0.2377835956, alpha: 0.8600659014)
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        searchBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        searchBar.setShowsCancelButton(true, animated: true)
        
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        resultsTableView.separatorStyle = .none
        
        // set up constraints
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        view.addSubview(resultsTableView)
         
        resultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        resultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        resultsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        resultsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
}

// ????????? ????????? ???????????? ???????????? ???????????? ????????????.
// ????????? ?????? ????????? view modeld??? cities property??? ????????? ??????.
extension CitySearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cityViewModel.searchedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedCityCell.reuseIdentifier)
                as? SearchedCityCell else { return UITableViewCell() }
        
        let city = cityViewModel.searchedCities[indexPath.row]
        cell.cityLabel.text = city.title + " " + city.subtitle
        if let titleRange = city.titleHighlightRanges.first?.rangeValue{
            cell.cityLabel.setTextHighlighted(range: titleRange)
        }
        
        return cell
    }
    
}

extension CitySearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = cityViewModel.searchedCities[indexPath.row].title
        // ????????? ????????? ???????????? ????????? ?????????, ??????, ?????? ????????? ????????????.
        cityViewModel.citySearchManager.getCityLocationInfo(cityName) {
            (name, latitude, longitude) in
            self.weatherViewModel.addCity(cityName: name,
                                          latitude: latitude, longitude: longitude)
        }
        self.performSegue(withIdentifier: "unwindSegue", sender: nil)
    }
    
}

extension CitySearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        cityViewModel.searchedCities = []
        performSegue(withIdentifier: "unwindSegue", sender: nil)
    }
    
    // view model?????? ????????? ????????? ??????. ?????? ????????? MKLocalSearchCompleterDelegate protocol??? ???????????? ??????
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let term = searchBar.text {
            if term == "" {
                cityViewModel.searchedCities = []
                resultsTableView.reloadData()
            }
            cityViewModel.cityList(of: term)
        }
    }
    
}

extension CitySearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        cityViewModel.searchedCities = completer.results
        resultsTableView.reloadData()
    }
    
}
