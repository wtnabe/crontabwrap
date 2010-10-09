require 'helper'

class TestCrontabwrap < Test::Unit::TestCase
  def setup
    @obj = ::CrontabWrap.new
  end

  def test_parse_args
    @obj.parse_args( %w( -a -b -c ) )
    assert_equal( ENV['USER'], @obj.user )
    @obj.parse_args( %w( -u foo ) )
    assert_equal( 'foo', @obj.user )
  end

  def test_replace_switch_to_display
    assert_equal( %w( -l ),
                  @obj.replace_switch_to_display( %w( -l ) ) )
    assert_equal( %w( -u foo -l ),
                  @obj.replace_switch_to_display( %w( -u foo -e ) ) )
  end

  def test_backup_file
    assert_equal( "~foo/#{::CrontabWrap::BACKUP_FILE}",
                  @obj.backup_file( 'foo' ) )
    assert_equal( "~root/#{::CrontabWrap::BACKUP_FILE}",
                  @obj.backup_file( 'root' ) )
  end
end
