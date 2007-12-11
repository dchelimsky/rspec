module Webby
  class PagesDB
    def immediate_children( page, opts = {} )
      root = page.dir == "" ? "" : "#{page.dir}/"
      rgxp = Regexp.new "\\A#{root}[^/]+$"
      keys = @db.keys.find_all {|k| rgxp =~ k}

      ary  = keys.map {|k| @db[k]}
      ary.flatten!

      return ary unless opts.has_key? :sort_by

      m = opts[:sort_by]
      ary.sort! {|a,b| a.__send__(m) <=> b.__send__(m)}
      ary.reverse! if opts[:reverse]
      ary
    end
  end
  
  class Resource
    def link
      "<a href=\"#{url}\">#{title}</a>"
    end
    
    def order
      (@mdata['order'] || 10000).to_i
    end
    
    def parent
      parent_path = filename == 'index' ? dir.split("/")[0..-2].join("/") : dir
      p = self.class.pages.find( :filename => 'index', :in_directory => parent_path ) rescue nil
      p == self ? nil : p
    end
    
    def path_from_root
      resources = []
      resource = self
      while(resource)
        resources << resource
        resource = resource.parent
      end
      resources.reverse
    end
    
    def siblings
      self.class.pages.siblings(self).reject{|p| p.title.nil?}
    end

    def immediate_children
      self.class.pages.immediate_children(self).reject{|p| p.title.nil?}.select{|p| p.filename == 'index'}
    end
  end
  
  require File.dirname(__FILE__) + '/../../rspec/lib/spec/version'
  class Renderer
    def rspec_version
      Spec::VERSION::STRING
    end

    def svn_tag
      Spec::VERSION::TAG
    end
    
    def breadcrumb_menu(page)
      '<div class="breadcrumb-menu">' + breadcrumbs(page) + menu(page) + '</div>'
    end
    
    def breadcrumbs(page)
      b = binding
      ERB.new(<<-EOF, nil, '-').result(b)
      <div class="breadcrumbs">
        <ul>
        <% page.path_from_root.each do |p| %>
          <% if p != page %>
            <li><%= p.link %></li>
          <% else %>
            <li class="selected"><span><%= p.title %></span></li>
          <% end %>
        <% end %>
        </ul>
      </div>
      EOF
    end

    def menu(page)
      pages = if page.filename == 'index'
        (page.siblings + page.immediate_children).sort{|a,b| a.order <=> b.order}
      else
        []
      end
      
      sanity_check(pages)
      
      b = binding
      ERB.new(<<-EOF, nil, '-').result(b)
      <div class="menu">
        <ul>
        <% pages.each do |p| %>
          <li>
            <%= p.link %>
          </li>
        <% end %>
        </ul>
      </div>
      EOF
    end
    
    def sanity_check(pages)
      orders = pages.map{|p| p.order}
      expected_order = (1..pages.length).to_a
      if orders != expected_order
        raise "Non explicit page ordering:\n" + pages.map{|p| "#{p.order} : #{p.path}"}.join("\n")
      end
    end
  end
end