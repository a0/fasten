RSpec.shared_examples 'yaml' do |use_threads|
  process_model = use_threads ? 'threads' : 'processes'

  it "using #{process_model}, can load a YAML file" do |ex|
    runner = Fasten.runner_from_yaml('spec/sample.ruby.yml', name: ex.description, use_threads: use_threads)
    expect(runner.tasks.count).to eq(13)

    file = OS.windows? ? 'spec/sample.win.yml' : 'spec/sample.shell.yml'
    runner = Fasten.runner_from_yaml(file, name: ex.description, use_threads: use_threads)
    expect(runner.tasks.count).to eq(13)
  end

  it "using #{process_model}, can perform a YAML file with ruby code" do |ex|
    FileUtils.rm_rf Dir.glob('*.testfile')
    runner = Fasten.runner_from_yaml('spec/sample.ruby.yml', name: ex.description, use_threads: use_threads)
    runner.perform

    files = Dir['*.testfile']
    items = runner.tasks.map { |item| "#{item}.testfile" }
    FileUtils.rm_rf Dir.glob('*.testfile')

    expect(files.sort).to eq(items.sort)
  end

  it "using #{process_model}, can perform a YAML file with shell code" do |ex|
    FileUtils.rm_rf Dir.glob('*.testfile')
    file = OS.windows? ? 'spec/sample.win.yml' : 'spec/sample.shell.yml'
    runner = Fasten.runner_from_yaml(file, name: ex.description, use_threads: use_threads)
    runner.perform

    files = Dir['*.testfile']
    items = runner.tasks.map { |item| "#{item}.testfile" }
    FileUtils.rm_rf Dir.glob('*.testfile')

    expect(files.sort).to eq(items.sort)
  end
end

RSpec.describe Fasten do
  it_behaves_like 'yaml', false if OS.posix? && !ENV['FASTEN_RSPEC_NO_PROCESSES']
  it_behaves_like 'yaml', true  unless ENV['FASTEN_RSPEC_NO_THREADS']
end
