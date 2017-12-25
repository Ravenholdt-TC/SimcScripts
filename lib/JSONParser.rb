require 'json'
require_relative 'Logging'

module JSONParser
  # Returns full JSON hash from a file
  def self.ReadFile(file)
    begin
      return JSON.parse(File.read(file))
    rescue => err
      Logging.LogScriptFatal err
      exit
    end
  end

  # Write a hash into a JSON file
  def self.WriteFile(filename, hash)
    File.open(filename, 'w') do |file|
      file.write JSON.generate(hash)
    end
  end

  # Write a hash into a JSON file
  def self.WriteFilePretty(filename, hash)
    File.open(filename, 'w') do |file|
      file.write JSON.pretty_generate(hash)
    end
  end
end
