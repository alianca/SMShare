Factory.define :folder do |f|
  f.owner { |owner| owner.association :user }
end
