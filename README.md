# ⚓ Batalha Naval Digital — DE10-Lite FPGA

O projeto consiste em uma implementação em hardware digital do clássico jogo Batalha Naval, utilizando Verilog HDL. Desenvolvido para a placa FPGA **Intel DE10-Lite (MAX 10 — 10M50DAF484C7G)**, o projeto conta com gráficos VGA, máquinas de estados finitos, gerenciamento de memória interna, acréscimo e decréscimo de pontuação e uma arquitetura de hardware modular.

---

## 🎮 Descrição do Jogo

O jogo funciona em modo **desafio**: o Jogador 1 posiciona os navios no tabuleiro e o Jogador 2 tenta afundá-los sem saber onde estão.

- Tabuleiro único de **8×8 células**
- Jogador 1 posiciona os navios usando switches e botão de confirmação
- Jogador 2 atira nas coordenadas tentando destruir todos os navios
- O jogo termina quando todos os navios são destruídos **ou** a pontuação zera

---

## 🚢 Navios

| Navio | Tamanho | Código |
|---|---|---|
| Porta-aviões | 5 células | `2'b00` |
| Fragata | 4 células | `2'b01` |
| Corveta | 3 células | `2'b10` |
| Submarino | 2 células | `2'b11` |

---

## 🎨 Codificação de Cores

| Cor | Código | Significado |
|---|---|---|
| Branco | `2'b11` | Navio intacto |
| Azul | `2'b01` | Água não atingida |
| Vermelho | `2'b00` | Navio atingido (acerto) |
| Amarelo | `2'b10` | Água atingida (erro) |

Cada célula da memória armazena **4 bits**: `[3:2]` = cor, `[1:0]` = tipo do navio.

---

## 🔧 Hardware Utilizado

- **Placa:** Intel DE10-Lite (MAX 10 — 10M50DAF484C7G)
- **Saída de vídeo:** VGA (módulo `VGA_interface` fornecido)
- **Entrada:** 6 switches + 2 botões
- **Displays:** 4 displays de 7 segmentos (HEX0, HEX1, HEX4, HEX5)

### Mapeamento de Hardware

| Componente | Função |
|---|---|
| `SW[2:0]` | Coluna (1–8) |
| `SW[5:3]` | Linha (A–H) |
| `KEY[0]` | Reset (RST) |
| `KEY[1]` | Confirmar |
| `HEX0` | Coluna (número 1–8) |
| `HEX1` | Linha (letra A–H) |
| `HEX4` | Pontuação — unidade |
| `HEX5` | Pontuação — dezena |
| VGA | Tabuleiro 8×8 |

---

## 🏗️ Arquitetura do Projeto

### Fluxo Geral

```
Reset → Pintar tabuleiro de azul → Posicionamento (P1) → Tiro (P2) → Fim de jogo
```

### Módulos Implementados

| Módulo | Descrição |
|---|---|
| `main` | Top-level module — integra todos os módulos |
| `mef_principal` | MEF mestre — orquestra as fases do jogo |
| `MEFPlayer1` | MEF de posicionamento dos navios |
| `MEFPlayer2` | MEF da fase de tiro |
| `Memoria` | Banco de 64 registradores de 4 bits (tabuleiro) |
| `Registrador4Bits` | Registrador com enable — base da memória |
| `Registrador6Bits` | Registrador de 6 bits — guarda última coordenada de tiro |
| `contador_posicionamento` | Controla sequência de posicionamento dos navios |
| `contador_destruicao` | Rastreia hits por navio, detecta destruição |
| `contador_pontuacao` | Gerencia pontuação e detecta game over |
| `contador_64_blocos` | Percorre as 64 células para reset do tabuleiro |
| `verifica_tiro` | Classifica o resultado de um tiro (acerto/erro/repetido) |
| `resetDoAmarelo` | Apaga o amarelo da última jogada errada |
| `debounce` | Elimina bouncing dos botões |
| `detector_borda` | Gera pulso único na borda de subida |
| `display_letra` | Decoder 7 segmentos para letras A–H |
| `display_numero` | Decoder 7 segmentos para números 0–9 |
| `display_pontuacao` | Exibe pontuação em dois displays |
| `FlipFlopD` | Flip-flop D — base dos registradores |
| `mux1bit` | Multiplexador 2:1 de 1 bit |
| `mux4Inp1Bit` | Multiplexador 2:1 de 4 bits |
| `mux2Bits` | Multiplexador 4:1 de 1 bit |
| `mux4para1_4bits` | Multiplexador 4:1 de 4 bits |
| `mux2para1_6bits` | Multiplexador 2:1 de 6 bits |
| `CodMefSigToSlc` | Codificador de sinais das MEFs para seleção do mux |
| `parametros.v` | Definições de cores e tipos de navio |
| `VGA_interface` | Interface VGA (fornecida — não modificar) |

---

## 📁 Estrutura de Arquivos

```
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
├── VGA_interface.v  ← não modificar
└── pbl323.qsf       ← pinout para DE10-Lite
```

## 📚 Disciplina

**TEC498** — Universidade Estadual de Feira de Santana (UEFS)
