module AuthorizationsHelper

  CODE = 'XXX'

  def mozca_widget auth_id
    "<iframe name='mozca'
             src='https://mozcapag.com/widgetmozca/widget.php?code=#{CODE}&user=#{auth_id}'
             frameBorder='no'
             width='654' height='500'
             scrolling='no'
             allowtransparency='true'>
     </iframe>"
  end

end
