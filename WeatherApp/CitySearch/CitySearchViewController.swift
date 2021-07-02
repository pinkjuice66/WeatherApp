// 셀 만들기, 레이블 하이라이팅


import UIKit
import MapKit

class CitySearchViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let resultsTableView = UITableView()
    let cityViewModel = CityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.register(SearchedCityCell.self,
                                  forCellReuseIdentifier: SearchedCityCell.reuseIdentifier)
        cityViewModel.citySearch.searchCompleter.delegate = self
        
        setUpUI()
    }

}

extension CitySearchViewController {
    
    func setUpUI() {
        let searchBar = searchController.searchBar
        
        view.backgroundColor = #colorLiteral(red: 0.2416438467, green: 0.2347165125, blue: 0.2377835956, alpha: 0.8600659014)
        resultsTableView.backgroundColor = #colorLiteral(red: 0.2416438467, green: 0.2347165125, blue: 0.2377835956, alpha: 0.8600659014)
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        searchBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        resultsTableView.separatorStyle = .none
        resultsTableView.tableHeaderView = searchBar

        view.addSubview(resultsTableView)
//         set up constraints
        resultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        resultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        resultsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        resultsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
}

// 테이블 뷰에는 검색어에 매치되는 지역들을 보여준다.
// 지역에 관한 정보는 view modeld의 cities property가 가지고 있다.
extension CitySearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
    }
    
}


extension CitySearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // view model에게 검색을 하도록 요청. 검색 결과는 MKLocalSearchCompleterDelegate protocol을 구현하여 처리
        if let term = searchController.searchBar.text {
            if term == "" {
                cityViewModel.searchedCities = []
                resultsTableView.reloadData()
            }
            cityViewModel.cityList(of: term)
        }
    }
    
}

extension CitySearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        cityViewModel.searchedCities = []
        resultsTableView.reloadData()
    }
    
}

extension CitySearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        cityViewModel.searchedCities = completer.results
        resultsTableView.reloadData()
    }
    
}
