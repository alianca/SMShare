Factory.define :user do |u|
  u.name "Sage Darkfire"
  u.email "sage.darkfire@example.com"
  u.nickname "sage"
  u.password "123456"
  u.password_confirmation "123456"
  u.accepted_terms true
end