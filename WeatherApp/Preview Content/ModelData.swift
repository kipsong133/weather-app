import Foundation

var previewWeather: ResponseBody = load("weather.json")


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename,
                                     withExtension: nil) else {
        fatalError("파일을 찾을 수 없습니다")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("파일을 읽을 수 없습니다: \(error.localizedDescription)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("파일을 디코딩할 수 없습니다: \(error.localizedDescription)")
    }
}
