require 'webgen/plugins/menustyles/default'
load_plugin 'webgen/plugins/menustyles/default'

module RSpec
  class BreadcrumbsMenuStyle < MenuStyles::DefaultMenuStyle

    infos( :name => 'MenuStyle/Breadcrumbs',
           :author => 'Aslak Hellesoy',
           :summary => "Plugin for RSpec.rubyforge.org's menu"
           )

    register_handler 'breadcrumbs'

    def internal_build_menu( src_node, menu_tree )
      out = "<div class=\"breadcrumbs\">\n  <ul>\n"
      crumbs = trail(src_node, menu_tree.node_info[:node])
      last_span = false
      crumbs.each do |node|
        unless last_span
          link = node.link_from(src_node)
          last_span = link =~ /<span>/
          li = last_span ? '<li class="selected">' : '<li>'
          out << "    #{li}#{link}</li>\n"
        end
      end
      out << "  </ul>\n</div>\n"
      out << "<div class=\"menu\">\n  <ul>\n"
      if src_node.to_url.to_s =~ /index\.html/
        src_node.parent.each do |node|
          if !(node.to_url.to_s =~ /\.template$|\.page$|\.css$|images/) && src_node.to_url != node.to_url
            link = node.link_from( src_node )
            out << "    <li>#{link}</li>\n"
          end
        end
      end
      out << "  </ul>\n</div>\n"
      out
    end

    def trail(node, root_node)
      nodes = []
      until node.parent.nil?
        nodes << node
        node = node.parent 
      end
      nodes << root_node
      nodes.reverse
    end
  end
end
