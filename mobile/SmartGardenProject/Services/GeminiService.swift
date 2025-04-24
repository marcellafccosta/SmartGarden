//
//  GeminiService.swift
//  SmartGarden
//
//  Created by Turma01-10 on 08/04/25.
//

import Foundation

class GeminiService: ObservableObject {
    private let apiKey = "APIKEY" // Substitua pela sua chave de API 
    private var url: URL {
        URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!
    }
    
    func perguntarAoGemini(prompt: String, completion: @escaping (String) -> Void) {
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                
                completion("Erro na requisição: \(error?.localizedDescription ?? "desconhecido")")
                return
            }
            
            // 🔍 Print para investigar
            if let response = response as? HTTPURLResponse {
                print("Status Code:", response.statusCode)
            }
            print("Resposta bruta:", String(data: data, encoding: .utf8) ?? "Não foi possível converter os dados")
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let content = candidates.first?["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let text = parts.first?["text"] as? String {
                completion(text)
            } else {
                completion("Resposta inválida")
            }
        }.resume()
    }
}
