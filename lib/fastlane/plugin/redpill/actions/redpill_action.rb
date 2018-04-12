module Fastlane
  module Actions
    class RedpillAction < Action
      def self.run(params)
        UI.message("Start test by using Bluepill: https://github.com/linkedin/bluepill")
        cmd =  bin_bluepill.to_s
        cmd << " --xctestrun-path #{params[:xctestrun_path]}"
        cmd << " -o #{params[:output_dir]}"
        cmd << " -a #{params[:app]}" if params[:app]
        cmd << " -d '#{params[:device]}'"
        cmd << " -r '#{params[:runtime]}'"
        cmd << " -e #{params[:exclude].join(' -e ')}" if params[:exclude].length > 0
        cmd << " -i #{params[:include].join(' -i ')}" if params[:include].length > 0
        cmd << " -H" if params[:headless]
        cmd << " -X #{params[:xcode_path]}" if params[:xcode_path]
        cmd << " -J" if params[:json_output]
        cmd << " -j" if params[:junit_output]
        cmd << " -p" if params[:plain_output]
        cmd << " -l" if params[:list_tests]
        cmd << " -n #{params[:num_sims]}"
        cmd << " -R #{params[:error_retries]}"
        cmd << " -f #{params[:failure_tolerance]}"
        cmd << " -F" if params[:only_retry_failed]
        cmd << " -S '#{params[:stuck_timeout]}'"
        cmd << " -T '#{params[:test_timeout]}'"
        cmd << " -C #{params[:repeat_count]}"
        cmd << " --reuse-simulator" if params[:reuse_simulator]
        cmd << " --diagnostics" if params[:diagnostics]
        cmd << " --screenshots-directory #{params[:screenshots_directory]}" if params[:screenshots_directory]
        sh cmd
      end

      def self.bin_bluepill
        File.expand_path('/usr/local/Cellar/bluepill/2.2.0/bin/bluepill', __FILE__)
      end

      def self.description
        "Plugin to use bluepill in fastlane"
      end

      def self.authors
        ["omniprojects"]
      end

      # Nothing to return
      def self.return_value; end

      def self.details
        "Bluepill is powered by LinkedIn: https://github.com/linkedin/bluepill"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app,
                                       env_name: 'REDPILL_APP',
                                       description: 'The path to the host application to execute (your .app)',
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :xctestrun_path,
                                       env_name: 'REDPILL_XCTESTRUN_PATH',
                                       description: 'The path to the .xctestrun file that xcode leaves when you build-for-testing',
                                       optional: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :output_dir,
                                       env_name: 'REDPILL_OUTPUT_DIR',
                                       description: 'Directory where to put output log files (bluepill only)',
                                       optional: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :device,
                                       env_name: 'REDPILL_DEVICE',
                                       default_value: 'iPhone 6',
                                       description: 'On which device to run the app',
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :exclude,
                                       env_name: 'REDPILL_EXCLUDE',
                                       description: 'Exclude a testcase in the set of tests to run (takes priority over include)',
                                       optional: true,
                                       default_value: [],
                                       type: Array),

          FastlaneCore::ConfigItem.new(key: :headless,
                                       env_name: 'REDPILL_HEADLESS',
                                       description: 'Run in headless mode (no GUI)',
                                       default_value: false,
                                       type: TrueClass,
                                       optional: true),

          FastlaneCore::ConfigItem.new(key: :xcode_path,
                                       env_name: 'REDPILL_XCODE_PATH',
                                       description: 'Path to xcode developer directory',
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :include,
                                       env_name: 'REDPILL_INCLUDE',
                                       description: 'Include a testcase in the set of tests to run (unless specified in exclude)',
                                       optional: true,
                                       default_value: [],
                                       type: Array),

          FastlaneCore::ConfigItem.new(key: :json_output,
                                       env_name: 'REDPILL_JSON_OUTPUT',
                                       description: 'Print test timing information in JSON format',
                                       optional: true,
                                       type: TrueClass,
                                       default_value: false),

          FastlaneCore::ConfigItem.new(key: :junit_output,
                                       env_name: 'REDPILL_JUNIT_OUTPUT',
                                       description: 'Print results in JUnit format',
                                       optional: true,
                                       type: TrueClass,
                                       default_value: true),

          FastlaneCore::ConfigItem.new(key: :list_tests,
                                       env_name: 'REDPILL_LIST_TESTS',
                                       description: 'Only list tests in bundle',
                                       optional: true,
                                       type: TrueClass,
                                       default_value: false),

          FastlaneCore::ConfigItem.new(key: :num_sims,
                                       env_name: 'REDPILL_NUM_SIMS',
                                       description: 'Number of simulators to run in parallel',
                                       optional: true,
                                       default_value: 4,
                                       type: Integer),

          FastlaneCore::ConfigItem.new(key: :plain_output,
                                       env_name: 'REDPILL_PLAIN_OUTPUT',
                                       description: 'Print results in plain text',
                                       optional: true,
                                       type: TrueClass,
                                       default_value: false),

          FastlaneCore::ConfigItem.new(key: :error_retries,
                                       env_name: 'REDPILL_ERROR_RETRIES',
                                       description: 'Number of times to recover from simulator/app crashing/hanging and continue running',
                                       optional: true,
                                       default_value: 5,
                                       type: Integer),

          FastlaneCore::ConfigItem.new(key: :failure_tolerance,
                                       env_name: 'REDPILL_FAILURE_TOLERANCE',
                                       description: 'Number of times to retry on test failures',
                                       optional: true,
                                       default_value: 0,
                                       type: Integer),

          FastlaneCore::ConfigItem.new(key: :only_retry_failed,
                                       env_name: 'REDPILL_ONLY_RETRY_FAILED',
                                       description: 'When failure_tolerance > 0, only retry tests that failed',
                                       optional: true,
                                       type: TrueClass,
                                       default_value: false),

          FastlaneCore::ConfigItem.new(key: :runtime,
                                       env_name: 'REDPILL_RUNTIME',
                                       description: 'What runtime to use',
                                       optional: true,
                                       default_value: 'iOS 11.1',
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :stuck_timeout,
                                       env_name: 'REDPILL_STUCK_TIMEOUT',
                                       description: 'Timeout in seconds for a test that seems stuck (no output)',
                                       optional: true,
                                       default_value: '300s',
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :test_timeout,
                                       env_name: 'REDPILL_TEST_TIMEOUT',
                                       description: 'Timeout in seconds for a test that is producing output',
                                       optional: true,
                                       default_value: '300s',
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :repeat_count,
                                       env_name: 'REDPILL_REPEAT_COUNT',
                                       description: 'Number of times we\'ll run the entire test suite (used for load testing)',
                                       optional: true,
                                       default_value: 1,
                                       type: Integer),

          FastlaneCore::ConfigItem.new(key: :reuse_simulator,
                                       env_name: 'REDPILL_REUSE_SIMULATOR',
                                       description: 'Enable reusing simulators between test bundles',
                                       optional: true,
                                       type: TrueClass,
                                       default_value: false),

          FastlaneCore::ConfigItem.new(key: :diagnostics,
                                       env_name: 'REDPILL_DIAGNOSTICS',
                                       description: 'Enable collection of diagnostics in outputDir in case of test failures',
                                       optional: true,
                                       default_value: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :screenshots_directory,
                                       env_name: 'REDPILL_SCREENSHOTS_DIRECTORY',
                                       description: 'Directory where simulator screenshots for failed ui tests will be stored',
                                       optional: true,
                                       type: String),
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.example_code
        ['bluepill(xctestrun_path: "path/to/SomeApp.xctestrun", output_dir: "path/to/reports")']
      end
    end
  end
end
