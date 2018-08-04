require 'open3'
require_relative 'Logging'
require_relative 'SimcConfig'

module SimcHelper
  # Convert string into simc name, e.g. "Fortune's Strike" -> "fortunes_strike"
  def self.TokenizeName(name)
    return name.downcase.gsub(/[^0-9a-z_+.% ]/i, '').gsub(' ', '_')
  end

  # Append a simc file to a filestream, used for generating the full simc input file.
  def self.WriteFileToInput(filename, out)
    out.puts
    out.puts("# --- #{filename} ---")
    out.puts(File.read(filename))
    out.puts("# --- End of File ---")
    out.puts
  end

  # Run a simulation with all args applied in order
  def self.RunSimulation(args, simulationFilename="LastInput")
    # Dirty fix for those class/specs separated by an underscore instead of an hyphen
    simulationFilename = simulationFilename.sub('Death_Knight', 'Death-Knight')
    simulationFilename = simulationFilename.sub('Demon_Hunter', 'Demon-Hunter')
    simulationFilename = simulationFilename.sub('Beast_Mastery', 'Beast-Mastery')

    generatedFile = "#{SimcConfig['GeneratedFolder']}/#{simulationFilename}.simc"
    Logging.LogScriptInfo "Writing full SimC Input to #{generatedFile}..."
    File.open(generatedFile, 'w') do |input|
      input.puts "### SimcScripts Full Input, generated #{Time.now}"
      input.puts

      # Special input via script config
      input.puts "threads=#{SimcConfig['Threads']}"
      input.puts "$(simc_profiles_path)=\"#{SimcConfig['SimcPath']}/profiles\""

      # Logs
      logFile = "#{SimcConfig['LogsFolder']}/simc/#{simulationFilename}"
      input.puts "output=#{logFile}.log"
      input.puts "json=#{logFile}.json"

      # Use global simc config file
      WriteFileToInput("#{SimcConfig['ConfigFolder']}/SimcGlobalConfig.simc", input)

      args.flatten.each do |arg|
        if arg.end_with?('.simc')
          # Input File
          WriteFileToInput(arg, input)
        else
          input.puts arg
        end
      end
    end

    # Call executable with full input file
    Logging.LogScriptInfo 'Starting simulations, this may take a while!'
    command = ["#{SimcConfig['SimcPath']}/simc", generatedFile]

    # Run simulation with logging and redirecting output to the terminal
    Open3.popen3(*command) do |stdin, stdout, stderr, thread|
      Thread.new do
        until (line = stdout.gets).nil? do
          line.chomp!
          Logging.LogSimcInfo(line)
        end
      end
      Thread.new do
        until (line = stderr.gets).nil? do
          line.chomp!
          Logging.LogSimcError(line)
        end
      end
      thread.join # Wait for simc process to end
    end
  end
end
