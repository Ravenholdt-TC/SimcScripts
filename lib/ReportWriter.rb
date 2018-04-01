require_relative 'JSONParser'
require_relative 'Logging'
require_relative 'SimcConfig'
require 'csv'

module ReportWriter
  def self.WriteArrayReport(simulationFilename="LastInput", array)
    reportFile = "#{SimcConfig['ReportsFolder']}/#{simulationFilename}"
    exts = SimcConfig['OutputExt'].split('|')
    exts.each do |ext|
      Logging.LogScriptInfo "Writing report to #{reportFile}.#{ext}..."
      case ext
      when 'json'
        JSONParser.WriteFile("#{reportFile}.json", array)
      when 'csv'
        CSV.open("#{reportFile}.csv", "wb") do |csv|
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
