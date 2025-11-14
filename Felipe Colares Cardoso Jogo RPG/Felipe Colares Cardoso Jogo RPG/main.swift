//
//  main.swift
//  Felipe Colares Cardoso Jogo RPG
//
//  Created by FELIPE COLARES CARDOSO on 14/11/25.
//

import Foundation

// enums e Structs
// niveis de Equipamento
enum NivelEquipamento { case fraco, forte }

// Atributos dos itens
struct Item { let nome: String; let valor: Int; let tipo: TipoItem }
enum TipoItem { case espada, armadura, pocao, cristal }

//  itens do jogo
let ITENS_DO_JOGO: [String: Item] = [
    "Espada Simples": Item(nome: "Espada Simples", valor: 2, tipo: .espada),
    "Armadura Leve": Item(nome: "Armadura Leve", valor: 2, tipo: .armadura),
    "Espada de Ferro": Item(nome: "Espada de Ferro", valor: 5, tipo: .espada),
    "Armadura Pesada": Item(nome: "Armadura Pesada", valor: 5, tipo: .armadura),
    "Pocao de Cura": Item(nome: "Pocao de Cura", valor: 15, tipo: .pocao),
    "Cristal Raro": Item(nome: "Cristal Raro", valor: 0, tipo: .cristal)
]
// CLASSES
// Monstro atributos do monstro para serem setados abaixo na subclasse
class Monstro {
    let nome: String; var vidaAtual: Int; let ataque: Int; let defesa: Int; let exp: Int; let nivel: Int
    init(nome: String, nivel: Int, vida: Int, ataque: Int, defesa: Int, exp: Int) {
        self.nome = nome; self.nivel = nivel; self.vidaAtual = vida; self.ataque = ataque; self.defesa = defesa; self.exp = exp
    }
}

// Subclasses de Monstros Normais
class Gargula: Monstro {
    convenience init(nivelBase: Int) {
        let nivel = Int.random(in: nivelBase...nivelBase + 1)
        self.init(nome: "Gargula (Nv \(nivel))", nivel: nivel, vida: 15 + nivel, ataque: 6 + nivel, defesa: 2 + nivel, exp: 5 + nivel)
    }
}
class Golem: Monstro {
    convenience init(nivelBase: Int) {
        let nivel = Int.random(in: nivelBase...nivelBase + 1)
        self.init(nome: "Golem (Nv \(nivel))", nivel: nivel, vida: 25 + nivel, ataque: 4 + nivel, defesa: 4 + nivel, exp: 6 + nivel)
    }
}

// Chefe
class Dragao: Monstro {
    convenience init() { self.init(nome: "**DRAGAO (CHEFE)**", nivel: 5, vida: 100, ataque: 20, defesa: 15, exp: 0) }
}

// Jogador
class Heroi {
    var nome: String = "Aventureiro"; var vidaAtual: Int = 30; var vidaMaxima: Int = 30; var manaAtual: Int = 10; var manaMaxima: Int = 10
    var ataqueBase: Int = 5; var defesaBase: Int = 5; var magiaBase: Int = 5
    var nivel: Int = 1; var experiencia: Int = 0; var moedas: Int = 0; var cristaisColetados: Int = 0
    var espadaEquipada: NivelEquipamento = .fraco; var armaduraEquipada: NivelEquipamento = .fraco
    var inventario: [String: Int] = [:]
    var ataqueTotal: Int { return ataqueBase + (espadaEquipada == .forte ? 5 : 2) }
    var defesaTotal: Int { return defesaBase + (armaduraEquipada == .forte ? 5 : 2) }
    var expParaProximoNivel: Int { return 10 + (nivel * 5) }
    func adicionarItem(nome: String, quantidade: Int = 1) {
        inventario[nome] = (inventario[nome] ?? 0) + quantidade
        if nome == "Cristal Raro" { cristaisColetados += quantidade }
    }
    // chamar funcao que equipa o item
    func equipar(nivel: NivelEquipamento, tipo: TipoItem) {
        if tipo == .espada { espadaEquipada = nivel; print("Espada equipada: +\(nivel == .forte ? 5 : 2) Ataque.") }
        else if tipo == .armadura { armaduraEquipada = nivel; print("Armadura equipada: +\(nivel == .forte ? 5 : 2) Defesa.") }
    }
}

// VARIAVEIS E FUNCOES principais
var heroi = Heroi(); var passosDados: Int = 0
func lerEntrada() -> String { return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? "" }
func chance(_ p: Int) -> Bool { return Int.random(in: 1...100) <= p }
func fimDeJogo() -> Never { print("\n--- FIM DE JOGO ---"); print("Sua jornada termina aqui."); exit(0) }
func vitoria() -> Never { print("\n--- VOCE VENCEU O JOGO! ---"); heroi.mostrarStatus(); exit(0) }

// STATUS
extension Heroi {
    func mostrarStatus() {
        print("\n--- Status de \(nome) (Nv \(nivel)) ---"); print("Vida: \(vidaAtual)/\(vidaMaxima) | Mana: \(manaAtual)/\(manaMaxima)"); print("Ataque: \(ataqueTotal) | Defesa: \(defesaTotal) | Magia: \(magiaBase)"); print("Moedas: \(moedas) | Cristais: \(cristaisColetados)/3"); print("EXP: \(experiencia)/\(expParaProximoNivel)"); print("---------------------------------")
    }
}

func tentarSubirNivel() { // sobe de nivel e adiciona pontos para os status
    while heroi.experiencia >= heroi.expParaProximoNivel {
        let expSobrando = heroi.experiencia - heroi.expParaProximoNivel; heroi.nivel += 1; heroi.experiencia = expSobrando
        heroi.vidaMaxima += 5; heroi.manaMaxima += 3; heroi.vidaAtual = heroi.vidaMaxima; heroi.manaAtual = heroi.manaMaxima
        print("\nPARABENS! Voce subiu para o Nivel \(heroi.nivel)! Seus status foram restaurados.")
        var pontos = 3; while pontos > 0 {
            print("Pontos restantes: \(pontos). Escolha (a=Ataque, d=Defesa, m=Magia):")
            switch lerEntrada() {
            case "a": heroi.ataqueBase += 1; pontos -= 1; print("Ataque: \(heroi.ataqueBase)")
            case "d": heroi.defesaBase += 1; pontos -= 1; print("Defesa: \(heroi.defesaBase)")
            case "m": heroi.magiaBase += 1; pontos -= 1; print("Magia: \(heroi.magiaBase)")
            default: print("Opcao invalida.")
            }
        }
    }
}

// INVENTARIO
func mostrarInventario(podeUsar: Bool) {
    print("\n--- INVENTARIO (Moedas: \(heroi.moedas)) ---")
    if heroi.inventario.isEmpty { print("Seu inventario esta vazio."); return }
    for (nome, quantidade) in heroi.inventario.filter({ $0.value > 0 }) { print("- \(nome) (x\(quantidade))") }
    if heroi.inventario.keys.contains("Pocao de Cura") && podeUsar {
        print("Digite 'pocao' para usar, ou 'voltar'.")
        if lerEntrada() == "pocao" { usarPocao() }
    }
}

func usarPocao() {
    guard let quantidade = heroi.inventario["Pocao de Cura"], quantidade > 0 else { print("Voce nao tem Pocaos de Cura."); return }
    heroi.inventario["Pocao de Cura"]! -= 1
    if heroi.inventario["Pocao de Cura"]! <= 0 { heroi.inventario.removeValue(forKey: "Pocao de Cura") }
    let cura = ITENS_DO_JOGO["Pocao de Cura"]!.valor
    heroi.vidaAtual = min(heroi.vidaMaxima, heroi.vidaAtual + cura)
    print("Voce bebeu a pocao e recuperou \(cura) de vida! (Vida Atual: \(heroi.vidaAtual))")
}

// BATALHA

func loopDeBatalha(monstro: Monstro) -> Bool {
    print("\n--- INICIO DA BATALHA! ---"); print("Voce encontrou um(a) **\(monstro.nome)**!")
    while heroi.vidaAtual > 0 && monstro.vidaAtual > 0 {
        print("\nSua Vida: \(heroi.vidaAtual) | Mana: \(heroi.manaAtual) | Monstro Vida: \(monstro.vidaAtual)")
        print("Escolha: **A**tacar, **M**agia, **F**ugir, **I**nventario")
        let acao = lerEntrada(); var turnoAcabou = true
        
        switch acao {
        case "a": // Atacar
            let danoBase = Int.random(in: heroi.ataqueTotal/2...heroi.ataqueTotal); let danoCausado = max(0, danoBase - monstro.defesa)
            monstro.vidaAtual -= danoCausado; print("Voce ataca e causa **\(danoCausado)** de dano.")
        case "m": // Magia
            print("Magias: **B**ola de Fogo (3 Mana), **C**ura (5 Mana), **Voltar**")
            switch lerEntrada() {
            case "b": // Bola de Fogo (Dano baseado em Magia) se a mana atual for maior ou igual ao o custo
                let custo = 3; if heroi.manaAtual >= custo { heroi.manaAtual -= custo; let dano = heroi.magiaBase + Int.random(in: 1...5); monstro.vidaAtual -= dano; print("Bola de Fogo causa **\(dano)** de dano!") } else { print("Mana insuficiente."); turnoAcabou = false }
            case "c": // Cura (Cura baseada em Magia) se a mana atual for maior ou igual ao o custo
                let custo = 5; if heroi.manaAtual >= custo { heroi.manaAtual -= custo; let cura = heroi.magiaBase * 2; heroi.vidaAtual = min(heroi.vidaMaxima, heroi.vidaAtual + cura); print("Cura recupera **\(cura)** de vida! (Vida Atual: \(heroi.vidaAtual))") } else { print("Mana insuficiente."); turnoAcabou = false }
            default: turnoAcabou = false
            }
        case "f": // Fugir (tem 50% de chance) se nao conseguir fugir, passa a vez para o monstro
            if chance(50) { print("Voce conseguiu fugir!"); return true } else { print("Nao conseguiu fugir!") }
        case "i": mostrarInventario(podeUsar: true); turnoAcabou = false
        default: print("Acao invalida."); turnoAcabou = false
        }
        
        // Vez do Monstro,  se o turno acabou hora do monstro atacar
        if monstro.vidaAtual > 0 && heroi.vidaAtual > 0 && turnoAcabou {
            print("\nVez do(a) \(monstro.nome)..."); let danoBaseMonstro = Int.random(in: monstro.ataque/2...monstro.ataque)
            let danoRecebido = max(1, danoBaseMonstro - heroi.defesaTotal); heroi.vidaAtual -= danoRecebido
            print("O(A) \(monstro.nome) te acerta, causando **\(danoRecebido)** de dano! (Sua Vida: \(heroi.vidaAtual))")
        }
    }
    if heroi.vidaAtual <= 0 { return false } else if monstro.vidaAtual <= 0 { ganharRecompensas(monstro: monstro); return true }
    return true // ao final do turno comparar vida do heroi e do monstro
}

// drop do monstro
func ganharRecompensas(monstro: Monstro) {
    heroi.experiencia += monstro.exp; print("Voce ganhou **\(monstro.exp)** de experiencia.")
    let drop = Int.random(in: 1...100) // random de 1 a 100
    if drop <= 10 { // 10% chance de dropar cristal
        heroi.adicionarItem(nome: "Cristal Raro"); print("DROP: **CRISTAL RARO**! (\(heroi.cristaisColetados)/3)")
    } else if drop <= 30 { // 20% chance de dropar itens (Equipamentos e Pocoes)
        let itensDropaveis = ITENS_DO_JOGO.values.filter { $0.tipo != .cristal }
        if let item = itensDropaveis.randomElement() { heroi.adicionarItem(nome: item.nome); print("DROP: **\(item.nome)**.") }
    } else { // 70% de chance de dropar Moedas
        let moedas = Int.random(in: 5...15) + monstro.nivel; heroi.moedas += moedas; print("DROP: **\(moedas)** moedas.")
    }
    tentarSubirNivel()
}

// se escolher enfrentar o chefe
func enfrentarChefe() {
    print("\n--- CASTELO: A BATALHA FINAL ---"); print("Voce esta cara a cara com o **DRAGAO**!")
    let dragao = Dragao()
    if loopDeBatalha(monstro: dragao) && heroi.vidaAtual > 0 { vitoria() } else { fimDeJogo() }
}

// MARK: - EXPLORACAO
// funcao para encontro aleatorio com 50% de chance
func criarMonstroAleatorio() -> Monstro { return chance(50) ? Gargula(nivelBase: heroi.nivel) : Golem(nivelBase: heroi.nivel) }

// funcao de exploracao
func explorar() {
    print("\n--- EXPLORACAO ---"); passosDados += 1
    if passosDados % 3 == 0 { entrarNaCidade(); return }
    if chance(50) { // Encontrar monstro (50%)
        let monstro = criarMonstroAleatorio()
        if !loopDeBatalha(monstro: monstro) { fimDeJogo() }
    } else { // Baú ou Nada
        if chance(20) { // 20% do restante (10% total) e Baú
            print("\nVoce encontrou um BAÚ!");
            if chance(5) { heroi.adicionarItem(nome: "Cristal Raro"); print("BAÚ: **CRISTAL RARO**! (\(heroi.cristaisColetados)/3)") } // 5% Cristal
            else if chance(20) { // 20% de Item
                let itensDropaveis = ITENS_DO_JOGO.values.filter { $0.tipo != .cristal };
                if let item = itensDropaveis.randomElement() { heroi.adicionarItem(nome: item.nome); print("BAÚ: **\(item.nome)**.") }
            } else { let moedas = Int.random(in: 10...30); heroi.moedas += moedas; print("BAÚ: **\(moedas)** moedas.") }
        } else { print("Voce segue seu caminho, mas nao encontra nada de interessante.") }
    }
}
// MARK: - CIDADE E LOJA

func entrarNaCidade() {
    print("\n--- CIDADE DE RECANTO (Passo \(passosDados)) ---")
    var naCidade = true; while naCidade {
        print("\nO que fazer? **Loja**, **Curar**, **Castelo** (Chefe), **Explorar** (sair)")
        switch lerEntrada() {
        case "loja": entrarNaLoja()
        case "curar": heroi.vidaAtual = heroi.vidaMaxima; heroi.manaAtual = heroi.manaMaxima; print("Vida e mana restauradas!")
        case "castelo":
            print("Quer ENFRENTAR o Dragao ? (s/n)")
            if lerEntrada() == "s" { naCidade = false; enfrentarChefe() }
        case "explorar": naCidade = false; print("Voce volta para a estrada.")
        default: print("Opcao invalida.")
        }
    }
}

func entrarNaLoja() {
    let precosCompra: [String: Int] = ["Pocao de Cura": 10, "Espada de Ferro": 50, "Armadura Pesada": 50]
    let precoVendaCristal = 30; print("\n--- LOJA (Moedas: \(heroi.moedas)) ---")
    var naLoja = true; while naLoja {
        print("\nO que fazer? **Comprar**, **Vender**, **Sair**")
        switch lerEntrada() {
        case "comprar":
            print("Comprar: 1. Pocao (\(precosCompra["Pocao de Cura"])), 2. Espada Forte (\(precosCompra["Espada de Ferro"])), 3. Armadura Forte (\(precosCompra["Armadura Pesada"])), 4. Voltar")
            switch lerEntrada() {
            case "1": comprarItem(nome: "Pocao de Cura", preco: precosCompra["Pocao de Cura"]!)
            case "2": comprarItem(nome: "Espada de Ferro", preco: precosCompra["Espada de Ferro"]!)
            case "3": comprarItem(nome: "Armadura Pesada", preco: precosCompra["Armadura Pesada"]!)
            default: break
            }
        case "vender":
            mostrarInventario(podeUsar: false); print("Qual item vender? (Cristal vale \(precoVendaCristal)) ou **Voltar**")
            let itemVenda = lerEntrada()
            if heroi.inventario.keys.contains(itemVenda) { venderItem(nome: itemVenda, precoCristal: precoVendaCristal) }
            else if itemVenda != "voltar" { print("Item nao encontrado.") }
        case "sair": naLoja = false; print("Ate mais!")
        default: print("Opcao invalida.")
        }
    }
}

func comprarItem(nome: String, preco: Int) {
    guard let item = ITENS_DO_JOGO[nome] else { print("Item indisponivel."); return }
    if heroi.moedas >= preco {
        heroi.moedas -= preco; heroi.adicionarItem(nome: nome)
        print("Voce comprou **\(nome)** por **\(preco)** moedas! (Moedas: \(heroi.moedas))")
        if nome == "Espada de Ferro" { heroi.equipar(nivel: .forte, tipo: .espada) }
        else if nome == "Armadura Pesada" { heroi.equipar(nivel: .forte, tipo: .armadura) }
    } else { print("Voce precisa de mais moedas.") }
}

func venderItem(nome: String, precoCristal: Int) {
    guard let quantidade = heroi.inventario[nome], quantidade > 0 else { print("Voce nao tem esse item."); return }
    let precoVenda: Int; if nome == "Cristal Raro" { precoVenda = precoCristal; heroi.cristaisColetados -= 1 }
    else if let item = ITENS_DO_JOGO[nome] { precoVenda = max(1, item.valor * 2) } else { precoVenda = 1 }
    
    heroi.inventario[nome]! -= 1; if heroi.inventario[nome]! <= 0 { heroi.inventario.removeValue(forKey: nome) }
    heroi.moedas += precoVenda
    print("Voce vendeu **\(nome)** por **\(precoVenda)** moedas! (Total: \(heroi.moedas))")
}
// MARK: - LOOP PRINCIPAL

func iniciarJogo() {
    print("============================================================")
    print("                                                            ")
    print("                                                            ")
    print("                   A Jornada do Herói                       ")
    print("                                                            ")
    print("                                                            ")
    print("Colete 3 cristais ou derrote o Dragão do castelo para vencer")
    print("                                                            ")
    print("============================================================")
    print("\nQual o nome do herói?"); heroi.nome = readLine() ?? "Aventureiro" // se nao digitar nada, sera chamado de aventureiro
    
    // Itens Iniciais e Equipamento
    heroi.adicionarItem(nome: "Espada Simples"); heroi.adicionarItem(nome: "Armadura Leve"); heroi.adicionarItem(nome: "Pocao de Cura", quantidade: 1); heroi.moedas = 10
    heroi.equipar(nivel: .fraco, tipo: .espada); heroi.equipar(nivel: .fraco, tipo: .armadura)
    //dar boas vindas ( dialogo inicial)
    print("\nBem-vindo(a), **\(heroi.nome)**! Objetivo: 3 Cristais OU Dragao Chefe.")
    // se coletar os 3 cristais, vence o jogo e tem a opçao de encerrar
    while true { // loops de rotina do jogo
        if heroi.cristaisColetados >= 3 {
            print("\nVoce tem 3 CRISTAIS RAROS! Quer terminar o jogo agora? (s/n)")
            if lerEntrada() == "s" { vitoria() } else { print("A aventura continua!") }
        }
        print("\n--- O que fazer? (Passo \(passosDados + 1)) ---")
        print("E: Explorar, I: Inventario, S: Status, Q: Sair, C: Castelo")
        //Definindo funcoes para cada tecla
        switch lerEntrada() {
        case "e": explorar()
        case "i": mostrarInventario(podeUsar: true)
        case "s": heroi.mostrarStatus()
        case "c": enfrentarChefe()
        case "q": fimDeJogo()
        default: print("Opcao invalida.")
        }
    }
}
// Começar o jogo
iniciarJogo()
