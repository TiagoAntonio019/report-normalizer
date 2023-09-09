require 'json'

def get_collection
    _collection_file = File.open('collection.json')
    _collection_text = File.read(_collection_file)
    _collection_obj = JSON.parse(_collection_text)
    return _collection_obj
end

def get_replace_itens(collection)
    _tree_trunk = collection["replace"]
    _tree_node = _tree_trunk[0]

    #_tree_node.keys.each do |key|
        #puts "Key #{key}"
        #_tree_node[key].each do |item|
            #puts item
        #end
    #end
end

def get_remove_itens(collection)
    _list = collection['remove']
    return _list
end

def load_report
    _file = "/home/tmoises/Downloads/estoque.csv"
    _file_array = Array.new

    File.readlines(_file).each do |line|
        _file_array.push(line)
    end

    return _file_array
end

def remove_listed_itens(removable_itens, list)

    _count = 0
    _count_removed = 0

    removable_itens.each do |item|
        list.each do |line|
            _count += 1
            
            if line.match(item)
                _count_removed += 1
                puts "Match line #{line} with item #{item}"
            end
        end
    end

    puts "Was analyzed #{_count} lines and #{_count_removed} was removed."
end

_collections = get_collection
_replace_itens = get_replace_itens _collections[0]
_remove_itens = get_remove_itens _collections[1]
_loaded_file = load_report

puts "Report loaded, total of lines: #{_loaded_file.length}"
remove_listed_itens(_remove_itens, _loaded_file)