# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','test_helper'))
require 'new_relic/agent/instrumentation/sequel_helper'

module NewRelic
  module Agent
    class SequelHelperTest < Minitest::Test
      def test_product_name_from_adapter
        expected_default = "ActiveRecord"
        default = Hash.new(expected_default)

        adapter_to_name = {
          :mysql => "MySQL",
          :mysql2 => "MySQL",
          :postgres => "Postgres",
          :sqlite => "SQLite"
        }

        default.merge(adapter_to_name).each do |adapter, name|
          assert_equal name, NewRelic::Agent::Instrumentation::SequelHelper.product_name_from_adapter(adapter)
        end

        default_result = NewRelic::Agent::Instrumentation::SequelHelper.product_name_from_adapter("YouDontKnowThisAdapter")
        assert_equal expected_default, default_result
      end

      def test_operation_from_method_name
        methods_to_operations = {
          'all' => 'select',
          'first' => 'select',
          'get' => 'select',
          'update' => 'update',
          'update_all' => 'update',
          'update_except' => 'update',
          'update_fields' => 'update',
          'update_only' => 'update',
          'create' => 'insert',
          'save' => 'insert',
          'delete' => 'delete',
          'destroy' => 'delete'
        }

        methods_to_operations.each_pair do |method_name, operation|
          assert_equal operation, NewRelic::Agent::Instrumentation::SequelHelper.operation_from_method_name(method_name)
        end
      end
    end
  end
end
