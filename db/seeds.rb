# -*- coding: utf-8 -*-
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


BG_NAMES = {
  :blank => "Sem fundo",
  :smshare => "Nuvens smShare",
  :bomboniere => "Bomboniere",
  :carbono => "Carbono",
  :frutas_vermelhas => "Frutas Vermelhas",
  :gelo => "Gelo",
  :lava => "Lava",
  :luzes_urbanas => "Luzes Urbanas",
  :madeira => "Madeira",
  :natal => "Natal",
  :oasis => "Oásis",
  :oleo => "Óleo",
  :orkut => "Orkut",
  :outono => "Outono",
  :purpura => "Púrpura",
  :refrescante => "Refrescante",
  :sonho_infantil => "Sonho Infantil",
  :twitter => "Twitter"
}

def box_bg_for type
  case type
  when :blank
    nil
  else
    File.open('public/images/download_box/fundos/' + type.to_s + '.png')
  end
end

def box_style_name_for type
  case type
  when :smshare
    "Estilo smShare"
  when :blank
    "Facebook"
  else
    BG_NAMES[type]
  end
end


STYLES = {
  :smshare => {
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
  },

  :bomboniere => {
    :box_background => "#E6DCD0",
    :box_border => "#e3725d",
    :header_background => "#e36c56",
    :header_text => "#FFFFFF",
    :upper_text => "#d75a48",
    :number_text => "#d75a48",
    :para_text => "#b5b070",
    :cost_text => "#d75a48",
    :form_background => "#e5e5e5",
    :form_border => "#e36c56",
    :form_text => "#5d5d5d",
    :button_background => "#e36c56",
    :button_text => "#FFFFFF",
    :bottom_text => "#d75a48"
  },

  :carbono => {
    :box_background => "#2c2b2b",
    :box_border => "#3b3b3b",
    :header_background => "#292929",
    :header_text => "#FFFFFF",
    :upper_text => "#777777",
    :number_text => "#ffffff",
    :para_text => "#777777",
    :cost_text => "#777777",
    :form_background => "#ffffff",
    :form_border => "#2e2e2e",
    :form_text => "#494949",
    :button_background => "#494949",
    :button_text => "#FFFFFF",
    :bottom_text => "#9f9f9f"
  },

  :blank => {
    :box_background => "#edeef3",
    :box_border => "#99a6c6",
    :header_background => "#3b5998",
    :header_text => "#FFFFFF",
    :upper_text => "#323232",
    :number_text => "#385a96",
    :para_text => "#323232",
    :cost_text => "#3c5898",
    :form_background => "#ffffff",
    :form_border => "#bbc7d5",
    :form_text => "#767676",
    :button_background => "#3b5998",
    :button_text => "#FFFFFF",
    :bottom_text => "#323232"
  },

  :frutas_vermelhas => {
    :box_background => "#d16555",
    :box_border => "#453245",
    :header_background => "#3d3045",
    :header_text => "#FFFFFF",
    :upper_text => "#050f30",
    :number_text => "#663040",
    :para_text => "#000000",
    :cost_text => "#a33039",
    :form_background => "#eec8ef",
    :form_border => "#ef2f41",
    :form_text => "#a33039",
    :button_background => "#ef2f41",
    :button_text => "#c8c4a4",
    :bottom_text => "#050f30"
  },

  :gelo => {
    :box_background => "#edf1f3",
    :box_border => "#97b9bd",
    :header_background => "#94b8bc",
    :header_text => "#FFFFFF",
    :upper_text => "#465f6c",
    :number_text => "#7fa6ab",
    :para_text => "#465f6c",
    :cost_text => "#448e9a",
    :form_background => "#ffffff",
    :form_border => "#d2e0e1",
    :form_text => "#477d96",
    :button_background => "#9abcc0",
    :button_text => "#ffffff",
    :bottom_text => "#465f6c"
  },

  :lava => {
    :box_background => "#6e0001",
    :box_border => "#450700",
    :header_background => "#b20301",
    :header_text => "#f0b388",
    :upper_text => "#fe8d07",
    :number_text => "#c43c06",
    :para_text => "#fe8d07",
    :cost_text => "#f4b53b",
    :form_background => "#f6b78b",
    :form_border => "#c43c06",
    :form_text => "#a80000",
    :button_background => "#ba1d1b",
    :button_text => "#f4b53b",
    :bottom_text => "#f4b53b"
  },

  :luzes_urbanas => {
    :box_background => "#0d141c",
    :box_border => "#353535",
    :header_background => "#090d14",
    :header_text => "#728356",
    :upper_text => "#a1b77e",
    :number_text => "#b5b070",
    :para_text => "#323729",
    :cost_text => "#6b7358",
    :form_background => "#e5e5e5",
    :form_border => "#000000",
    :form_text => "#2f4056",
    :button_background => "#0d141c",
    :button_text => "#728356",
    :bottom_text => "#36444e"
  },

  :madeira => {
    :box_background => "#451205",
    :box_border => "#7e3f16",
    :header_background => "#4a1d11",
    :header_text => "#ddb97b",
    :upper_text => "#aa733d",
    :number_text => "#cd7b19",
    :para_text => "#aa733d",
    :cost_text => "#cd7b19",
    :form_background => "#ddb97b",
    :form_border => "#834217",
    :form_text => "#4a1d11",
    :button_background => "#834217",
    :button_text => "#ddb97b",
    :bottom_text => "#aa733d"
  },

  :natal => {
    :box_background => "#568f3e",
    :box_border => "#b60c05",
    :header_background => "#bb0400",
    :header_text => "#ddb97b",
    :upper_text => "#44240c",
    :number_text => "#ffffff",
    :para_text => "#44240c",
    :cost_text => "#f8c343",
    :form_background => "#f7e698",
    :form_border => "#bc8332",
    :form_text => "#a33039",
    :button_background => "#a33039",
    :button_text => "#ffffff",
    :bottom_text => "#39280c"
  },

  :oasis => {
    :box_background => "#a69166",
    :box_border => "#2b604c",
    :header_background => "#235d4a",
    :header_text => "#d0ccaa",
    :upper_text => "#444a35",
    :number_text => "#235d4a",
    :para_text => "#444a35",
    :cost_text => "#0d7d81",
    :form_background => "#d2ceac",
    :form_border => "#8d7c57",
    :form_text => "#5d5d5d",
    :button_background => "#bc9b04",
    :button_text => "#c8c4a4",
    :bottom_text => "#444a35"
  },

  :oleo => {
    :box_background => "#fffab1",
    :box_border => "#ebbd1b",
    :header_background => "#c9a707",
    :header_text => "#ffffff",
    :upper_text => "#744101",
    :number_text => "#926b33",
    :para_text => "#b98233",
    :cost_text => "#b88508",
    :form_background => "#e5e5e5",
    :form_border => "#d0b53a",
    :form_text => "#5d5d5d",
    :button_background => "#bc9b04",
    :button_text => "#ffffff",
    :bottom_text => "#6f4515"
  },

  :orkut => {
    :box_background => "#eaf1fd",
    :box_border => "#9bbff5",
    :header_background => "#d9e6f7",
    :header_text => "#769ad1",
    :upper_text => "#669dcf",
    :number_text => "#669dcf",
    :para_text => "#b0b0b0",
    :cost_text => "#bbbbbb",
    :form_background => "#ffffff",
    :form_border => "#95bbf4",
    :form_text => "#8e8e8e",
    :button_background => "#95bbf4",
    :button_text => "#ffffff",
    :bottom_text => "#bbbbbb"
  },

  :outono => {
    :box_background => "#f9ebde",
    :box_border => "#dd6e0c",
    :header_background => "#d2813a",
    :header_text => "#f1e3d7",
    :upper_text => "#725934",
    :number_text => "#d2813a",
    :para_text => "#ce9665",
    :cost_text => "#ce9665",
    :form_background => "#ffffff",
    :form_border => "#ff861a",
    :form_text => "#8e8e8e",
    :button_background => "#d2813a",
    :button_text => "#ffffff",
    :bottom_text => "#ce9665"
  },


  :purpura => {
    :box_background => "#9e234f",
    :box_border => "#3d3739",
    :header_background => "#3a1235",
    :header_text => "#f0b6df",
    :upper_text => "#fa737a",
    :number_text => "#fa737a",
    :para_text => "#3e0f3a",
    :cost_text => "#3e0f3a",
    :form_background => "#efd3e7",
    :form_border => "#42153e",
    :form_text => "#3a1235",
    :button_background => "#42153e",
    :button_text => "#f0b6df",
    :bottom_text => "#3e1438"
  },

  :refrescante => {
    :box_background => "#c6f3d9",
    :box_border => "#59b473",
    :header_background => "#33eeb7",
    :header_text => "#3a7250",
    :upper_text => "#1c622f",
    :number_text => "#32904d",
    :para_text => "#53b26e",
    :cost_text => "#247239",
    :form_background => "#ffffff",
    :form_border => "#53b26e",
    :form_text => "#53b26e",
    :button_background => "#91dcaf",
    :button_text => "#ffffff",
    :bottom_text => "#247239"
  },

  :sonho_infantil => {
    :box_background => "#f4fad6",
    :box_border => "#44afb3",
    :header_background => "#1c8085",
    :header_text => "#b6eae8",
    :upper_text => "#1c8085",
    :number_text => "#1c8085",
    :para_text => "#c1bc67",
    :cost_text => "#1c8085",
    :form_background => "#ffffff",
    :form_border => "#1c8085",
    :form_text => "#60acb4",
    :button_background => "#1c8085",
    :button_text => "#ffffff",
    :bottom_text => "#1c8085"
  },

  :twitter => {
    :box_background => "#aad0e3",
    :box_border => "#292d31",
    :header_background => "#517795",
    :header_text => "#d9f0ee",
    :upper_text => "#202225",
    :number_text => "#517795",
    :para_text => "#202225",
    :cost_text => "#2f4e5f",
    :form_background => "#d7eef6",
    :form_border => "#517795",
    :form_text => "#2f4e5f",
    :button_background => "#516f89",
    :button_text => "#d9f0ee",
    :bottom_text => "#202225"
  }
}

BG_NAMES.each do |k, v|
  img = BoxImage.create(:name => v, :user => nil, :image => box_bg_for(k))
  img.save
  BoxStyle.create({ :name => box_style_name_for(k),
                    :user => nil,
                    :box_background_image => img._id
                  }.merge STYLES[k]).save
end
