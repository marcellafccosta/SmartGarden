
# 🌱 SmartGarden

O **SmartGarden** é um sistema inteligente para monitoramento de plantas domésticas, desenvolvido durante o curso HackaTruck Makerspace. A solução integra sensores IoT, um aplicativo mobile e um backend para visualização e automação do cuidado com as plantas.

## 📱 Aplicativo Mobile

Desenvolvido com **SwiftUI**, o app permite:

- Visualização em tempo real da umidade do solo
- Alertas inteligentes baseados na leitura dos sensores
- Interface intuitiva para usuários com ou sem experiência em jardinagem

Código disponível na pasta [`mobile/`](./mobile).

## 🌐 Backend

Baseado em **Node-RED**, o backend:

- Recebe dados de sensores via HTTP POST
- Processa e armazena os dados para exibição no app
- Possui integração local e em nuvem

Fluxos disponíveis na pasta [`backend/`](./backend).

## 🔧 Hardware (Arduino/ESP8266)

Utilizamos um **sensor de umidade do solo** conectado a uma placa **ESP8266**, com envio de dados para o backend a cada 10 segundos.

Código e instruções estão em [`arduino/`](./arduino).

## 📂 Estrutura do Projeto

```
smartgarden/
├── mobile/        # Aplicativo SwiftUI
├── backend/       # Node-RED (flows.json)
├── arduino/       # Código e esquemas do sensor
├── docs/          # Apresentação
├── .gitignore
└── README.md
```

## 👩‍💻 Equipe

- [Diego Feitosa Ferreira dos Santos](https://github.com/Sil3ncy)
- [Eduardo De Graza Franco](https://github.com/SaturnV11)
- [João Costa Calazans](https://github.com/joaocostacalazans)
- [Marcella Ferreira Chaves Costa](https://github.com/marcellafccosta)
- [Rayssa Mell de Souza Silva](https://github.com/rayssamell)



## 🧪 Tecnologias

- SwiftUI • Node-RED • ESP8266 • Arduino • IoT
