require 'logger'
require_relative 'SimcConfig'

module Logging
  def self.Initialize(scriptName)
    @@SimcLogger = Logger.new File.new("#{SimcConfig['LogsFolder']}/SimC.log", 'a')
    @@SimcLogger.progname = 'SimulationCraft'
    @@SimcErrorLogger = Logger.new File.new("#{SimcConfig['LogsFolder']}/SimC.err.log", 'a')
    @@SimcErrorLogger.progname = 'SimulationCraft'
    @@ScriptLogger = Logger.new File.new("#{SimcConfig['LogsFolder']}/Scripts.log", 'a')
    @@ScriptErrorLogger = Logger.new File.new("#{SimcConfig['LogsFolder']}/Scripts.err.log", 'a')
    @@ScriptLogger.progname = scriptName
    @@ScriptErrorLogger.progname = scriptName
  end

  def self.LogScriptDebug(msg)
    puts msg
    @@ScriptLogger.debug msg
  end

  def self.LogScriptInfo(msg)
    puts msg
    @@ScriptLogger.info msg
  end

  def self.LogScriptWarning(msg)
    puts msg
    @@ScriptErrorLogger.warn msg
  end

  def self.LogScriptError(msg)
    puts msg
    @@ScriptErrorLogger.error msg
  end

  def self.LogScriptFatal(msg)
    puts msg
    @@ScriptErrorLogger.fatal msg
  end

  def self.LogSimcDebug(msg)
    print msg
    @@SimcLogger.debug msg
  end

  def self.LogSimcInfo(msg)
    print msg
    @@SimcLogger.info msg
  end

  def self.LogSimcWarning(msg)
    print msg
    @@SimcErrorLogger.warn msg
  end

  def self.LogSimcError(msg)
    print msg
    @@SimcErrorLogger.error msg
  end

  def self.LogSimcFatal(msg)
    print msg
    @@SimcErrorLogger.fatal msg
  end
end
