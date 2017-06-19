require_relative '../SimcConfig'

module SimcHelper
  # Write SimC default profiles path to GeneratedConfig.simc in generated
  def SimcHelper.GenerateSimcConfig()
    File.open("#{SimcConfig::GeneratedFolder}/GeneratedConfig.simc", 'w') do |file|
      file.puts "$(simc_profiles_path)=#{SimcConfig::SimcPath}/profiles"
    end
  end
end
