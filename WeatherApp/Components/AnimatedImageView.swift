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
