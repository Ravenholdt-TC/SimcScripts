require 'date'
require_relative 'JSONParser'

# Used for parsing json2 output from simc
class JSONResults
  def initialize(file)
    @jsonData = JSONParser.ReadFile(file)
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
  def extractMetadata(metaFile, additionalData={})
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

  def extractCombinator(reportFile)
    # Fetch results
    sims = self.getAllDPSResults()
    sims.delete('Template')
    priorityDps = self.getPriorityDPSResults()

    # Our data object
    report = [ ]
    sims.each do |name, value|
      # Split profile name (mostly for web display)
      if data = name.match(/\A(\d+)_([^_]+)_?([^,]*)\Z/)
        actor = [ ]
        actor.push(data[1]) # Talents
        actor.push(data[2].gsub('+', ' + ')) # Tiers

        # Legendaries
        if not data[3].empty?
          legos = data[3].gsub(/_/, ', ')
        else
          legos = 'None'
        end
        actor.push(legos)

        actor.push(value) # DPS
        actor.push(priorityDps[name]) if priorityDps[name] # Priority DPS
        report.push(actor)
      else
        # We should not get here, but leave it as failsafe
        actor = [ ]
        actor.push(name) # Profile Name
        actor.push(value) # DPS
        actor.push(priorityDps[name]) if priorityDps[name] # Priority DPS
        report.push(actor)
      end
    end

    # Sort the report by the DPS value in DESC order
    report.sort! { |x,y| y[3] <=> x[3] }

    # Add the initial rank
    report.each_with_index { |actor, index|
      actor.unshift(index + 1)
    }

    # Write into the report file
    JSONParser.WriteFile(reportFile, report)
  end
end
