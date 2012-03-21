module FileName

  def self.sanitize name
    name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/,"_")
    name = "_#{name}" if name =~ /\A\.+\z/
    name = "unnamed" if name.blank?
    return name.downcase
  end

end
