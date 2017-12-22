require 'csv'
require 'json'
require 'set'

# First step : Getting headers

def get_recursive_keys(hash, nested_key=nil)
  hash.each_with_object([]) do |(k,v),keys|
    k = "#{nested_key}.#{k}" unless nested_key.nil?
    if v.is_a? Hash
      keys.concat(get_recursive_keys(v, k))
    else
      keys << k
    end
  end
end

json = JSON.parse(File.open("live.json").read)
headings = Set.new
json.each do |hash|
  headings.merge(get_recursive_keys(hash))
end

# Step 2 : Convert heading into an array to populate it

headings = headings.to_a

# Step 3 : Use of dig to look for nested values & join on array to transformed as a string.

CSV.open('file3.csv', 'w') do |csv|
  csv << headings
  json.each do |hash|
    row = headings.map do |h|
      v = hash.dig(*h.split('.'))
      v.is_a?(Array) ? v.join(',') : v
    end
    # Step 4 : Pushing row into a csv file.
    csv << row
  end
end

