
# SmartGarden – Código Arduino/ESP8266

Este código foi desenvolvido para o projeto **SmartGarden**, com o objetivo de ler a umidade do solo usando um sensor analógico e enviar os dados para um servidor Node-RED via protocolo HTTP.

## 🔧 Componentes Utilizados

- Placa: ESP8266 (NodeMCU)
- Sensor de Umidade do Solo (analógico)
- Fonte 3.3V
- Resistores e cabos jumper

## 📦 Bibliotecas

- `ESP8266WiFi.h`
- `ESP8266HTTPClient.h`
- `Arduino.h`

Essas bibliotecas já estão disponíveis no ambiente do Arduino IDE ao instalar a placa ESP8266 via Gerenciador de Placas.


## 🌱 Funcionamento

1. O sensor de umidade é lido a cada 10 segundos.
2. O valor da umidade é transformado em percentual com base no ADC.
3. O dado é enviado via `HTTP POST` para o endpoint:

```cpp
const char *URL = "http://192.168.128.87:1880/SensorPost";
```

## 📤 Payload Enviado

Formato `x-www-form-urlencoded`:
```
umidade=53.24
```

## 🛠 Como usar

1. Instale as bibliotecas necessárias no Arduino IDE.
2. Conecte o sensor analógico ao pino A0.
3. Configure sua rede Wi-Fi se necessário.
4. Faça o upload do código para a ESP8266.
5. Verifique o console serial para acompanhar as leituras.
