# -*- coding: utf-8 -*-
module UserFilesHelper

  def send_tab a_tab
    content_for :send_tab, a_tab
  end

  TYPE_NAMES = {
    :grafico => "Gráfico",
    :audio => "Áudio",
    :video => "Vídeo",
    :web => "Web",
    :compactado => "Compactado",
    :documento => "Documento",
    :mobile => "Móvel",
    :programa => "Programa",
    :other => "Desconhecido"
  }

  def type_of mime
    case mime
    when /image.*/ then :grafico
    when /audio.*/ then :audio
    when /video.*/ then :video
    when /text(.*)/
      case $1
      when /(html|javascript|css)/ then :web
      else :document
      end
    when /application(.*)/
      case $1
      when /(x-gzip|x-tar|zip|x-rar)/ then :compactado
      when /(word|rtf|pdf|postscript)/ then :documento
      when /(jar|vnd.android.package-archive)/ then :mobile
      else :programa
      end
    else :other
    end
  end

  def name_for type
    TYPE_NAMES[type]
  end

  def icon_for type
    "search/icone-" + type.to_s + ".png"
  end

  def thumb_for type
    "search/thumb-" + type.to_s + ".png"
  end

end
