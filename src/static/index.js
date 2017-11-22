var Elm = require('../elm/Main');
var container = document.getElementById('container');
var app = Elm.Main.embed(container, Math.floor(Math.random() * 0x0FFFFFFF));