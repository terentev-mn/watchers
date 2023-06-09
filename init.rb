$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"

require 'redmine'
require 'logger'
require_dependency 'tw_watchers'

Redmine::Plugin.register :watchers do
  name 'Timeweb Watchers'
  author 'Terentev Maksim'
  description 'Convient adding of watchers'
  version '0.0.2'
  url 'https://github.com/terentev-mn/watchers'
  author_url 'https://github.com/terentev-mn'
  settings default: {'add_assigned_user' => true,
                     'show_author' => true,
                     'show_groups' => true,
                    }, partial: 'watchers/settings'
end
