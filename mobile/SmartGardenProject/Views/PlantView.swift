//
//  PlantView.swift
//
//  Created by Turma01-10 on 04/04/25.
//

import SwiftUI

struct PlantView: View {
    @StateObject var viewModel = ViewModel()
    @State var recebePlanta: PlantData?
    
    @State private var timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.verdeClaro.ignoresSafeArea()
            VStack(spacing: 20) {
                ScrollView{
                    // Exibe a imagem da planta, se disponível
                    if let base64String = recebePlanta?.imageBase64,
                       let imageData = Data(base64Encoded: base64String),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .cornerRadius(20)
                            .shadow(radius: 15)
                    } else {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 50))
                    }
                    
                    /*
                    // Nome da planta e imagem de umidade
                    HStack {
                        Text(recebePlanta?.nome ?? "Planta desconhecida")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.bottom, 20)
                        
                        Image(viewModel.imagemParaUmidade())
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .foregroundColor(viewModel.corParaUmidade())
                            .padding(.bottom, 20)
                    }
                    */
                    
                    // Nome da planta e imagem de umidade
                    HStack {
                        Text(recebePlanta?.nome ?? "Planta desconhecida")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.bottom, 20)

                        if let planta = recebePlanta {
                            Image(viewModel.imagemParaUmidade(for: planta))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .foregroundColor(viewModel.corParaUmidade(for: planta))
                                .padding(.bottom, 20)
                        }
                    }

                     
                    VStack(alignment: .leading) {
                        
                        // Umidade Ideal
                        Text("Umidade Ideal: \(recebePlanta?.umidadeMinIdeal ?? 0)% até \(recebePlanta?.umidadeMaxIdeal ?? 0)%")
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .padding(.bottom, 10)
                        
                        /*
                        // Umidade Atual
                        if let umidade = viewModel.umidadeAtual {
                            Text("Umidade Atual: \(umidade)%")
                                .fontWeight(.medium)
                                .padding(.bottom, 10)
                                .foregroundColor(viewModel.corParaUmidade())
                            
                        }
                        */
                        
                        // Umidade Atual
                        if let umidade = viewModel.umidadeAtual, let planta = recebePlanta {
                            Text("Umidade Atual: \(umidade)%")
                                .fontWeight(.medium)
                                .padding(.bottom, 10)
                                .foregroundColor(viewModel.corParaUmidade(for: planta))
                        }

                        /*
                        // Mensagem para umidade
                        if let subtitulo = viewModel.mensagemParaUmidade() {
                            Text(subtitulo)
                                .fontWeight(.medium)
                                .padding(.bottom, 10)
                                .foregroundColor(viewModel.corParaUmidade())
                        }
                        */
                        
                        // Mensagem para umidade
                        if let planta = recebePlanta,
                           let subtitulo = viewModel.mensagemParaUmidade(for: planta) {
                            Text(subtitulo)
                                .fontWeight(.medium)
                                .padding(.bottom, 10)
                                .foregroundColor(viewModel.corParaUmidade(for: planta))
                        }

                        // Luminosidade Ideal
                        Text("Luminosidade Ideal: \(recebePlanta?.luminosidade ?? "Desconhecida")")
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .padding(.bottom, 10)
                    }
                    
                    // Descrição da planta
                    Text(recebePlanta?.descricao ?? "Sem descrição disponível.")
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .padding(.bottom, 20)
                    
                }
                .padding()
            }
            .onAppear {
                viewModel.fetch()
                viewModel.fetchUmidade()
                
            }
            .onReceive(timer) { _ in
                viewModel.fetchUmidade()
            }

        }
    }}

#Preview {
    PlantView()
}
