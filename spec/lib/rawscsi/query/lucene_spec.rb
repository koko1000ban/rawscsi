$root = File.expand_path('../../../../../', __FILE__)
require "#{$root}/spec/spec_helper"

describe Rawscsi::Query::Lucene do
  it "constructs a lucene query" do
    str = "title:AAA genres:Action"
    query = Rawscsi::Query::Lucene.new(q: str).build
    expect(query).to eq("q=title%3AAAA+genres%3AAction&q.parser=lucene")
  end

  it "constructs a disjunction query" do
    arg = {
      q: "title:AAA genres:Action",
      sort: "rating desc",
      fields: [:title, :genres],
      start: 0,
      limit: 10
    }

    str = Rawscsi::Query::Lucene.new(arg).build
    expect(str).to eq("q=title%3AAAA+genres%3AAction&sort=rating%20desc&start=0&size=10&return=title,genres&q.parser=lucene")
  end
end

