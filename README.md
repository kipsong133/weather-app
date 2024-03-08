## 제주도 날씨앱
**실행영상**

https://github.com/kipsong133/weather-app/assets/65879950/9220b355-688f-4dae-be72-328eafb80eaa

## 목적
- CoreLocationAPI 활용 학습: `LocationManager.swift`
- OpenWeatherAPI를 통한 HTTP 통신 기능 구현: `WeatherManager.swift`
- 파일접근 후, JSON -> Swift Structure 로 디코딩 기능 구현: `ModelData.swift`
- Combine의 간단한 활용(데이터 바인딩을 통한 UI 업데이트): `@StateObject`, `@State`, `ObservableObject`, `@EnvironmentObject`
- `task` 를 통해 비동기 처리와 연계된 UI 업데이트 기능 구현: `ConetntView` 의 `LoadingView` 랜더링 시점에 동작
- `Lottie` 파일(형식은 `.gif`)동작을 위해 UIKit의 클래스를 SwiftUI에서 사용할 수 있도록 구현:`AnimatedImageView`

## 해당 프로젝트 실행 시, 참고사항

### APIKey의 경우, 노출할 수 없어서. `.gitignore`로 따로 관리하고 있습니다. 만약 구동을 원한다면, 아래 절차를 따라주시면 됩니다.
1. [OpenWeather](https://openweathermap.org/) 사이트 회원가입 진행합니다.
2. APIKey를 발급받기 위해 상단탭에서 "MyAppKeys" 탭으로 이동합니다.
![스크린샷 2024-03-07 오후 4 08 43](https://github.com/kipsong133/weather-app/assets/65879950/e1293292-9b4a-42a3-99a0-06a884259544)
3. "Generate" 버튼을 클릭해서 키를 생성하고 저장해둡니다.
![스크린샷 2024-03-07 오후 4 09 54](https://github.com/kipsong133/weather-app/assets/65879950/b26da9a9-dc87-4346-9777-6001953e1c27)
4. 프로젝트에 돌아와서 전역 범위에 아래와 같이 코드를 작성합니다.
~~저는 ENV.swift로 생성한 뒤, 해당 파일을 `.gitignore`를 통해서 관리하고 있습니다.~~
```swift
let apiKey = "13ak47mm16hk6j3157t9e9zz13f2g5j9"
```

### 에셋 출처
- [Lottie 에셋](https://lottiefiles.com/kr/animations/qutab-guano-i62zaS81L1)

### Snippet 코드 정리

#### 소숫점 반올림 / CornerRadius
```swift
import SwiftUI

// Double 타입의 확장으로, Double 값을 반올림하여 문자열로 반환하는 메서드를 추가합니다.
extension Double {
    /// Double 값을 반올림하여 문자열로 반환합니다.
    ///
    /// 사용 예시:
    /// let myDouble = 3.14159
    /// print(myDouble.roundDouble()) // "3"
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

// View 프로토콜을 확장하여, 특정 모서리에만 코너 반경을 적용할 수 있는 메서드를 추가합니다.
extension View {
    /// 특정 모서리에만 코너 반경을 적용합니다.
    ///
    /// 사용 예시:
    /// Text("Hello, World!")
    ///     .cornerRadius(10, corners: [.topLeft, .bottomRight])
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// 모서리를 둥글게 처리하는 데 사용되는 Shape를 정의합니다.
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity // 적용할 코너 반경
    var corners: UIRectCorner = .allCorners // 둥글게 처리할 모서리
    
    /// 주어진 사각형에 대해 특정 모서리를 둥글게 처리한 경로를 생성합니다.
    ///
    /// 이 메서드는 내부적으로 UIBezierPath를 사용하여 지정된 모서리에 대한 둥근 모양을 생성하고,
    /// 이를 SwiftUI의 Path로 변환하여 반환합니다.
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

```

#### Log 호출을 위한 클래스(디버그에서만 출력)
```swift
import Foundation

/// 사용 예시
/// Logger.log("위치정보 획득 에러", level: .error)
/// Logger.log("이것은 경고 메시지입니다", level: .warning)
/// Logger.log("정보 메시지입니다")
class Logger {
    enum Level: String {
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
    
    static func log(_ message: String, level: Level = .info, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(level.rawValue)] [\(fileName):\(line)] \(function) - \(message)"
        print(logMessage)
        #endif
    }
}
```

#### `.gif` 확장자 실행을 위한 View
```swift
import SwiftUI
import UIKit

struct AnimatedImageView: UIViewRepresentable {
    var imageName: String
    var width: CGFloat
    var height: CGFloat
    
    func makeUIView(context: Context) -> UIImageView {
        guard let gifImage = UIImage.gif(name: imageName) else {
            return UIImageView()
        }
        
        let imageView = UIImageView(image: gifImage)
        imageView.contentMode = .scaleToFill // 이미지의 비율을 유지하면서 콘텐츠를 맞춤
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height) // 여기에서 크기를 지정
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // UIView 업데이트 로직 (필요한 경우)
    }
}
extension UIImage {
    static func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif"),
              let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        
        return UIImage.gif(data: imageData)
    }
    
    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        
        return UIImage.animatedImage(with: images, duration: Double(count) / 10.0)
    }
}

// MARK: - Example
                    GeometryReader { geometry in
                        AnimatedImageView(imageName: "island", width: geometry.size.width, height: geometry.size.height)
                            .frame(width: geometry.size.width, height: geometry.size.height) // 뷰의 크기를 지정
                            .clipShape(RoundedRectangle(cornerRadius: 20)) // 둥근 모서리 적용
                            .overlay(
                                RoundedRectangle(cornerRadius: 20) // 둥근 모서리가 적용된 테두리를 그림
                                    .stroke(Color.white, lineWidth: 4) // 테두리의 색상과 두께를 지정
                            )
                    }

```

#### 바이너라 파일을 로드하는 메서드
```swift
import Foundation

// 예시로 사용할 날씨 데이터를 로드합니다.
var previewWeather: ResponseBody = load("weatherData.json")

/// 지정된 JSON 파일을 로드하고, Decodable 프로토콜을 준수하는 타입으로 디코딩합니다.
///
/// 이 함수는 제네릭을 사용하여 다양한 타입의 데이터를 로드하고 디코딩할 수 있습니다.
/// 파일이 Bundle 내에 존재하지 않거나, 파일을 읽을 수 없거나, 디코딩 과정에서 오류가 발생하는 경우
/// 앱이 종료되도록 fatalError를 호출합니다.
///
/// - Parameter filename: 로드할 파일의 이름입니다. 파일 확장자를 포함하지 않습니다.
/// - Returns: 디코딩된 데이터 타입의 인스턴스를 반환합니다. 이 타입은 호출 시 지정됩니다.
///
/// 사용 예시:
/// let weatherData: ResponseBody = load("weatherData.json")
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    // Bundle에서 지정된 파일의 URL을 찾습니다. 파일이 없는 경우 오류 메시지와 함께 앱이 종료됩니다.
    guard let file = Bundle.main.url(forResource: filename,
                                     withExtension: nil) else {
        fatalError("파일을 찾을 수 없습니다")
    }
    
    // 파일의 내용을 Data 객체로 로드합니다. 실패할 경우 오류 메시지와 함께 앱이 종료됩니다.
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("파일을 읽을 수 없습니다: \(error.localizedDescription)")
    }
    
    // 로드된 Data 객체를 지정된 타입으로 디코딩합니다. 디코딩 과정에서 오류가 발생하면 오류 메시지와 함께 앱이 종료됩니다.
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("파일을 디코딩할 수 없습니다: \(error.localizedDescription)")
    }
}

```

