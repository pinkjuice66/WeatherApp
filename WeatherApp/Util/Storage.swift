import Foundation
 
public class Storage {
    
    private init() { }
    
    private static let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func store<T: Encodable>(_ obj: T, as fileName: String) {
        let url = documentURL.appendingPathComponent(fileName, isDirectory: false)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(obj)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch let error {
            print("---> Failed to store msg: \(error.localizedDescription)")
        }
    }
    
    static func retrive<T: Decodable>(_ fileName: String, as type: T.Type) -> T? {
        let url = documentURL.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            print("---> Failed to decode msg: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func remove(_ fileName: String) {
        let url = documentURL.appendingPathComponent(fileName, isDirectory: false)
            guard FileManager.default.fileExists(atPath: url.path) else { return }
            
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error {
                print("---> Failed to remove msg: \(error.localizedDescription)")
            }
        }
    
    // documentURL에 저장되어 있는 도시들의 json파일 이름을 반환
    static func getCityNames() -> [String] {
        let path = documentURL.path
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: path)
            return contents
        } catch let error {
            print("---> Failed to decode msg: \(error.localizedDescription)")
            return []
        }
    }

}
