Hi everyone, 

This repository is about transforming Json file into a CSV. 

As an input, here's a sample of what I have to transform : 

    [
      {
        "id": 0,
        "email": "colleengriffith@quintity.com",
        "tags": [
          "consectetur",
          "quis"
        ],
        "profiles": {
          "facebook": {
            "id": 0,
            "picture": "//fbcdn.com/a2244bc1-b10c-4d91-9ce8-184337c6b898.jpg"
          },
          "twitter": {
            "id": 0,
            "picture": "//twcdn.com/ad9e8cd3-3133-423e-8bbf-0602e4048c22.jpg"
          }
        }
      },
      {
        "id": 1,
        "email": "maryellengriffin@ginkle.com",
        "tags": [
          "veniam",
          "elit",
          "mollit"
        ],
        "profiles": {
          "facebook": {
            "id": 1,
            "picture": "//fbcdn.com/12e070e0-21ea-4663-97d0-46bc9c7b67a4.jpg"
          },
          "twitter": {
            "id": 1,
            "picture": "//twcdn.com/3057792f-5dfb-4c4b-86b5-cce4d6bbf7ac.jpg"
          }
        }
      }
    ]
    
Into a CSV file, who looks like this : 

    id,email,tags,profiles.facebook.id,profiles.facebook.picture,profiles.twitter.id,profiles.twitter.picture
    0,colleengriffith@quintity.com,"consectetur,quis",0,//fbcdn.com/a2244bc1-b10c-4d91-9ce8-184337c6b898.jpg,0,//twcdn.com/ad9e8cd3-3133-423e-8bbf-0602e4048c22.jpg
    1,maryellengriffin@ginkle.com,"veniam,elit,mollit",1,//fbcdn.com/12e070e0-21ea-4663-97d0-46bc9c7b67a4.jpg,1,//twcdn.com/3057792f-5dfb-4c4b-86b5-cce4d6bbf7ac.jpg
    
I have some rules to follow : 
  - No gems use (Bye bye json2csv) 
  - headers in first line (Even the nested one) 
  - Array values to be transformed as a string with delimiter

So here's what I come up with. 

first thing is to get headers from the Json file, using a method, I can have all headers, even the nested one. 

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
    
Then, I use this method on my Json file : 

    json = JSON.parse(File.open("live.json").read)
    headings = Set.new
    json.each do |hash|
      headings.merge(get_recursive_keys(hash))
    end
    headings = headings.to_a
    
I have to convert my headings to an array, to be able to populate it with values. 

Then, the last step is to get the values from the Json file and to populate my CSV file : 

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


And there I go, i got my CSV file, headers and all values below. 

If anyone have others solutions, don't hesitate to participate ! The more solution I get, the more I learn. 




