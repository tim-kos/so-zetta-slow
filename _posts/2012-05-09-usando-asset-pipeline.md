---
layout: post
title: Aprendendo a usar a asset pipeline no Rails 3.1+
---

Depois de ter tido alguns problemas com a assets pipeline, tomei vergonha na cara e li o guia no [RailsGuides](http://guides.rubyonrails.org/asset_pipeline.html). Agora que entendi melhor como ele funciona, posso falar um pouco mais a respeito.

Meu primeiro problema com ela foi "Mas para que diabos isso serve se eu não uso CoffeeScript ou SASS?" Depois de um tempo descobri que isso não é verdade. A asset pipeline foi feita para pegar arquivos CSS, JS e imagens, organizá-los e manter esses arquivos em seus respectivos níveis de abstração. O criador do Rails, David Heinemeier Hansson (DHH), falou a respeito disso tudo (e mais) na RailsConf 2011:

{% youtube cGdCI2HhfAU %}

Há três lugares básicos para deixar os assets: app/assets, lib/assets e vendor/assets. Isso nos permite separar código criado por nós e por outros de forma natural - criamos um "pushback" que nos mantém organizados, como o DHH falou em sua apresentação. Dessa forma, é possível saber onde colocar código sem precisar pensar muito ou largar tudo em uma pasta só.

Frameworks
----------

Outro fato legal é que torna-se possível trocar a biblioteca JavaScript padrão do Rails mudando apenas uma linha do Gemfile. Por padrão, temos a seguinte linha:

<code>gem 'jquery-rails'</code>

Caso queira usar a Prototype, apenas modifique para isso:

<code>gem 'prototype-rails'</code>

E podemos colocar vários frameworks assim. Por exemplo, o Bootstrap:

<code>gem 'twitter-bootstrap-rails', :group => :assets</code>

A gem pode ser baixada [aqui](https://github.com/seyhunak/twitter-bootstrap-rails), onde também tem instruções de uso no README.

Caching
-------

Uma última característica que eu achei interessante é relacionada com o caching dos arquivos application.js e application.css. Agora, após a precompilação (_rake assets:precompile_), uma hash MD5 é adicionada ao nome do arquivo, o que impede problemas com arquivos sendo mudados mas tendo versões antigas no cache. Um exemplo:

<code>
	/assets/application-908e25f4bf641868d8683022a5b62f54.js
	/assets/application-4dd5b109ee3439da54f5bdfd78a80473.css
</code>

Caso queira entender melhor, a sessão no guia da RailsGuides é boa. [Leia mais aqui.](http://guides.rubyonrails.org/asset_pipeline.html#in-production)

Acredito que é só. Escrevi este post com o intuito de organizar tudo isso na minha cabeça e, quem sabe, ajudar alguém. Até mais.