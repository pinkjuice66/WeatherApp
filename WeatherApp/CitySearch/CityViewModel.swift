// 검색된 도시에 대한 정보를 보여준다. 

import Foundation
import MapKit

class CityViewModel: NSObject {
    
    let citySearch = CitySearch()
    
    // 검색되어진 도시들의 목록
    var searchedCities = [MKLocalSearchCompletion]()
    
    func cityList(of term: String) {
        citySearch.cityList(of: term)
    }
    
}

