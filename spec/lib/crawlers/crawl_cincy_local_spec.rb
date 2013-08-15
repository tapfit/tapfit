require 'spec_helper'

describe CrawlCincyLocal do

  it 'should put jobs into resque queue' do
    CrawlCincyLocal.perform(DateTime.now, nil)
  end

end
