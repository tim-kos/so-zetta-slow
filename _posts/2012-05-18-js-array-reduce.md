---
layout: post
title: Atenção ao usar Array.prototype.reduce
---

Estava trabalhando na avaliadora de times do Mojambo ([typeCalc](http://github.com/mojambo/typecalc)) e comecei a usar bastante map(), reduce() e afins para simplificar o código.

Depois de uns testes, cheguei a um problema que levei uns minutos para entender e corrigir, mas que me parece bastante fácil de cometer. Primeiro, a sintaxe do método Array.prototype.reduce é:

Array.prototype.reduce(function (acumulador, elemento) {
	// Implementação
}, initialValue);

Tem mais dois parâmetros no callback (índice do elemento e o array sendo percorrido), mas não são necessários agora. O valor de acumulador é, inicialmente, _initialValue_. A ideia é utilizar reduce() para calcular um valor a partir de todos os elementos do array.

O que eu estava fazendo envolvia um callback assim:

function (acc, el) {
	acc = acc + el;
}

O problema é que o valor do acumulador é o *valor retornado pela última iteração*, então ele inicia em initialValue, processa o primeiro elemento e se torna _undefined_. A solução é simplória:

function (acc, el) {
	acc = acc + el;
	
	return acc;
}

Fiquei tão bravo por ter deixado isso passar que julguei necessário colocar um post na Internet a respeito. Espero ajudar alguém.