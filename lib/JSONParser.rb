require 'json'

# Used for parsing json2 output from simc
module JSONParser
  # Returns full JSON hash from a file
  def self.ReadFile(file)
    return JSON.parse(File.read(file))
  end

  # Returns DPS for all profiles and profilesets in a JSON report
  def self.GetAllDPSResults(jsonFile)
    results = { }
    json = ReadFile(jsonFile)
    json['sim']['players'].each do |player|
      results[player['name']] = player['collected_data']['dps']['mean'].round
    end
    json['sim']['profilesets']['results'].each do |player|
      results[player['name']] = player['mean'].round
    end
    return results
  end

  def self.GetPriorityDPSResults(jsonFile)
    results = { }
    json = ReadFile(jsonFile)
    json['sim']['profilesets']['results'].each do |player|
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
  def self.ExtractMetadata(jsonFile, metaFile)
    # Get the meta datas from the json report
    metas = { }
    json = ReadFile(jsonFile)
    metas['build_date'] = json['build_date']
    metas['build_time'] = json['build_time']
    metas['git_revision'] = json['git_revision']
    metas['options'] = json['sim']['options']
    metas['overrides'] = json['sim']['overrides']
    metas['statistics'] = json['sim']['statistics']
    json['sim']['players'].each do |player|
      if player['name'] == 'Template'
        metas['player'] = player
      end
    end

    # Write them into the meta file
    File.open(metaFile, 'w') do |file|
      file.write JSON.pretty_generate(metas)
    end
  end
end
