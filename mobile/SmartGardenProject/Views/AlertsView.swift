import SwiftUI

struct Notification: Hashable {
    var symbol: String
    var warning: String
    var time: Date
}

struct AlertsView: View {
    
    @StateObject var VM = ViewModel()
    @State var notifications: [Notification] = []
    
    @State private var timer = Timer.publish(every: 15.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.verdeClaro
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Alertas")
                    .font(.title)
                    .bold()
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(notifications, id: \.self) { notif in
                            HStack {
                                Image(notif.symbol)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                VStack(alignment: .leading) {
                                    Text(notif.warning)
                                        .font(.system(size: 24, weight: .medium))
                                    Text(notif.time.formatted(date: .omitted, time: .shortened))
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            VM.fetch()
            VM.fetchUmidade()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                generateNotifications()
            }
        }
        .onReceive(timer) { _ in
            VM.fetch()
            VM.fetchUmidade()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                generateNotifications()
            }
        }
    }
    
    func generateNotifications() {
        notifications.removeAll()
        let now = Date()
        
        for planta in VM.plantas {
            guard let mensagem = VM.mensagemParaUmidade(for: planta) else { continue }
            
            let symbol: String
            
            switch mensagem {
            case "Afogou-se :(":
                symbol = "blue warning"
            case "Urgente: regar agora!":
                symbol = "red warning"
            case "É preciso regar a planta!":
                symbol = "yellow warning"
            case "Sua planta está feliz! :)":
                symbol = "green warning"
            default:
                symbol = "red warning"
            }
            
            let notif = Notification(
                symbol: symbol,
                warning: "\(planta.nome): \(mensagem)",
                time: now
            )
            notifications.append(notif)
        }
    }
}

#Preview {
    AlertsView()
}
