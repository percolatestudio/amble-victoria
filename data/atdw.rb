#!/usr/bin/ruby
require 'base'
require 'csv'
require 'soap/wsdlDriver'

class Atdw < Base
  def filename
    'atdw'
  end
  
  def normalize
    key = '955556780022'
    wsdl_url = 'http://national.atdw.com.au/soap/AustralianTourismWebService.asmx?WSDL'
    proxy    = SOAP::WSDLDriverFactory.new(wsdl_url).create_rpc_driver

command_params =<<EOL
<parameters>
  <row><param>PRODUCT_CATEGORY_LIST</param><value>ACCOMM</value></row>
  <row><param>RESULTS_PER_PAGE</param><value>10</value></row>
</parameters>
EOL

    params = {
      'DistributorKey' => key,
      'CommandName' => 'QueryProducts',
      'CommandParameters' => command_params
    }
    result = proxy.CommandHandler(params)
    p result
    
    # $strDistributorKey = 955556780022; // INSERT YOUR DISTRIBUTOR API KEY HERE
    # $client = new SoapClient($strWSDL);
    # 
    # /*************************QUERY PRODUCTS**************************************/
    # $strCommandName = "QueryProducts";
    # $strCommandParameter = "<parameters>";
    # $strCommandParameter .= "<row><param>PRODUCT_CATEGORY_LIST</param><value>ACCOMM</value></row>";
    # $strCommandParameter .= "<row><param>RESULTS_PER_PAGE</param><value>10</value></row>";
    # $strCommandParameter .= "</parameters>";
    # 
    # $param = array('DistributorKey'=> $strDistributorKey, 'CommandName'=>$strCommandName, 'CommandParameters'=>$strCommandParameter);
    # 
    #Call API Method and Get Exchange Rate
    # rate = proxy.getValue(1,'usd','eur')
    # puts "Rate: #{rate}"
    
  #   reader = CSV.open(filename, 'r') 
  #   reader.shift # headers
  #   reader.each do |row| # Organisation,Street,Suburb/Town,Postcode,Website            
  #     r = {}
  #     r[:category_name] = 'Culture'
  #     r[:source_name] = 'Art Spaces Gov Data'
  #           
  #     r[:name] = row[0].to_s
  #     r[:location] = "#{row[1]}, #{row[2]}, #{row[3]}"
  #     r[:webpages_attributes] = [{:url => row[4].to_s}]
  #         
  #     @records << r
  #   end
  end
end

Base.main(Atdw.new)
# SAMPLE CODE
# #Connections
# wsdl_url = 'http://xurrency.com/api.wsdl'
# proxy    = SOAP::WSDLDriverFactory.new(wsdl_url).create_rpc_driver
# 
# #Call API Method and Get Exchange Rate
# rate = proxy.getValue(1,'usd','eur')
# puts "Rate: #{rate}"