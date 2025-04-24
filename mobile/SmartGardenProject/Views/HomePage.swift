//
//  HomePage.swift
//  SmartGarden
//
//  Created by Turma01-18 on 03/04/25.
//
//

import SwiftUI

struct HomePage: View {
    @State private var city: String = ""
    @StateObject var viewModel = ViewModel()
    @State private var isLoading: Bool = false
    
    @State private var timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    Spacer()
                    HStack {
                        TextField("Enter city", text: $city, onCommit: {
                            isLoading = true
                            viewModel.fetchWeather(city: city)
                            isLoading = false
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        
                        Button(action: {
                            isLoading = true
                            viewModel.requestLocation()
                        }) {
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    
                    if isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                    
                    if let weather = viewModel.weather {
                        let icon = weather.weather.first?.icon ?? "01d"
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack {
                                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 60, height: 60)
                                }
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(weather.name)
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                                    
                                    
                                    Text("\(weather.main.temp, specifier: "%.0f")°C")
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                                    
                                    
                                    Text(weather.weather.first?.description ?? "No weather description")
                                        .font(.system(size: 18, weight: .regular))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        .frame(maxWidth: 400)
                        .padding()
                        
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.vertical)
                    }
                    
                    Spacer()
                    
                    ForEach(viewModel.plantas, id: \.self) { planta in
                        HStack {
                            NavigationLink(destination: PlantView(recebePlanta: planta)) {
                                VStack {
                                    if let base64String = planta.imageBase64,
                                       let imageData = Data(base64Encoded: base64String),
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(20)
                                    } else {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 50))
                                            .scaledToFit()
                                            .frame(height: 80)
                                    }
                                }
                                .padding(.vertical, 5)
                                
                                Spacer()
                                
                                Text(planta.nome)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(viewModel.imagemParaUmidade(for: planta))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .padding(.top)
                                    .foregroundColor(viewModel.corParaUmidade(for: planta))
                            }
                        }
                        .padding(.horizontal)
                    }

                    
                }
                .padding(.top)
            }
        }
        .background(Color.verdeClaro)
        .onAppear() {
            viewModel.fetch()
            viewModel.fetchUmidade()
        }
        
        .onReceive(timer) { _ in
            viewModel.fetchUmidade()
        }

    }
}

#Preview {
    HomePage()
}
