require_relative 'SimcConfig'

module ProfileHelper
  # Fetch an override profile from the given prefix with the talents matching the file talent string
  def self.GetTalentOverride(prefix, talents)
    Dir.glob("#{SimcConfig['ProfilesFolder']}/#{prefix}_*\.simc").each do |file|
      catch (:unmatchingTalents) do
        if data = file.match(/#{SimcConfig['ProfilesFolder']}\/#{prefix}_([0-3xX]{7})\.simc/)
          talentstring = data[1].downcase
          (0..6).to_a.each do |tier|
            throw :unmatchingTalents if talentstring[tier] != 'x' && talentstring[tier] != talents[tier]
          end
          overrideLines = []
          File.open(file) do |ofile|
            while line = ofile.gets
              line.chomp!
              overrideLines.push(line) unless line.empty?
            end
          end
          return overrideLines
        end
      end
    end
    return []
  end
end
