Então /^o usuário deve ser salvo$/ do
  user = User.first
  user.name.should == "Robin Sage"
  user.email.should == "robinsage@iamsafe.com"
  user.nickname.should == "sage"
  user.should be_valid_password("foolingyou")
  user.should be_accepted_terms
end

Então /^eu devo ver os erros para os campos obrigatórios$/ do
  page.should have_css("#user_name_input.error")
  page.should have_css("#user_email_input.error")
  page.should have_css("#user_nickname_input.error")
  page.should have_css("#user_password_input.error")
  page.should have_css("#user_accepted_terms_input.error")
end
