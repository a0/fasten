class MyRspecWorker < Fasten::Worker
  def do_sum(*args)
    puts "do_sum: #{args}"
    args.sum
  end
end

RSpec.shared_examples 'dsl' do |use_threads|
  process_model = use_threads ? 'threads' : 'processes'

  it "using #{process_model}, runs a simple dsl" do |ex|
    Fasten.cleanup
    Fasten.register name: ex.description, worker_class: MyRspecWorker, use_threads: use_threads do
      task 'starting' do
        result = do_sum 5, 6
        puts "starting: #{result}!"
        result
      end

      task 'finishing', after: 'starting' do
        result = do_sum 7, 8
        puts "finishing: #{result}."
        result
      end

      perform
    end
  end
end

RSpec.describe Fasten do
  it_behaves_like 'dsl', false if OS.posix? && !ENV['FASTEN_RSPEC_NO_PROCESSES']
  it_behaves_like 'dsl', true  unless ENV['FASTEN_RSPEC_NO_THREADS']
end
