#!/bin/bash

# Atualizar gems (vai pedir a senha de root)
bundle install

# zerar o banco de dados e reiniciar os valores padrão
rake db:drop db:seed
