# Projeto-Jogo-RPG-Command-Line-Challenge-Apple-Academy-
Um sistema de jogo RPG feito em linguagem de programação Swift executado no console do compilador. 

Projeto Challenge Apple Academy : Jogo de RPG (Command Line) em Swift // Felipe Colares Cardoso

Este é um jogo simples feito em Swift usando o Terminal (command line).

Objetivo do Jogo

Você pode vencer o jogo de duas maneiras:

Derrotando monstros até conseguir 3 cristais raros
Ou enfrentando o Dragão chefe no castelo
Se perder a batalha, o jogo termina.

Como o jogo funciona
O jogador pode explorar, lutar, comprar itens, usar o inventário e upar atributos.

Sistema de Turnos (Batalha)

Durante uma luta o jogador pode escolher:

Letra =	Ação
A	Atacar com a arma
M	Usar magia (Bola de fogo ou Cura)
F	Tentar fugir (50% chance)
I	Abrir inventário (usar poções)

Monstros também atacam em turnos.

Tipos de Inimigos: Gárgula, Golem, Dragão (Chefão)

Os monstros normais são encontrados aleatoriamente.
O dragão só aparece no castelo.

Sistema de Drops

Após derrotar um monstro, você pode ganhar:

Tipo	Chance
Cristal	10%
Item (poção ou equipamento)	20%
Moedas	70%
Equipamentos

O herói usa:

Uma espada
Uma armadura

Existem equipamentos fracos e fortes.

Eles aumentam ataque e defesa.

Magias

O herói tem duas magias:

Magia	Custo	Efeito
Bola de Fogo	3 mana	Causa dano baseado em Magia
Cura	5 mana	Recupera vida baseado em Magia
Inventário e Loja

Itens são guardados como Dictionary.

Exemplo:

["Espada Simples": 1, "Poção de Cura": 2]

Na cidade (a cada 3 passos), você pode:

Comprar itens
Vender itens
Recuperar vida e mana
Ir ao castelo enfrentar o chefe

Sistema de Nível

Ao ganhar experiência e subir de nível: A vida e mana são restauradas
O jogador pode distribuir 3 pontos nos atributos: Ataque. Defesa, Magia


Tecnologias Usadas: Linguagem: Swift (Command Line)

Estruturas usadas: Classes, Enums, Dictionary, Switch / If Else, Funções

Observação:

Apartir dos meus conhecimentos em C#, busquei na linguagem Swift outras funções semelhantes que julguei necessárias para este projeto como "convenient init" , que é um tipo de inicializador secundário, para versões simplificadas do construtor e conhecida em C# como this(...). 
Foi usado também "extension" que adiciona funcionalidades a tipos existentes, em C# é conhecido como "extension methdos".
