require_relative "JSONParser"
require_relative "Logging"
require_relative "SimcConfig"
require "csv"

module ReportWriter
  def self.WriteArrayReport(results, array, nameOverride = nil)
    fileName = nameOverride ? nameOverride : results.simulationFilename
    reportFile = "#{SimcConfig["ReportsFolder"]}/#{fileName}"
    exts = SimcConfig["OutputExt"].split("|")
    exts.each do |ext|
      Logging.LogScriptInfo "Writing report to #{reportFile}.#{ext}..."
      case ext
      when "json"
        if SimcConfig["HeroOutput"]
          hash = {"results" => array, "metas" => results.extractMetadata()}
          JSONParser.WriteFile("#{reportFile}.json", hash)
        else
          JSONParser.WritePrettyFile("#{reportFile}.json", array)
        end
      when "csv"
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
