json.data do
  json.array! @occurrences do |occurrence|

    json.partial! 'occurrence', occurrence: occurrence

  end
end
