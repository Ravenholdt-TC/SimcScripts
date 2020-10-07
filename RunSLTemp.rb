require "rubygems"
require "bundler/setup"
require "optparse"
require_relative "lib/SimcConfig"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [-r]"

  opts.on("-r", "Do the run starting from the end") do |r|
    options[:reverse] = r
  end
end.parse!

to_run = {
  "RaceSimulation" => { ### !!! This will also be used for Legendary, and Soulbind simulations
    "Rogue" => [
      "PR_Rogue_Assassination",
      "PR_Rogue_Outlaw",
      "PR_Rogue_Subtlety",
    ],
  },
  "Combinator" => {
    "Rogue" => [
      "T25_Rogue_Assassination !!SetSL!! xxx00xx",
      "T25_Rogue_Outlaw !!SetSL!! x0x00xx",
      "T25_Rogue_Subtlety !!SetSL!! xxx00xx",
    ],
  },
}

# Make links for sims using the same input
to_run["LegendarySimulation"] = to_run["RaceSimulation"]
to_run["SoulbindSimulation"] = to_run["RaceSimulation"]

orders = SimcConfig["RunOrders"]
wow_classes = SimcConfig["RunClasses"]

if options[:reverse]
  wow_classes.reverse!
end

wow_classes.each do |wow_class|
  orders.each do |steps|
    steps.reverse! if options[:reverse]
    steps.each do |order|
      scripts = order[0].clone
      scripts.reverse! if options[:reverse]
      fightstyles = order[1].clone
      fightstyles.reverse! if options[:reverse]
      scripts.each do |script|
        fightstyles.each do |fightstyle|
          next unless to_run[script]
          next unless to_run[script][wow_class]
          commands = to_run[script][wow_class].clone
          commands.reverse! if options[:reverse]
          commands.each do |command|
            #next if command.start_with?("DS_") && fightstyle != "DS" || !command.start_with?("DS_") && fightstyle == "DS"
            if script == "Combinator" && command.include?("!!SetSL!!")
              # Base run for talents + covenants
              specialCommand = command.gsub("!!SetSL!!", "#{wow_class}_Covenants SLBaseCovenants")
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} Default #{specialCommand} q"
              ["Kyrian", "Necrolord", "Night-Fae", "Venthyr"].each do |cov|
                specialCommand = command.gsub("!!SetSL!!", "#{wow_class}_Legendaries 1L")
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{cov} #{specialCommand} q"
                specialCommand = command.gsub("!!SetSL!!", "#{wow_class}_Conduits 3C")
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{cov} #{specialCommand} q"
              end
            elsif script == "SoulbindSimulation"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} Kyrian q"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} Necrolord q"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} Night-Fae q"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} Venthyr q"
            else
              if script == "Combinator"
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} Default #{command} q"
              else
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} q"
              end
            end
          end
        end
      end
    end
  end
end

### HAX: For display on HeroDamage, rename our DS reports to include PR so they show as PR fightstyle.
#Dir.glob("#{SimcConfig["ReportsFolder"]}/*_DS_DS_*.{json,csv}").each do |file|
#  puts "Renaming #{file} for PR..."
#  File.rename(file, file.gsub(/_DS_DS_/, "_DS_PR_"))
#end

puts "All batch simulations done! Press enter!"
gets
