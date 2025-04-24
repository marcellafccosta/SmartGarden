import SwiftUI

struct CreatePlant: View {
    @StateObject var geminiService = GeminiService()
    @StateObject var visionService = GeminiPlantIdentifierService()
    @StateObject var viewModel = ViewModel()
    @State private var nomePlanta: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var plantaIdentificada: PlantaInfo?
    
    @State var nomeAux: String = ""
    @State var umidadeMinAux: Int = 0
    @State var umidadeMaxAux: Int = 0
    @State var luminosidadeAux: String = ""
    @State var descricaoAux: String = ""
    @State var imageAux: String = ""
    
    @State private var isSending = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        ZStack {
            Color.verdeEscuro.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24)  {
                    // Header e campos
                    VStack {
                        HStack {
                            
                            Text("Adicionar Planta")
                                .foregroundColor(.white)
                                .font(.title)
                                .bold()
                                .padding(.top, 40)
                            Button(action: {
                                isSending = true // inicia o carregamento

                                var imageBase64String: String? = nil
                                if let selectedImage = selectedImage,
                                   let imageData = selectedImage.jpegData(compressionQuality: 0.3) {
                                    imageBase64String = imageData.base64EncodedString()
                                }

                                let newPlant = PlantData(
                                    nome: nomeAux,
                                    umidadeMinIdeal: umidadeMinAux,
                                    umidadeMaxIdeal: umidadeMaxAux,
                                    luminosidade: luminosidadeAux,
                                    descricao: descricaoAux,
                                    imageBase64: imageBase64String,
                                    warning: ""
                                )

                                viewModel.addPlant(newPlant)

                                // Espera um pouco antes de mostrar o sucesso
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    isSending = false
                                    showSuccessAlert = true
                                }
                            }) {
                                Image(systemName: "plus.square.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.top, 40)
                                    .padding(.horizontal, 20)
                            }
                            
                        }
                        
                        
                        // Nome da planta
                        TextField("Nome da planta", text: $nomePlanta)
                            .padding()
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }
                    
                    if isSending {
                        ProgressView("Adicionando planta...")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    // Imagem da planta
                    VStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.green, lineWidth: 4))
                                .shadow(radius: 10)
                                .padding()
                        } else {
                            Text("Nenhuma imagem selecionada")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            HStack{
                                Image(systemName: "photo.fill")
                                Text("Selecionar Imagem")
                                    .font(.headline)
                            } .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                        
                        if let imagem = selectedImage {
                            Button(action: {
                                isLoading = true
                                visionService.identificarPlantaComImagem(imagem: imagem) { resultado in
                                    DispatchQueue.main.async {
                                        isLoading = false
                                        switch resultado {
                                        case .success(let planta):
                                            plantaIdentificada = planta
                                            nomePlanta = planta.nome_popular
                                            
                                            
                                            nomeAux = planta.nome_popular
                                            descricaoAux = planta.descricao
                                            umidadeMinAux = planta.umidade_ideal_min
                                            umidadeMaxAux = planta.umidade_ideal_max
                                            luminosidadeAux = planta.luminosidade_ideal
                                            
                                            
                                            
                                        case .failure(let erro):
                                            print("Erro ao identificar planta: \(erro.localizedDescription)")
                                        }
                                    }
                                }    }) {
                                    HStack {
                                        Image(systemName: "leaf.fill")
                                            
                                        Text("Identificar Planta")
                                            .font(.headline)
                                    }
                                    .padding()
                                        .background(Color.orange)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.top, 10)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImage: $selectedImage)
            }
            .onAppear {
                viewModel.fetchUmidade()
            }
            
            .alert("Planta adicionada com sucesso!", isPresented: $showSuccessAlert) {
                Button("OK") {
                }
            }
            
        }
    }
    
}

#Preview {
    CreatePlant()
}

