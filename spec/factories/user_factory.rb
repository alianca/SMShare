Factory.define :user do |u|
  u.name "Sage Darkfire"
  u.nickname { |u| u.name.downcase.gsub(" ", ".") }
  u.email { |u| "#{u.nickname}@example.com" }
  u.password "123456"
  u.password_confirmation "123456"
  u.accepted_terms true
end