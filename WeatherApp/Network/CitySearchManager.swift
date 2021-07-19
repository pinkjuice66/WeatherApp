// 도시의 위도와 경도 검색

import Foundation
import MapKit

class CitySearchManager: NSObject{
    
    let searchCompleter = MKLocalSearchCompleter()
    
    // 입력된 검색어에 매치하는 지역들을 검색해서 자동완성 리스트를 만든다.
    func cityList(of term: String) {
        self.searchCompleter.queryFragment = term
    }
    
    // 입력된 도시 이름을 바탕으로, 도시의 위도와 경도를 알아온다.
    func getCityLocationInfo(_ city: String,
                             completion: @escaping (String, String, String) -> Void) {
        let searchRequset = MKLocalSearch.Request()
        searchRequset.naturalLanguageQuery = city
        let search = MKLocalSearch(request: searchRequset)
        
        search.start() { (response, error) in
            guard let response = response else {
                return
            }
            for item in response.mapItems {
                if let name = item.name, let location = item.placemark.location {
                    let coordinate = location.coordinate
                    completion(name, coordinate.latitude.description, coordinate.longitude.description)
                }
            }
        }
    }
    
}


