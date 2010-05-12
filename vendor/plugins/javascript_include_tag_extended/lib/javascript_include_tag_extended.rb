# # # JavascriptIncludeTagExtended
# # 
# # #see the README file for effects of changes made here
# # 
module ActionView
  module Helpers #:nodoc:
    module AssetTagHelper      
      
      #overwritten to pass order and exlude arguments through to expand_javascript_sources
      def javascript_include_tag(*sources)
        options = sources.extract_options!.stringify_keys
        # need to strip off the js selection options
        html_options = options.dup.delete_if {|k,v| ["concat", "cache", "recursive", "order", "exclude"].include?(k) }
        javascript_paths(*(sources << options)).collect do |source|
          javascript_src_tag(source, html_options)
        end.join("\n")
      end
        
      def javascript_paths(*sources)
        options = sources.extract_options!.stringify_keys
        concat  = options.delete("concat")
        cache   = concat || options.delete("cache")
        recursive = options.delete("recursive")
        
        order = options["order"] || []
        options.delete("order")        
        exclude = options["exclude"] || []
        options.delete("exclude")
        
        if concat || (ActionController::Base.perform_caching && cache)
          joined_javascript_name = (cache == true ? "all" : cache) + ".js"
          joined_javascript_path = File.join(joined_javascript_name[/^#{File::SEPARATOR}/] ? ASSETS_DIR : JAVASCRIPTS_DIR, joined_javascript_name)

          unless ActionController::Base.perform_caching && File.exists?(joined_javascript_path)
            write_asset_file_contents(joined_javascript_path, compute_javascript_paths(sources, recursive, exclude, order))
          end
          path_to_javascript(joined_javascript_name)
        else
          expand_javascript_sources(sources, recursive, exclude, order).map {|source| path_to_javascript(source)}
        end
      end
      
      #overwritten to add support for exclusions and ordering
      def expand_javascript_sources(sources, recursive = false, exclude = [], order = [])
        if sources.include?(:all)
          all_javascript_files = collect_asset_files(JAVASCRIPTS_DIR, ('**' if recursive), '*.js')
          expanded_sources = ((determine_source(:defaults, @@javascript_expansions).dup & all_javascript_files) + all_javascript_files).uniq
        else
          expanded_sources = sources.collect do |source|
            determine_source(source, @@javascript_expansions)
          end.flatten
          expanded_sources << "application" if sources.include?(:defaults) && File.exist?(File.join(JAVASCRIPTS_DIR, "application.js"))
        end
        
        expanded_sources = (order + expanded_sources).uniq
        expanded_sources.reject{ |s| should_file_be_excluded?(s, exclude) }
      end      
      
    private
    
    def should_file_be_excluded?(file, exclude)
      exclude.reject { |e| File.fnmatch?(e, file) == false }.empty? == false
    end          
    
    end #end AssetTagHelper module
  end #end Helper module
end #end ActionView module
          