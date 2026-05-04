module SearchHelper
  def combine_search_fields(fields, keywords, mode)
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