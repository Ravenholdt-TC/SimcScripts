require 'logger'
require_relative 'SimcConfig'

module Logging
  # Module vars
  @@SimcLogger = Logger.new File.new("#{SimcConfig['LogsFolder']}/SimC.log", 'a')
  @@SimcLogger.progname = 'SimulationCraft'
  @@SimcErrorLogger = Logger.new File.new("#{SimcConfig['LogsFolder']}/SimC.err.log", 'a')
  @@SimcErrorLogger.progname = 'SimulationCraft'
  @@ScriptLogger = Logger.new File.new("#{SimcConfig['LogsFolder']}/Scripts.log", 'a')
  @@ScriptErrorLogger = Logger.new File.new("#{SimcConfig['LogsFolder']}/Scripts.err.log", 'a')

  def self.SetScriptName(name)
    @@ScriptLogger.progname = name
    @@ScriptErrorLogger.progname = name
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
    @@ScriptLogger.warn msg
    @@ScriptErrorLogger.warn msg
  end

  def self.LogScriptError(msg)
    puts msg
    @@ScriptLogger.error msg
    @@ScriptErrorLogger.error msg
  end

  def self.LogScriptFatal(msg)
    puts msg
    @@ScriptLogger.fatal msg
    @@ScriptErrorLogger.fatal msg
  end

  def self.LogSimcDebug(msg)
    puts msg
    @@SimcLogger.debug msg
  end

  def self.LogSimcInfo(msg)
    puts msg
    @@SimcLogger.info msg
  end

  def self.LogSimcWarning(msg)
    puts msg
    @@SimcLogger.warn msg
    @@SimcErrorLogger.warn msg
  end

  def self.LogSimcError(msg)
    puts msg
    @@SimcLogger.error msg
    @@SimcErrorLogger.error msg
  end

  def self.LogSimcFatal(msg)
    puts msg
    @@SimcLogger.fatal msg
    @@SimcErrorLogger.fatal msg
  end
end
