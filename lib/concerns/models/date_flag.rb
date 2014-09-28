# Cloned from: https://github.com/theworkinggroup/date_flag
module Idioma::Concerns::Models::DateFlag
  #VERSION = '0.1.0'

  extend ActiveSupport::Concern

  # Usage:
  #
  # class MyModel < ActiveRecord::Base
  # date_flag :flagged_at, :action => :flag
  # end
  #
  # m = MyModel.new
  # m.flagged? # => false
  # m.flag! # Assigns flag_at to current time
  # m.flag = true # Same as flag!
  # m.flagged? # => true
  module ClassMethods
    def date_flag(field, options = { })
      action = (options[:action] ? options[:action] : field.to_s.sub(/_at$/, '')).to_sym
      query = (options[:query] and options[:query].to_sym or action)

      scope_name =
        case (options[:scope])
        when nil
          action
        when false
          false
        else
          options[:scope].to_s.to_sym
        end

      case (scope_name)
      when false, nil
        # Skip this operation
      when :send, :id
        # TODO: Invalid names, should raise exception or warning
      else
        scope scope_name, lambda { |*flag|
          case (flag.first)
          when false
            where("#{table_name}.#{field} IS NULL")
          when true, nil
            where("#{table_name}.#{field} IS NOT NULL")
          else
            where("#{table_name}.#{field} <=?", flag.first)
          end
        }
      end

      define_method(:"#{action}=") do |value|
        # The action= mutator method is used to manipulate the trigger time.
        # Values of nil, false, empty string, '0' or 0 are presumed to be
        # false and will nil out the time. A DateTime, Date or Time object
        # will be saved as-is, and anything else will just assign the current
        # time.

        case (value)
        when nil, false, '', '0', 0
          write_attribute(field, nil)
        when DateTime, Date, Time
          write_attribute(field, value)
        else
          !read_attribute(field) and write_attribute(field, Time.zone.now.utc)
        end
      end

      define_method(:"is_#{action}?") do
        # The action? accessor method will return true if the date is defined
        # and is prior to the current time, or false otherwise.

        value = read_attribute(field)

        # value ? (value <= Time.zone.now.utc) : false
        value.present?
      end
      alias_method action, :"is_#{action}?"

      define_method(:"#{action}!") do |*at_time|
        # The action! method is used to set the trigger time. If the time is
        # already defined and is in the past, then the time is left unchanged.
        # If it is undefined or in the future, then the current time is
        # substituted.

        value = read_attribute(field)

        at_time = at_time.first || Time.zone.now.utc

        unless (value and (value <= at_time))
          write_attribute(field, at_time)
          save!
        end
      end
    end
  end
end