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


# Estilo padrão da caixa de downloads
style = BoxStyle.create(
  :name => "Estilo smShare",
  :user => nil,
  :box_background => "#FFFFFF",
  :box_border => "#5596AC",
  :header_background => "#5596AC",
  :header_text => "#FFFFFF",
  :upper_text => "#1D4E5D",
  :number_text => "#5596AC",
  :para_text => "#676568",
  :cost_text => "#9C9E9D",
  :form_background => "#FFFFFF",
  :form_border => "#7BBACF",
  :form_text => "#8E8E8E",
  :button_background => "#F27F00",
  :button_text => "#FFFFFF",
  :bottom_text => "#5596AC"
)

# Fundos padrão da caixa de downloads
BoxImage.create(
  :name => "Sem fundo",
  :user => nil,
  :image => nil
)
BoxImage.create(
  :name => "Nuvens smShare",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundo_padrao.png'))
)

