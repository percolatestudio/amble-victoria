#!/usr/bin/ruby
require 'base'
require 'csv'
require 'soap/wsdlDriver'
require 'rubygems'
require 'nokogiri'

class Atdw < Base
  def initialize
    super()
    @key = '911212349911' # Amble key
    # @key = '955556780022' #Fake key
    @wsdl_url = 'http://national.atdw.com.au/soap/AustralianTourismWebService.asmx?WSDL'
    @proxy    = SOAP::WSDLDriverFactory.new(@wsdl_url).create_rpc_driver
    @rpp = 50 # results per page
  end
  
  def filename
    'atdw.internet'
  end
  
  def normalize
    load
  end
  
  def generate_product_ids(filename = 'atdw_ids.yaml')
    mainQuery = {
      'DistributorKey' => @key,
      'CommandName' => 'QueryProducts',
      'CommandParameters' =><<EOL
<parameters>
  <row><param>PRODUCT_CATEGORY_LIST</param><value>ATTRACTION</value></row>
  <row><param>DATA_GROUP_LIST</param><value>ALL</value></row>
  <row><param>ADDRESS_RETURN</param><value>YES</value></row>
  <row><param>MULTIMEDIA_RETURN</param><value>YES</value></row>
  <row><param>MULTIMEDIA_TYPE</param><value>LANDSCAPE</value></row>  
  <row><param>STATE</param><value>Victoria</value></row>
  <row><param>RESULTS_PER_PAGE</param><value>#{@rpp}</value></row>
</parameters>
EOL
    }
    puts "--- Running mainQuery"
    result = @proxy.CommandHandler(mainQuery)
    stats = find_stats(result.commandHandlerResult)   
    total_pages = (stats[:total_records_found] / @rpp).to_i + 1
        
    puts "Stats for this query: #{stats.inspect}"
    puts "Total pages found: #{total_pages}"
    puts "Records per page: #{@rpp}"
        
    @records += find_products(result.commandHandlerResult)
    
    # 2.upto(total_pages) do |page|
    2.upto(2) do |page_number|
      pageQuery = {
        'DistributorKey' => @key,
        'CommandName' => 'QueryProductsNextPage',
        'CommandParameters' =><<EOL
<parameters>
  <row><param>API_QUERY_ID</param><value>#{stats[:api_query_id]}</value></row>
  <row><param>PAGE_NUMBER</param><value>#{page_number}</value></row>
  <row><param>RESULTS_PER_PAGE</param><value>#{@rpp}</value></row>  
</parameters>
EOL
      }
      puts "--- Running pageQuery for page #{page_number}"
      result = @proxy.CommandHandler(pageQuery)
      @records += find_products(result.commandHandlerResult)
    end
  end
  
  def find_products(xml)
    doc = Nokogiri::XML(xml)
    products = []
    
    doc.xpath("//product_record").each { |product|
      p = {}
      
      p[:id] = product.at_xpath(".//product_id").inner_text
      # r[:category_name] = 'Culture'
      # r[:source_name] = 'Art Spaces Gov Data'
      #       
      # r[:name] = row[0].to_s
      # r[:location] = "#{row[1]}, #{row[2]}, #{row[3]}"
      # r[:webpages_attributes] = [{:url => row[4].to_s}]
      
      
      products << p
    }
    
    if products.empty?
      puts "Hmmm, no products found, maybe there is a problem. XML was: #{xml}"
    end
    
    out_s = open('out.xml', "wb")
    out_s.write(xml)
    out_s.close
    
    products
  end
  
  def find_stats(xml)
    doc  = Nokogiri::XML(xml)

    begin
      {
        :api_query_id => doc.at_xpath("//api_query_id").inner_text,
        :total_records_found => doc.at_xpath("//total_records_found").inner_text.to_i,
        :record_count_this_buffer => doc.at_xpath("//record_count_this_buffer").inner_text.to_i
      }
    rescue Exception => e
      puts "OOOPS, XML: #{xml}"
    end
  end
end

Base.main(Atdw.new)