# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

CATEGORIES = ["Desenhos e Animações", "Filmes e Televisão", "Jogos e Emulados",
  "Músicas e Podcast", "Programas e Softwares", "Videos e Clipes", "Outras"]
  
CATEGORIES.each do |name|
  Category.create(:name => name)
end