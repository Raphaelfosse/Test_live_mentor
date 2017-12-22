require 'csv'
require 'json'
require 'set'

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

headings = headings.to_a

CSV.open('file3.csv', 'w') do |csv|
  csv << headings
  json.each do |hash|
    row = headings.map do |h|
      v = hash.dig(*h.split('.'))       # Dig out the (possibly) nested value
      v.is_a?(Array) ? v.join(',') : v  # Fix up arrays
    end
    csv << row
  end
end

