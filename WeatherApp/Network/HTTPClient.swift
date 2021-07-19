// url과 query를 받아서 url에 있는 데이터를 받아오는 기능 구현

import Foundation

class HTTPClient {
    
    static let session = URLSession(configuration: .default)
    
    static func requset(with url: String, queryPameters: [String: String] = [:],
                            completion: @escaping (Data?) -> Void ) {
        var urlComponets = URLComponents(string: url)
        
        for query in queryPameters {
            let queryItem = URLQueryItem(name: query.key, value: query.value)
            urlComponets?.queryItems?.append(queryItem)
        }
        guard let requestURL = urlComponets?.url else {
            print("requestURL을 가져오는데 실패하였습니다.")
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("response error")
                return
            }
            completion(data)
        }
        task.resume()
    }
    
}
