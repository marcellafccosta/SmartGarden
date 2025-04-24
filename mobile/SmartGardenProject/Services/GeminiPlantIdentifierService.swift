//
//  GeminiPlantIdentifierService.swift
//  SmartGarden
//
//  Created by Turma01-10 on 08/04/25.
//

import Foundation
import UIKit

class GeminiPlantIdentifierService: ObservableObject {
    private let apiKey = "APIKEY" // Substitua pela sua chave de API 

    private var url: URL {
        URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!
    }

    func identificarPlantaComImagem(imagem: UIImage, completion: @escaping (Result<PlantaInfo, Error>) -> Void) {
        guard let imageData = imagem.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Conversão de imagem falhou", code: -1)))
            return
        }

        let base64Image = imageData.base64EncodedString()
        let prompt = """
        A imagem enviada é de uma planta. Por favor, identifique a planta e retorne a resposta no seguinte formato JSON com valores numéricos:

        {
          "nome_popular": "nome comum da planta",
          "descricao": "breve descrição da planta",
          "umidade_ideal_min": número mínimo de umidade ideal (ex: 30),
          "umidade_ideal_max": número máximo de umidade ideal (ex: 60),
          "luminosidade_ideal": "tipo de luz ideal"
        }

        ⚠️ Responda com **apenas o JSON bruto**, sem comentários, sem explicações e **sem usar crases ou formatação Markdown**.
        """

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        [
                            "inlineData": [
                                "mimeType": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let candidates = json["candidates"] as? [[String: Any]],
                  let content = candidates.first?["content"] as? [String: Any],
                  let parts = content["parts"] as? [[String: Any]],
                  let responseText = parts.first?["text"] as? String else {
                completion(.failure(NSError(domain: "Erro ao interpretar resposta", code: -2)))
                return
            }

            if let planta = self.decodePlanta(from: responseText) {
                completion(.success(planta))
            } else {
                print("📦 Texto recebido do Gemini:\n\(responseText)")

                completion(.failure(NSError(domain: "Erro ao decodificar JSON", code: -3)))
            }
        }.resume()
    }
    
    func decodePlanta(from responseText: String) -> PlantaInfo? {
        // Limpa possíveis crases e formatação Markdown
        let cleaned = responseText
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if let data = cleaned.data(using: .utf8) {
            return try? JSONDecoder().decode(PlantaInfo.self, from: data)
        }
        return nil
    }
}
