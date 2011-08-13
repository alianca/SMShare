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



# Fundos padrão da caixa de downloads
bg_none = BoxImage.create(
  :name => "Sem fundo",
  :user => nil,
  :image => nil
)
bg_clouds = BoxImage.create(
  :name => "Nuvens smShare",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/smshare.png'))
)
bg_bomboniere = BoxImage.create(
  :name => "Bomboniere",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/bomboniere.png'))
)
bg_carbono = BoxImage.create(
  :name => "Carbono",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/carbono.png'))
)
bg_red_fruit = BoxImage.create(
  :name => "Frutas Vermelhas",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/frutas_vermelhas.png'))
)
bg_ice = BoxImage.create(
  :name => "Gelo",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/gelo.png'))
)
bg_lava = BoxImage.create(
  :name => "Lava",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/lava.png'))
)
bg_urban_lights = BoxImage.create(
  :name => "Luzes Urbanas",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/luzes_urbanas.png'))
)
bg_wood = BoxImage.create(
  :name => "Madeira",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/madeira.png'))
)
bg_xmas = BoxImage.create(
  :name => "Natal",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/natal.png'))
)
bg_oil = BoxImage.create(
  :name => "Óleo",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/oleo.png'))
)
bg_orkut = BoxImage.create(
  :name => "Orkut",
  :user => nil,
  :image => File.open(File.join(Rails.root, 'public/images/download_box/fundos/orkut.png'))
)

# Estilos padrão da caixa de downloads
BoxStyle.create(
  :name => "Estilo smShare",
  :user => nil,
  :box_background => "#FFFFFF",
  :box_background_image => bg_clouds._id,
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

BoxStyle.create(
  :name => "Bomboniere",
  :user => nil,
  :box_background => "#E6DCD0",
  :box_background_image => bg_bomboniere._id,
  :box_border => "#d75a48",
  :header_background => "#e36c56",
  :header_text => "#FFFFFF",
  :upper_text => "#d75a48",
  :number_text => "#d75a48",
  :para_text => "#b5b070",
  :cost_text => "#d75a48",
  :form_background => "#e5e5e5",
  :form_border => "#d75a48",
  :form_text => "#5d5d5d",
  :button_background => "#e36c56",
  :button_text => "#FFFFFF",
  :bottom_text => "#d75a48"
)

BoxStyle.create(
  :name => "Carbono",
  :user => nil,
  :box_background => "#2c2b2b",
  :box_background_image => bg_carbono._id,
  :box_border => "#2c2b2b",
  :header_background => "#292929",
  :header_text => "#FFFFFF",
  :upper_text => "#777777",
  :number_text => "#ffffff",
  :para_text => "#777777",
  :cost_text => "#777777",
  :form_background => "#ffffff",
  :form_border => "#2c2b2b",
  :form_text => "#494949",
  :button_background => "#494949",
  :button_text => "#FFFFFF",
  :bottom_text => "#9f9f9f"
)

BoxStyle.create(
  :name => "Facebook",
  :user => nil,
  :box_background => "#edeef3",
  :box_background_image => bg_none._id,
  :box_border => "#3b5998",
  :header_background => "#3b5998",
  :header_text => "#FFFFFF",
  :upper_text => "#323232",
  :number_text => "#385a96",
  :para_text => "#323232",
  :cost_text => "#3c5898",
  :form_background => "#ffffff",
  :form_border => "#3b5998",
  :form_text => "#767676",
  :button_background => "#3b5998",
  :button_text => "#FFFFFF",
  :bottom_text => "#323232"
)

BoxStyle.create(
  :name => "Frutas Vermelhas",
  :user => nil,
  :box_background => "#d16555",
  :box_background_image => bg_red_fruit._id,
  :box_border => "#3d3045",
  :header_background => "#3d3045",
  :header_text => "#FFFFFF",
  :upper_text => "#050f30",
  :number_text => "#663040",
  :para_text => "#000000",
  :cost_text => "#a33039",
  :form_background => "#eec8ef",
  :form_border => "#3d3045",
  :form_text => "#a33039",
  :button_background => "#ef2f41",
  :button_text => "#c8c4a4",
  :bottom_text => "#050f30"
)

BoxStyle.create(
  :name => "Gelo",
  :user => nil,
  :box_background => "#edf1f3",
  :box_background_image => bg_ice._id,
  :box_border => "#94b8bc",
  :header_background => "#94b8bc",
  :header_text => "#FFFFFF",
  :upper_text => "#465f6c",
  :number_text => "#7fa6ab",
  :para_text => "#465f6c",
  :cost_text => "#448e9a",
  :form_background => "#ffffff",
  :form_border => "#94b8bc",
  :form_text => "#477d96",
  :button_background => "#9abcc0",
  :button_text => "#ffffff",
  :bottom_text => "#465f6c"
)

BoxStyle.create(
  :name => "Lava",
  :user => nil,
  :box_background => "#6e0001",
  :box_background_image => bg_lava._id,
  :box_border => "#b20301",
  :header_background => "#b20301",
  :header_text => "#f0b388",
  :upper_text => "#fe8d07",
  :number_text => "#c43c06",
  :para_text => "#fe8d07",
  :cost_text => "#f4b53b",
  :form_background => "#f6b78b",
  :form_border => "#b20301",
  :form_text => "#a80000",
  :button_background => "#ba1d1b",
  :button_text => "#f4b53b",
  :bottom_text => "#f4b53b"
)

BoxStyle.create(
  :name => "Luzes Urbanas",
  :user => nil,
  :box_background => "#0d141c",
  :box_background_image => bg_urban_lights._id,
  :box_border => "#090d14",
  :header_background => "#090d14",
  :header_text => "#728356",
  :upper_text => "#a1b77e",
  :number_text => "#b5b070",
  :para_text => "#323729",
  :cost_text => "#6b7358",
  :form_background => "#e5e5e5",
  :form_border => "#090d14",
  :form_text => "#2f4056",
  :button_background => "#0d141c",
  :button_text => "#728356",
  :bottom_text => "#36444e"
)

BoxStyle.create(
  :name => "Madeira",
  :user => nil,
  :box_background => "#451205",
  :box_background_image => bg_wood._id,
  :box_border => "#4a1d11",
  :header_background => "#4a1d11",
  :header_text => "#ddb97b",
  :upper_text => "#aa733d",
  :number_text => "#cd7b19",
  :para_text => "#aa733d",
  :cost_text => "#cd7b19",
  :form_background => "#ddb97b",
  :form_border => "#4a1d11",
  :form_text => "#4a1d11",
  :button_background => "#834217",
  :button_text => "#ddb97b",
  :bottom_text => "#aa733d"
)

BoxStyle.create(
  :name => "Natal",
  :user => nil,
  :box_background => "#568f3e",
  :box_background_image => bg_xmas._id,
  :box_border => "#bb0400",
  :header_background => "#bb0400",
  :header_text => "#ddb97b",
  :upper_text => "#44240c",
  :number_text => "#ffffff",
  :para_text => "#44240c",
  :cost_text => "#f8c343",
  :form_background => "#f7e698",
  :form_border => "#bb0400",
  :form_text => "#a33039",
  :button_background => "#a33039",
  :button_text => "#ffffff",
  :bottom_text => "#39280c"
)

BoxStyle.create(
  :name => "Óleo",
  :user => nil,
  :box_background => "#fffab1",
  :box_background_image => bg_oil._id,
  :box_border => "#c9a707",
  :header_background => "#c9a707",
  :header_text => "#ffffff",
  :upper_text => "#744101",
  :number_text => "#926b33",
  :para_text => "#b98233",
  :cost_text => "#b88508",
  :form_background => "#e5e5e5",
  :form_border => "#c9a707",
  :form_text => "#5d5d5d",
  :button_background => "#bc9b04",
  :button_text => "#ffffff",
  :bottom_text => "#6f4515"
)

BoxStyle.create(
  :name => "Orkut",
  :user => nil,
  :box_background => "#eaf1fd",
  :box_background_image => bg_orkut._id,
  :box_border => "#d9e6f7",
  :header_background => "#d9e6f7",
  :header_text => "#769ad1",
  :upper_text => "#669dcf",
  :number_text => "#669dcf",
  :para_text => "#b0b0b0",
  :cost_text => "#bbbbbb",
  :form_background => "#ffffff",
  :form_border => "#d9e6f7",
  :form_text => "#8e8e8e",
  :button_background => "#95bbf4",
  :button_text => "#ffffff",
  :bottom_text => "#bbbbbb"
)
