#!/usr/bin/env ruby

$LOAD_PATH.unshift('.')
require 'tokenizer.rb'
require 'parser.rb'
require 'generator.rb'

tokens = Tokenizer.new(File.read("../src/main.at")).tokenize
puts tokens.map(&:inspect).join("\n")
tree = Parser.new(tokens).parse
p tree

generated = Generator.new.generate(tree)
RUNTIME = "function add(x, y) { return x + y };"
TEST = "console.log(f(1, 2));"

File.write('compiled.js',[RUNTIME, generated, TEST].join("\n"))