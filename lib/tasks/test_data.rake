count = (ENV['COUNT'] || 3).to_i

namespace :data do
  desc 'Load all test data'
  task :all => [ :xml, :json, :yaml ]

  desc 'Load some test XML data'
  task :xml => [ :merb_env ] do
    puts "Creating #{count} XML entries"
    count.times do |i|
      test_xml = <<-EOXML
<?xml version="1.0" encoding="UTF-8"?>
<animals>
  <dog id='#{i + 1}'>
    <name>Rufus</name>
    <breed>labrador</breed>
  </dog>
  <dog id='#{i + 2}'>
    <name>Marty</name>
    <breed>whippet</breed>
  </dog>
  <cat name="Matilda"/>
</animals>
EOXML
      Detail.new(:name => "xml-#{i}", :content_type => 'xml',
                 :content => test_xml).save
    end
  end

  desc 'Load some test JSON data'
  task :json => [ :merb_env ] do
    puts "Creating #{count} JSON entries"
    count.times do |i|
      test_json = <<-EOJSON
{
  "animals": {
    "dog": [
      {
        "id": #{i + 1},
        "name": "Rufus",
        "breed": "labrador"
      },
      {
        "id": #{i + 1},
        "name": "Marty",
        "breed": "whippet"
      }
    ],
    "cat": {
      "name": "Matilda"
    }
  }
}
EOJSON
      Detail.new(:name => "json-#{i}", :content_type => 'json',
                 :content => test_json).save
    end
  end

  desc 'Load some test YAML data'
  task :yaml => [ :merb_env ] do
    puts "Creating #{count} YAML entries"
    count.times do |i|
      test_yaml = <<-OEYAML
---
animals:
  cat:
    name: Matilda
  dog:
  - id: #{i + 1}
    name: Rufus
    breed: labrador
  - id: #{i + 2}
    name: Marty
    breed: whippet
OEYAML
      Detail.new(:name => "yaml-#{i}", :content_type => 'yaml',
                 :content => test_yaml).save
    end
  end
end
