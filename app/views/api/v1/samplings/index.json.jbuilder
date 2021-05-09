json.data do
  json.array! @samplings do |sampling|

    json.partial! 'sampling', sampling: sampling

  end
end

