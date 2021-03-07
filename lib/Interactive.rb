require_relative "Logging"
require_relative "SimcConfig"
require "yaml"

module Interactive
  # SPECIAL NOTE: By default these function check for existing cmd arguments first.
  # You can disable that behavior by setting the optional parameter to false.

  # Fetch next cmd argument or wait for input
  def self.GetInputOrArg(checkArgs = true)
    arg = checkArgs ? ARGV.shift : nil
    unless arg
      return gets.chomp
    end
    puts arg
    return arg
  end

  # Helper that contains the common parts for the following two functions
  # Returns hash { index: [name, path], ... } of shown templates
  def self.TemplateList(prefixes, contains = [], checkArgs = true)
    if prefixes.is_a?(String)
      prefixes = [prefixes]
    end
    if contains.is_a?(String)
      contains = [contains]
    end
    profiles = {}
    index = 1
    profileSourceFolders = ["#{SimcConfig["ProfilesFolder"]}/"] + SimcConfig["SimcProfileFolders"].collect { |x| "#{SimcConfig["SimcPath"]}/#{x}" }
    profileSourceFolders.each do |folder|
      fromSimcString = folder.start_with?(SimcConfig["SimcPath"]) ? " (via SimC profiles)" : ""
      folder.gsub!('\\', "/")
      prefixes.each do |prefix|
        files = Dir.glob("#{folder}#{prefix}[_\-+a-zA-Z0-9]*\.*")
        files.sort!
        files.each do |file|
          catch (:invalidfile) do
            contains.each do |c|
              throw :invalidfile if !file.include?(c) && !file.include?(c.gsub("-", "_"))
            end
            if profile = file.match(/#{folder}#{prefix}([_\-+a-zA-Z0-9]*)\.\w+/)
              profiles[index] = [profile[1], file]
              puts "#{index}: #{profile[1]}#{fromSimcString}"
              index += 1
            end
          end
        end
      end
    end
    return profiles
  end

  # Offers all templates matching prefix*.<ext> for each prefix in the profile sources
  # Additionally ensure that the file path contains whitelisted strings
  # (strings in whitelist check also check for - replaced by _ automatically)
  # Returns [name, path] with the * part as name and the file path as path
  def self.SelectTemplate(prefixes, contains = [], checkArgs = true)
    puts "Please choose what you want to simulate:"
    profiles = TemplateList(prefixes, contains, checkArgs)
    print "Profile: "
    input = GetInputOrArg(checkArgs)
    if result = profiles.values.find { |x| x.first == input }
      puts
      return result
    end
    index = input.to_i
    unless profiles.has_key?(index)
      Logging.LogScriptFatal "ERROR: Invalid profile index #{input} entered!"
      puts "Press enter to quit..."
      GetInputOrArg(checkArgs)
      exit
    end
    puts
    return profiles[index]
  end

  # Offers all templates matching prefix*.<ext> in the profile sources
  # Additionally ensure that the file path contains whitelisted strings
  # (strings in whitelist check also check for - replaced by _ automatically)
  # Returns the selecitons as array of arrays, multiple selections allowed via [a,b] (no spaces)
  # [[name, file], ...]
  def self.SelectTemplateMulti(prefixes, contains = [], checkArgs = true)
    puts "Please choose what you want to simulate:"
    puts "(You can either enter one, or multiple using the format [a,b] without spaces.)"
    profiles = TemplateList(prefixes, contains, checkArgs)
    print "Profile: "
    input = GetInputOrArg(checkArgs)
    inputArray = [(YAML.load(input))].flatten # Use YAML to automatically parse arrays as such
    templates = []
    inputArray.each do |el|
      if result = profiles.values.find { |x| x.first == el }
        templates.push(result)
        next
      end
      index = el.to_i
      if profiles.has_key?(index)
        templates.push(profiles[index])
      else
        Logging.LogScriptFatal "ERROR: Invalid profile index #{el} entered!"
        puts "Press enter to quit..."
        GetInputOrArg(checkArgs)
        exit
      end
    end
    puts
    return templates
  end

  # Offers all subfolders in prefix in the profiles folder
  def self.SelectSubfolder(prefix, checkArgs = true)
    puts "Please choose a #{prefix} template folder:"
    folders = {}
    index = 1
    files = Dir.glob("#{SimcConfig["ProfilesFolder"]}/#{prefix}/*/")
    files.sort!
    files.each do |file|
      if folder = file.match(/#{SimcConfig["ProfilesFolder"]}\/#{prefix}\/(.*)\//)
        folders[index] = folder[1]
        puts "#{index}: #{folder[1]}"
        index += 1
      end
    end
    print "Folder: "
    input = GetInputOrArg(checkArgs)
    if folders.has_value?(input)
      puts
      return input
    end
    index = input.to_i
    unless folders.has_key?(index)
      Logging.LogScriptFatal "ERROR: Invalid folder index #{input} entered!"
      puts "Press enter to quit..."
      GetInputOrArg(checkArgs)
      exit
    end
    puts
    return "#{folders[index]}"
  end

  # Ask for talent permutation input string
  # Returns array (sets) of array (7 tiers) of arrays (talents)
  # Beware that when specifying multiple sets with overlaps there will be duplicates
  def self.SelectTalentPermutations(defaultTalents, checkArgs = true)
    puts "Please select the talents for permutation:"
    puts "Options: 0-off, 1-left, 2-middle, 3-right, x-Permutation"
    puts "You can specify more per tier by wrapping the wanted columns in []."
    puts "Examples: xxx003x,xxx00[12]x"
    puts "Specifying multiple permutation sets split by a comma without spaces works too."
    puts "To only use the default talents enter: default"
    print "Talents: "
    talentstringinput = GetInputOrArg(checkArgs)
    talentstrings = talentstringinput.split(",")
    talentdataset = []
    talentstrings.each do |talentstring|
      if talentstring == "default"
        talentstring = defaultTalents
      elsif talentstring == "top"
        # Special case, push a talent data set that is a placeholder
        talentdataset.push("top")
        next
      end
      talentdata = []
      isTierArray = false
      tierArray = []
      talentstring.each_char do |talentpart|
        if ["0", "1", "2", "3"].include?(talentpart)
          if isTierArray
            tierArray.push(talentpart.to_i)
          else
            talentdata.push([talentpart.to_i])
          end
        elsif !isTierArray && talentpart.downcase.eql?("x")
          talentdata.push((1..3).to_a)
        elsif !isTierArray && talentpart.eql?("[")
          isTierArray = true
          tierArray = []
        elsif isTierArray && talentpart.eql?("]")
          isTierArray = false
          talentdata.push(tierArray)
        else
          Logging.LogScriptFatal "ERROR: Invalid talent string input #{talentstring}!"
          puts "Press enter to quit..."
          GetInputOrArg(checkArgs)
          exit
        end
      end
      if talentdata.length != 7
        Logging.LogScriptFatal "ERROR: Invalid number of talents! Got #{talentdata.length}"
        puts "Press enter to quit..."
        GetInputOrArg(checkArgs)
        exit
      end
      talentdataset.push(talentdata)
    end
    return talentdataset
  end

  # Choose from a given array. Prompt will show "Please choose a <name>:"
  def self.SelectFromArray(name, array, checkArgs = true)
    puts "Please choose a #{name}:"
    index = 1
    array.each do |item|
      puts "#{index}: #{item}"
      index += 1
    end
    print "#{name}: "
    input = GetInputOrArg(checkArgs)
    if array.include?(input)
      puts
      return input
    end
    index = input.to_i
    if index <= 0 || !array[index - 1]
      Logging.LogScriptFatal "ERROR: Invalid #{name} index #{input} entered!"
      puts "Press enter to quit..."
      GetInputOrArg(checkArgs)
      exit
    end
    puts
    return array[index - 1]
  end
end
