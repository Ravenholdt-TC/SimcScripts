require 'zlib'
require 'rubygems/package'
require_relative 'lib/Interactive'
require_relative 'lib/SimcConfig'

filesToPack = "{#{SimcConfig['LogsFolder']},#{SimcConfig['ReportsFolder']},#{SimcConfig['GeneratedFolder']}}/**/*.{json,log,csv,simc,html}"
targetArchive = Time.now.strftime("#{SimcConfig['ArchivesFolder']}/%Y%m%d-%H%M%S.tar.gz")

fileArray = Dir.glob(filesToPack)
if fileArray.length < 1
  puts 'Found nothing to pack...'
  puts 'Press enter to quit...'
  Interactive.GetInputOrArg()
  exit
end

puts "Packaging logs and reports to #{targetArchive}..."
File.open(targetArchive, 'wb') do |archive|
  Zlib::GzipWriter.wrap(archive) do |gz|
    Gem::Package::TarWriter.new(gz) do |tar|
      fileArray.each do |file|
        mode = File.stat(file).mode
        size = File.stat(file).size
        tar.add_file_simple(file, mode, size) do |tf|
          File.open(file, 'rb') do |f|
            while buffer = f.read(1000000)
              tf.write buffer
            end
            print '.'
          end
        end
      end
    end
  end
end
puts
puts

puts 'Deleting old files...'
fileArray.each do |file|
  begin
    FileUtils.rm(file)
    print '.'
  rescue => err
    puts err
  end
end
puts
puts

puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
