RSpec.describe Fasten do
  it 'can load a YAML file' do
    Fasten.load('spec/yaml_spec.yml')
  end

  it 'can perform a YAML file' do
    `rm -f *.testfile`
    f = Fasten.load('spec/yaml_spec.yml')
    f.perform

    files = Dir['*.testfile']
    items = f.task_list.map { |item| "#{item}.testfile" }
    `rm -f *.testfile`

    raise "Files don't match, files: #{files} items: #{items}" unless files.sort == items.sort
  end
end
