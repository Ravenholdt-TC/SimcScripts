# This script was used to convert CSV reports to JSON when we switched our output format.
# It's a one-use script as you see, so not very optimized (as most of the scripts in this folder).
# It'll likely no longer work in the future as we improve our lib.

require 'rubygems'
require 'bundler/setup'
require 'json'
require 'csv'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/SimcConfig'

# Convert Combinator CSV File
def Combinator (reportFile)
  csvFile = "#{reportFile}.csv"
  jsonFile = "#{reportFile}.json"
  report = [ ]

  CSV.foreach(csvFile, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
    actor = [ ]
    row.each_with_index{ |value, index|
      if index == 1 or index == 2
        actor.push(value.to_str)
      else
        actor.push(value.to_i)
      end
    }
    report.push(actor)
  end

  # Sort the report by the DPS value in DESC order
  report.sort! { |x,y| y[3] <=> x[3] }

  # Add the initial rank
  report.each_with_index { |actor, index|
    actor.unshift(index + 1)
  }

  JSONParser.WriteFile(jsonFile, report)
end

# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Demon_Hunter_Havoc")

# Convert Relics CSV File
def Relics (reportFile)
  csvFile = "#{reportFile}.csv"
  jsonFile = "#{reportFile}.json"
  report = [ ]

  CSV.foreach(csvFile, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
    actor = [ ]
    row.each_with_index{ |value, index|
      if index.modulo(2) == 0
        actor.push(value.to_str)
      else
        actor.push(value.to_i)
      end
    }
    report.push(actor)
  end

  t2names = {
    "LightSpeed" => "Light Speed",
    "InfusionOfLight" => "Infusion of Light",
    "SecureInTheLight" => "Secure in the Light",
    "Shocklight" => "Shocklight",
    "MasterOfShadows" => "Master of Shadows",
    "MurderousIntent" => "Murderous Intent",
    "Shadowbind" => "Shadowbind",
    "TormentTheWeak" => "Torment the Weak",
    "ChaoticDarkness" => "Chaotic Darkness",
    "DarkSorrows" => "Dark Sorrows"
  }
  max_columns = 1
  report.each do |actor|
    actor[0] = t2names[actor[0]] if t2names[actor[0]]
    max_columns = actor.length if actor.length > max_columns
  end
  max_columns -= 1
  max_columns /= 2
  # Header
  def hashElementType (value)
    return { "type" => value }
  end
  header = [ hashElementType("string") ]
  for i in 1..max_columns
    header.push(hashElementType("number"))
    header.push(hashElementType("string"))
  end
  report.unshift(header)

  JSONParser.WriteFile(jsonFile, report)
end

# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Priest_Shadow")

# Convert Trinkets CSV File
def Trinkets (reportFile)
  csvFile = "#{reportFile}.csv"
  jsonFile = "#{reportFile}.json"
  report = [ ]

  CSV.foreach(csvFile, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
    actor = [ ]
    row.each_with_index{ |value, index|
      if index == 0 || $. == 1
        actor.push(value.to_str)
      else
        actor.push(value.to_i)
      end
    }
    report.push(actor)
  end

  JSONParser.WriteFile(jsonFile, report)
end

# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Monk_Windwalker")

puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
