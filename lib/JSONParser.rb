require 'json'

module JSONParser
  # Returns full JSON hash from a file
  def self.ReadFile(file)
    return JSON.parse(File.read(file))
  end

  # Write a hash into a JSON file
  def self.WriteFile(filename, hash)
    File.open(filename, 'w') do |file|
      file.write JSON.pretty_generate(hash)
    end
  end
end
