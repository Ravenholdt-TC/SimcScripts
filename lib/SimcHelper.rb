require_relative 'SimcConfig'

module SimcHelper
  # Write SimC default profiles path to GeneratedConfig.simc in generated
  def self.GenerateSimcConfig()
    File.open("#{SimcConfig['GeneratedFolder']}/GeneratedConfig.simc", 'w') do |file|
      file.puts "$(simc_profiles_path)=#{SimcConfig['SimcPath']}/profiles"
    end
  end

  # Run a simulation with all args applied in order
  def self.RunSimulation(args)
    command = []

    # Call executable
    command.push("#{SimcConfig['SimcPath']}/simc")

    # Set number of threads to use
    command.push("threads=#{SimcConfig['Threads']}")

    # Set global configurations
    command.push("#{SimcConfig['ConfigFolder']}/SimcGlobalConfig.simc")
    GenerateSimcConfig()
    command.push("#{SimcConfig['GeneratedFolder']}/GeneratedConfig.simc")

    command += args
    system command.join(" ")
  end
end
