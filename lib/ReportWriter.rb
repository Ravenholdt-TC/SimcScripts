require_relative 'JSONParser'
require_relative 'Logging'
require_relative 'SimcConfig'
require 'csv'

module ReportWriter
  def self.WriteArrayReport(baseFilename, array)
    exts = SimcConfig['OutputExt'].split('|')
    exts.each do |ext|
      case ext
      when 'json'
        JSONParser.WriteFile("#{baseFilename}.json", array)
      when 'csv'
        CSV.open("#{baseFilename}.csv", "wb") do |csv|
          array.each do |row|
            csv << row
          end
        end
      else
        Logging.LogScriptError("Unknown report extension #{ext}!")
      end
    end
  end
end
