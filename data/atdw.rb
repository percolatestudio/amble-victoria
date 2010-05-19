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
    load_products(read_product_ids)
    # TEST
    # xml = IO.read('product.xml')
    # @records << make_record(xml)
  end
  
  def verify
    records = YAML.load_file('atdw.yaml')
    puts "Loaded #{records.length} records!"
  end
  
  def load_products(ids)
    ids.each_with_index do |id, i|
      begin      
        productQuery = {
          'DistributorKey' => @key,
          'CommandName' => 'GetProduct',
          'CommandParameters' =><<EOL
<parameters>
  <row><param>DATA_GROUP_LIST</param><value>ALL</value></row>
  <row><param>PRODUCT_ID</param><value>#{id}</value></row>
</parameters>
EOL
        }
        puts "--- Running productQuery for id: #{id} (#{i} of #{ids.length} products)"
        result = @proxy.CommandHandler(productQuery)

        @records << make_record(result.commandHandlerResult)
      rescue Exception => e
        puts "HOLY SHIT! product: #{id} exploded with e: #{e.to_s}"
      end
    end
  end
  
  def make_record(xml)
    doc = Nokogiri::XML(xml)
    r = {}
    r[:category_name] = 'Attraction'
    r[:source_name] = 'Tourism Vic Gov Data'
    
    doc.xpath("//product_record").each { |product|
      name = product.at_xpath(".//product_name")
      description = product.at_xpath(".//product_description")

      r[:name] = capitalize_words(name.inner_text) unless name.nil?
      r[:description] = description.inner_text unless description.nil?
    }      

    doc.xpath("//product_address").each { |address|
      address_line_1 = address.at_xpath(".//address_line_1")
      address_line_2 = address.at_xpath(".//address_line_2")
      address_line_3 = address.at_xpath(".//address_line_3")
      city_name = address.at_xpath(".//city_name")
      address_postal_code = address.at_xpath(".//address_postal_code")
      geocode_gda_latitude = address.at_xpath(".//geocode_gda_latitude")
      geocode_gda_longitude = address.at_xpath(".//geocode_gda_longitude")
      
      loc_arry = []
      loc_arry << address_line_1.inner_text unless address_line_1.nil?
      loc_arry << address_line_2.inner_text unless address_line_2.nil?
      loc_arry << address_line_3.inner_text unless address_line_3.nil?
      loc_arry << city_name.inner_text unless city_name.nil?
      loc_arry << address_postal_code.inner_text unless address_postal_code.nil?

      r[:location] = join_address(loc_arry, 0, loc_arry.length)
      r[:lng] = geocode_gda_longitude.inner_text unless geocode_gda_longitude.nil?
      r[:lat] = geocode_gda_latitude.inner_text unless geocode_gda_latitude.nil?      
    }
    
    doc.xpath("//product_communication").each { |comm|
      comm.xpath(".//row").each { |row|
        id = row.at_xpath(".//attribute_id_communication")
        
        unless id.nil?
          if id.inner_text == 'CAPHENQUIR'
            communication_area_code = row.at_xpath(".//communication_area_code")
            communication_detail = row.at_xpath(".//communication_detail")
            
            if communication_area_code and communication_detail
              r[:phone] = "(#{communication_area_code.inner_text}) #{communication_detail.inner_text}"
            end
          end
          
          if id.inner_text == 'CAURENQUIR'
            communication_detail = row.at_xpath(".//communication_detail")
            
            if communication_detail
              r[:webpages_attributes] = [{:url => 'http://' + communication_detail.inner_text}]
            end
          end
        end
      }
    }
 
    doc.xpath("//product_multimedia").each { |comm|
      comm.xpath(".//row").each { |row|
        type = row.at_xpath(".//attribute_id_multimedia_content")
        orientation = row.at_xpath(".//attribute_id_size_orientation")
        url = row.at_xpath(".//server_path")
        
        unless type.nil? or orientation.nil? or url.nil?
          if type.inner_text == 'IMAGE' and orientation.inner_text == 'LANDSCAPE'
              if r[:images_attributes].nil?
                r[:images_attributes] = [{:url => url.inner_text}]
              else
                r[:images_attributes] << {:url => url.inner_text}
              end
          end
        end
      }
    }    
        
    if r.empty?
      puts "Hmmm, empty record found, maybe there is a problem. XML was: #{xml}"
    end
    
    r
  end
  
  def read_product_ids(filename = 'atdw_ids.yaml')
    YAML.load_file(filename)
  end
  
  def write_product_ids(filename = 'atdw_ids.yaml')
    ids = []
    
    mainQuery = {
      'DistributorKey' => @key,
      'CommandName' => 'QueryProducts',
      'CommandParameters' =><<EOL
<parameters>
  <row><param>PRODUCT_CATEGORY_LIST</param><value>ATTRACTION</value></row>
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
        
    ids += find_ids(result.commandHandlerResult)
    
    2.upto(total_pages) do |page_number|
    # 2.upto(2) do |page_number|
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
      ids += find_ids(result.commandHandlerResult)
    end
    
    # write the bad boys to disk
    File.open(filename, 'w' ) { |out| YAML.dump ids, out }
    puts "Wrote #{ids.length} ids"
  end

  def find_ids(xml)
    doc = Nokogiri::XML(xml)
    ids = []
    
    doc.xpath("//product_record").each { |product|
      ids << product.at_xpath(".//product_id").inner_text
    }
    
    if ids.empty?
      puts "Hmmm, no ids found, maybe there is a problem. XML was: #{xml}"
    end
    
    ids
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

#a = Atdw.new
#a.verify