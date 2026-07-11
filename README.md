# ⚓ Batalha Naval Digital — DE10-Lite FPGA

<p align="center">
  🇧🇷 Português | <a href="README.en.md">🇺🇸 English</a>
</p>

Implementação em hardware do clássico jogo **Batalha Naval**, desenvolvida em **Verilog HDL** para a **Intel DE10-Lite FPGA (MAX 10 — 10M50DAF484C7G)**. O projeto utiliza gráficos VGA, máquinas de estados finitos (MEFs), memória interna para o tabuleiro, gerenciamento de pontuação e uma arquitetura de hardware totalmente modular.

---

## 🎮 Visão Geral do Jogo

O jogo é executado em **modo desafio**:

* O **Jogador 1** posiciona todos os navios no tabuleiro.
* O **Jogador 2** tenta localizar e destruir os navios sem conhecer suas posições.

### Funcionalidades

* Tabuleiro de jogo 8×8
* Posicionamento de navios utilizando switches e botão de confirmação
* Interface gráfica via VGA
* Sistema de pontuação
* Detecção automática de vitória e derrota
* Arquitetura totalmente modular
* Implementado inteiramente em Verilog HDL

A partida termina quando:

* Todos os navios são destruídos; ou
* A pontuação do jogador chega a zero.

---

## 🚢 Navios

| Navio        | Tamanho   | Código  |
| ------------ | --------- | ------- |
| Porta-aviões | 5 células | `2'b00` |
| Fragata      | 4 células | `2'b01` |
| Corveta      | 3 células | `2'b10` |
| Submarino    | 2 células | `2'b11` |

---

## 🎨 Codificação das Cores

| Cor      | Código  | Significado          |
| -------- | ------- | -------------------- |
| Branco   | `2'b11` | Navio intacto        |
| Azul     | `2'b01` | Água não atingida    |
| Vermelho | `2'b00` | Navio atingido       |
| Amarelo  | `2'b10` | Água atingida (erro) |

Cada posição do tabuleiro armazena **4 bits**:

* **[3:2]** → Cor da célula
* **[1:0]** → Tipo do navio

---

## 🔧 Plataforma de Hardware

* **Placa:** Intel DE10-Lite (MAX 10 — 10M50DAF484C7G)
* **Saída de vídeo:** VGA
* **Entradas:** 6 switches + 2 botões
* **Displays:** Quatro displays de sete segmentos

### Mapeamento de Hardware

| Componente | Função               |
| ---------- | -------------------- |
| `SW[2:0]`  | Coluna (1–8)         |
| `SW[5:3]`  | Linha (A–H)          |
| `KEY[0]`   | Reset                |
| `KEY[1]`   | Confirmar            |
| `HEX0`     | Exibição da coluna   |
| `HEX1`     | Exibição da linha    |
| `HEX4`     | Unidade da pontuação |
| `HEX5`     | Dezena da pontuação  |
| VGA        | Tabuleiro 8×8        |

---

## 🏗️ Arquitetura do Sistema

### Fluxo do Jogo

```text
Reset
    ↓
Inicialização do Tabuleiro (Azul)
    ↓
Posicionamento dos Navios (Jogador 1)
    ↓
Fase de Ataques (Jogador 2)
    ↓
Fim de Jogo
```

### Módulos do Projeto

| Módulo                    | Descrição                                                         |
| ------------------------- | ----------------------------------------------------------------- |
| `main`                    | Módulo principal que integra todo o sistema                       |
| `mef_principal`           | Máquina de estados principal que controla o fluxo do jogo         |
| `MEFPlayer1`              | Controlador da fase de posicionamento dos navios                  |
| `MEFPlayer2`              | Controlador da fase de ataques                                    |
| `Memoria`                 | Memória do tabuleiro implementada como 64 registradores de 4 bits |
| `Registrador4Bits`        | Registrador de 4 bits com enable                                  |
| `Registrador6Bits`        | Armazena a última coordenada utilizada                            |
| `contador_posicionamento` | Controla a sequência de posicionamento dos navios                 |
| `contador_destruicao`     | Rastreia acertos e detecta quando um navio é destruído            |
| `contador_pontuacao`      | Atualiza a pontuação e detecta fim de jogo                        |
| `contador_64_blocos`      | Percorre as 64 posições do tabuleiro durante a inicialização      |
| `verifica_tiro`           | Determina se um tiro foi acerto, erro ou repetição                |
| `resetDoAmarelo`          | Remove a marcação amarela da jogada anterior                      |
| `debounce`                | Elimina o efeito de bouncing dos botões                           |
| `detector_borda`          | Gera um pulso único na borda de subida                            |
| `display_letra`           | Decoder de sete segmentos para as linhas (A–H)                    |
| `display_numero`          | Decoder de sete segmentos para números                            |
| `display_pontuacao`       | Exibe a pontuação atual                                           |
| `FlipFlopD`               | Flip-flop D utilizado na construção dos registradores             |
| `mux1bit`                 | Multiplexador 2:1 de 1 bit                                        |
| `mux4Inp1Bit`             | Multiplexador 2:1 de 4 bits                                       |
| `mux2Bits`                | Multiplexador 4:1 de 1 bit                                        |
| `mux4para1_4bits`         | Multiplexador 4:1 de 4 bits                                       |
| `mux2para1_6bits`         | Multiplexador 2:1 de 6 bits                                       |
| `CodMefSigToSlc`          | Codifica os sinais das MEFs para seleção dos multiplexadores      |
| `parametros.v`            | Definições globais de cores e tipos de navios                     |
| `VGA_interface`           | Interface VGA fornecida (não modificar)                           |

---

## 📁 Estrutura do Projeto

```text
/
├── main.v
├── parametros.v
├── mef_principal.v
├── MEFPlayer1.v
├── MEFPlayer2.v
├── Memoria.v
├── Registrador4Bits.v
├── Registrador6Bits.v
├── contador_posicionamento.v
├── contador_destruicao.v
├── contador_pontuacao.v
├── contador_64_blocos.v
├── verifica_tiro.v
├── resetDoAmarelo.v
├── debounce.v
├── detector_borda.v
├── display_letra.v
├── display_numero.v
├── display_pontuacao.v
├── FlipFlopD.v
├── mux1bit.v
├── mux4Inp1Bit.v
├── mux2Bits.v
├── mux4para1_4bits.v
├── mux2para1_6bits.v
├── CodMefSigToSlc.v
├── VGA_interface.v
└── pbl323.qsf
```

---
