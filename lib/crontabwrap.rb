# -*- coding: utf-8 -*-

require 'optparse'

#
# Crontab wrapper class
#
class CrontabWrap
  BACKUP_FILE = '.crontab'

  #
  # construct object
  #
  # default BACKUP_FILE is ~/.crontab
  #
  def initialize( param = {} )
    @opt = {
      :debug => false,
      :argv  => ARGV
    }.merge( param )
    @user = ENV['USER']

    parse_args( @opt[:argv] )
  end
  attr_reader :user

  #
  # take all options to crontab
  #
  # do backup if '-e' option given
  #
  def run
    argv = @opt[:argv]

    if ( exec( argv ) )
      if ( argv.include?( '-e' ) )
        backup( argv )
      end
    end
  end

  #
  # parse command line args
  #
  def parse_args( argv )
    opt = OptionParser.new()
    opt.on( '-u USER' ) { |user|
      @user = user
    }
    begin
      opt.parse( argv )
    rescue
    end
  end

  def echo( argv, opt = '' )
    STDERR.puts 'crontab ' + argv.join( " " ) + opt
  end

  def exec( argv, opt = '' )
    echo( argv, " > #{backup_file( @user )}" ) if ( @opt[:debug] )
    system( 'crontab ' + argv.join( " " ) + opt )
  end

  #
  # backup crontab content for each user
  #
  def backup( argv )
    argv = replace_switch_to_display( argv )

    exec( argv, " > #{backup_file( @user )}" )
  end

  #
  # replace '-e' option to '-l'
  #
  # [Param] Array opts
  # [Return] Array
  #
  def replace_switch_to_display( opts )
    opts.map { |opt|
      ( opt == '-e' ) ? '-l' : opt
    }
  end

  #
  # backup file name for crontab content
  #
  def backup_file( user )
    return "~#{user}/#{BACKUP_FILE}"
  end
end
