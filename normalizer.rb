require 'json'

def get_collection
    #Converts JSON file as Ruby object
    _collection_file = File.open('collection.json')
    _collection_text = File.read(_collection_file)
    _collection_obj = JSON.parse(_collection_text)
    return _collection_obj
end

def get_replace_items(collection)
    #Converts json array as ruby array
    _tree_trunk = collection["replace"]
    _tree_node = _tree_trunk[0]

    return _tree_node
end

def get_remove_items(collection)
    #Converts json array as ruby array
    _list = collection['remove']
    return _list
end

def load_report
    #Open file and read it
    _file = "/home/tmoises/Downloads/estoque_martinho.csv"
    _file_array = Array.new

    #Read file line by line, then converts as array it
    File.readlines(_file).each do |line|
        _file_array.push(line)
    end

    return _file_array
end

def remove_listed_items(removable_itens, list)
    #Remove listed items

    _start_time = Time.now

    _counter = list.length - 1 #Get original array length

    _new_list = Array.new #Create a new array (it will be filtered)
    _allow = true # Could I add the item to the new array or drop it? true = yes, false = no

    #Analyze item by item
    (0.._counter).each do |i|

        _temp_list_item = list[i] # Get the current item.

        # Analyze item by item of removable list
        removable_itens.each do |item|

            #Match ?
            if _temp_list_item.match(item)

                _allow = false #Then I can't add this item to my new array.

                break #Get out now

            end

        end

        # Is it true? Unless that no, I'll add this item to my new array
        if _allow
            _new_list.append(_temp_list_item)
        end

        _allow = true # Set the flag as true (security reasons)

    end

    _end_time = Time.now
    _workload_time = (_end_time - _start_time) * 1000.0

    puts "O processo de remoção levou #{_workload_time} ms."

    return _new_list
end

def search_and_replace_item(item, replace_by, list)

    _counter = list.length

    (0..(_counter - 1)).each do |i|

        _line = list[i]

        if _line.match(item)

            _line[item] = replace_by

            list[i] = _line

        end

    end
    
    return list
end

def replace_listed_items(alterable_items, list)

    _start_time = Time.now

    _new_list = list

    alterable_items.keys.each do |key|

        alterable_items[key].each do |n_son|

            _new_list = search_and_replace_item(n_son, key, _new_list)

        end

    end

    _end_time = Time.now
    _workload_time = (_end_time - _start_time) * 1000.0

    puts "O processo de atualização levou #{_workload_time} ms."

    return _new_list
end


_collections = get_collection
_replace_items = get_replace_items _collections[0]
_remove_items = get_remove_items _collections[1]
_loaded_file = load_report

puts "--- Normalizador de Dados ---"
puts "O arquivo orginal será aberto apenas no modo leitura!"
puts "Foram carregadas #{_loaded_file.length} linhas."

puts "Remoção de linhas iniciada."
_filtered_list = remove_listed_items(_remove_items, _loaded_file)
puts "Remoção [OK]"

puts "Atualização de linhas iniciada."
_normalized_list = replace_listed_items(_replace_items, _filtered_list)
puts "Atualização [OK]"

puts "Normalização finalizada às #{Time.now}"