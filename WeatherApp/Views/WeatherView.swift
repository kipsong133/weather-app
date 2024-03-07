import SwiftUI

// MARK: - 이 페이지에서 사용하는 LogoList
private let thermometerLogo = "thermometer"
private let windLogo = "wind"
private let humidityLogo = "humidity"

// MARK: - View
struct WeatherView: View {
    var weather: ResponseBody
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold().font(.title)
                    
                    Text("지금은, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: "cloud")
                                .font(.system(size: 40))

                            Text("\(weather.weather[0].main)")
                        }
                        .frame(width: 150, alignment: .leading)

                        Spacer()

                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                    }
                    GeometryReader { geometry in
                        AnimatedImageView(imageName: "island", width: geometry.size.width, height: geometry.size.height)
                            .frame(width: geometry.size.width, height: geometry.size.height) // 뷰의 크기를 지정
                            .clipShape(RoundedRectangle(cornerRadius: 20)) // 둥근 모서리 적용
                            .overlay(
                                RoundedRectangle(cornerRadius: 20) // 둥근 모서리가 적용된 테두리를 그림
                                    .stroke(Color.white, lineWidth: 4) // 테두리의 색상과 두께를 지정
                            )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("오늘의 날씨")
                        .bold()
                        .padding(.bottom)

                    HStack {
                        VStack(alignment: .leading) {
                            WeatherRow(logo: thermometerLogo, name: "최저기온", value: (weather.main.tempMin.roundDouble() + ("°")))
                            WeatherRow(logo: windLogo, name: "풍속", value: (weather.wind.speed.roundDouble() + "m/s"))

                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            WeatherRow(logo: thermometerLogo, name: "최고기온", value: (weather.main.tempMax.roundDouble() + "°"))
                            WeatherRow(logo: humidityLogo, name: "습도", value: (weather.main.humidity.roundDouble() + "%"))

                        }
                    }
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}

struct WeatherView_Previews: PreviewProvider {
    
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
