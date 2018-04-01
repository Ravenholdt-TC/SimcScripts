require 'date'
require_relative 'JSONParser'

# Used for parsing json2 output from simc
class JSONResults
  def initialize(simulationFilename="LastInput")
    @simulationFilename = simulationFilename
    @logFile = "#{SimcConfig['LogsFolder']}/#{simulationFilename}.json"
    @jsonData = JSONParser.ReadFile(@logFile)
  end

  def getRawJSON()
    return @jsonData
  end

  # Returns DPS for all profiles and profilesets in a JSON report
  def getAllDPSResults()
    results = { }
    @jsonData['sim']['players'].each do |player|
      results[player['name']] = player['collected_data']['dps']['mean'].round
    end
    @jsonData['sim']['profilesets']['results'].each do |player|
      results[player['name']] = player['mean'].round
    end
    return results
  end

  # Returns DPS to target for all profilesets with additional_metrics
  def getPriorityDPSResults()
    results = { }
    @jsonData['sim']['profilesets']['results'].each do |player|
      next unless player['additional_metrics']
      player['additional_metrics'].each do |metric|
        if metric['metric'] == 'Damage per Second to Priority Target/Boss'
          results[player['name']] = metric['mean'].round
        end
      end
    end
    return results
  end

  # Extract metadata from a simulation
  # Additional data is an optional hash that is merged into the JSON output.
  def extractMetadata(additionalData={})
    # Init
    metaFile = "#{SimcConfig['ReportsFolder']}/meta/#{@simulationFilename}.json"
    Logging.LogScriptInfo "Extract metadata from #{@logFile} to #{metaFile}..."

    # Get the meta datas from the json report
    metas = { }
    metas['build_date'] = @jsonData['build_date']
    metas['build_time'] = @jsonData['build_time']
    metas['git_revision'] = @jsonData['git_revision']
    metas['options'] = @jsonData['sim']['options']
    metas['overrides'] = @jsonData['sim']['overrides']
    metas['statistics'] = @jsonData['sim']['statistics']
    @jsonData['sim']['players'].each do |player|
      if player['name'] == 'Template'
        metas['player'] = player
      end
    end
    metas['profilesets_overrides'] = { }
    @jsonData['sim']['profilesets']['results'].each do |player|
      next unless player['overrides']
      metas['profilesets_overrides'][player['name']] = player['overrides']
    end

    # Timestamps
    metas['build_timestamp'] = DateTime.parse(@jsonData['build_date'] + ' ' + @jsonData['build_time'] + ' ' + Time.now.strftime('%:z')).to_time.to_i
    metas['result_timestamp'] = Time.now.to_i

    # Add additional data
    metas.merge!(additionalData)

    # Write them into the meta file
    JSONParser.WriteFile(metaFile, metas)
  end
end
