---
layout: post
title: Meus livros favoritos sobre JavaScript
---

JavaScript é uma linguagem bonita. Dinâmica, com tipagem fraca e herança prototípica, é difícil de se entender e usar corretamente. É mais do que um brinquedo.

Já faz um tempo que eu estou com vontade de escrever sobre JavaScript. Resolvi falar um pouco sobre as duas melhores fontes que eu li até agora, além do Google obviamente.

São eles:

+ [JavaScript: The Good Parts (_Douglas Crockford_)](http://www.amazon.com/JavaScript-Good-Parts-ebook/dp/B0026OR2ZY/ref=sr_1_3?ie=UTF8&qid=1321122664&sr=8-3)
		Um clássico. Ouvi falar muito sobre ele em vários cantos da Internet e decidi comprar quando foi citado em quase todas as palestras da trilha JavaScript do The Developer's Conference 2011. É um livro muito bem estruturado, abordando todos os aspectos da linguagem "pura" (sem trabalhar com APIs, bibliotecas, etc). Fala muito sobre a sintaxe e apresenta a idéia das <i>bad parts</i> da linguagem, ou seja, daquelas features que mais prejudicam do que ajudam.
		Entretanto, é um livro bastante denso e dificilmente se entende tudo o que ele está falando numa primeira leitura. Cheguei a ler alguns capítulos três vezes até começar a entender o que estava falando. Recomendo fortemente mexer com JavaScript enquanto lê o livro, além de aprofundar assuntos mais complicados, como expressões regulares e closures.
		Ao final, fala sobre o JSON (JavaScript Object Notation), mostrando algumas de suas vantagens e apresentando o código de um parser seguro para ele, feito em JavaScript. É uma boa forma de ver se está entendendo a linguagem: Tentando ler algum código.
	
+ [Test-Driven JavaScript Development (_Christian Johansen_)](http://www.amazon.com/Test-Driven-JavaScript-Development-Developers-ebook/dp/B004519O02/ref=sr_1_2?ie=UTF8&qid=1321122684&sr=8-2)
		Esse livro tem uma idéia bem diferente do anterior: Nele, o autor ensina a idéia básica por trás do desenvolvimento voltado a testes, apresentando a ferramenta [JsTestDriver](http://code.google.com/p/js-test-driver/) e mostrando vários usos simples. Depois, o livro começa.
		Há vários capítulos explicando como as funções são implementadas pelos interpretadores, como funciona a prototype chain, enfim, o que acontece por trás do JavaScript. Muita atenção é dada para aplicações de closures (como memoização e a module pattern).
		Depois, muito se fala sobre a herança de objetos - primeiro mostrando a quantidade de gambiarra necessária para se implementar "algo parecido com classes", depois partindo para a belíssima forma de herança aproveitando-se natureza prototípica de JavaScript. E ele não acaba aí. Ainda tem capítulos falando sobre event delegation, feature detection e aplicações de Test-Driven Development, tendo um capítulo dedicado ao Node.js, por exemplo.
			É um livro incrivelmente completo e que ajuda a cimentar os conhecimentos sobre JavaScript mostrando um número tremendo de exemplos e de soluções práticas que eu consigo ver uso imediato hoje em dia.

Também estou esperando para ler o [Secrets of the JavaScript Ninja (_John Resig_, _Bear Bibeault_)](http://www.amazon.com/Secrets-JavaScript-Ninja-John-Resig/dp/193398869X), que foi escrito pelo Resig, criador do jQuery. Diz-se que o livro "ensina você a escrever sua própria biblioteca JavaScript". Espero ansioso.