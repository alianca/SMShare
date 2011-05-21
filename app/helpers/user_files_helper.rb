module UserFilesHelper

  def send_tab a_tab
    content_for :send_tab, a_tab
  end

  def download_box_style file
    # Estilo padrão hardcoded por enquanto
    ({:box_image => "/images/download_box/fundo_padrao.png",
      :box_background => "#ffffff",
      :box_border => "#5596ac",
      :header_background => "#5596ac",
      :header_text => "#ffffff",
      :upper_text => "#1d4e5d",
      :number_text => "#5596aa",
      :para_text => "",
      :cost_text => "#9c9e9d",
      :form_background => "#ffffff",
      :form_border => "#7bbacf",
      :form_text => "#8e8e8e",
      :button_background => "#f27f00",
      :button_text => "#ffffff",
      :bottom_text => "#5596aa"
    }).to_json
  end

end
