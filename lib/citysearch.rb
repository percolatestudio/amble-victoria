#!/usr/bin/ruby
# retrieves citysearch urls for listings

require 'rubygems'
require 'mechanize'
require 'yaml'

module Citysearch
  BASE_URL = 'http://melbourne.citysearch.com.au'
  
  def Citysearch.find(terms)
    begin
      a = Mechanize.new
      a.get(BASE_URL) do |page|
        # Submit the search form
        results = page.form_with(:name => 'kwSearch') do |f|
          f['keyword'] = terms
        end.click_button
      
        # Visit first listing if available
        results.links.each do |link|
          if link.node['class'] =~ /url fn/
            r = {:listing_url => BASE_URL + link.href}
          
            # get phone number off listing page if we can find it
            listing_page = link.click          
            listing_page.search("//p[@class='sideBarText tel']").each do |e|
              tel = e.inner_text
              tel.tr!('^() 1234567890', '') # clean it up
              r[:phone] = tel
            end
          
            return r # found the listing, return the data
          end
        end
      end
    rescue Exception => e
      puts "Caught exception in mechanize: #{e.to_s}"
    end
    
    nil # found nothing
  end
end