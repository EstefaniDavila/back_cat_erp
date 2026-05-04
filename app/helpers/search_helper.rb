module SearchHelper
  def combine_search_fields(fields, keywords, match_type = "cont")
    condition_key = fields.map { |f| "#{f}_#{match_type}" }.join('_or_')
    { condition_key => keywords }
  end

   def combine_search_fields2(fields, keywords, mode)
    queries = fields.map { |field| "#{field}_cont" } 
    if mode == "text"
      query_hash = queries.zip([keywords].cycle).to_h
    else
      keywords_array = keywords.split
      query_hash = queries.zip(keywords_array.cycle).to_h
    end
    query_hash["_combinator"] = "or"
    query_hash
  end
end
