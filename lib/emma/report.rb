module Emma
  class Report
    def self.from(file)
      new Nokogiri::XML.parse(File.read(file)), file
    end

    def initialize(doc, uri = nil)
      @doc = doc
      @uri = uri
    end

    def inspect
      '#<%s:0x%x %s>' % [self.class, hash, "uri=#{@uri}"]
    end

    def stats
      @stats ||= {
        :packages     => fetch_stat('packages'),
        :classes      => fetch_stat("classes"),
        :methods      => fetch_stat("methods"),
        :source_files => fetch_stat("srcfiles"),
        :source_lines => fetch_stat("srclines"),
      }
    end

    def data
      el = @doc.css("report data all").first or raise Error, "invalid coverage report (missing report data)"
      Node.new el
    end

    private

    def stats_node
      @stats_node ||= @doc.css("report stats").first or raise Error, "invalid coverage report (missing report stats)"
    end

    def fetch_stat(name)
      node = stats_node.css(name).first or raise Error, "could not find stats for #{name}"
      Integer(node['value'])
    end

    class Node
      attr_reader :parent

      def initialize(element)
        @element = element
      end

      def inspect
        '#<%s:0x%x %s>' % [self.class, hash, "type=#{type.inspect} name=#{name.inspect}"]
      end

      def type
        @element.name.to_sym
      end

      def packages
        nodes_from @element.xpath(".//package")
      end

      def classes
        nodes_from @element.xpath(".//class")
      end

      def source_files
        nodes_from @element.xpath(".//srcfile")
      end

      def methods
        nodes_from @element.xpath(".//method")
      end

      def name
        name = @element['name']
        parent = @element.parent
        if parent and not ['data', 'all'].include? parent.name
          name = [Node.new(parent).name, name].join ':'
        end

        name
      end

      def coverages
        @coverages ||= Coverages.new(
          coverage_value_for('class'),
          coverage_value_for('method'),
          coverage_value_for('block'),
          coverage_value_for('line')
        )
      end

      private

      def nodes_from(elements)
        elements.map { |e| Node.new e }
      end

      def coverage_value_for(name)
        node = @element.xpath("./coverage[contains(@type, '#{name}')]").first
        node or raise Error, "could not find coverage element for #{name} in #{@element}"

        if node['value'] =~ /^(\d+)%\s+\(([\d.]+)\/([\d.]+)\)/
          Coverage.new Integer($1), Float($2), Float($3)
        else
          raise Error, "unable to parse #{node['value'].inspect}"
        end
      end
    end

    class Coverages
      attr_reader :klass, :method, :block, :line

      def initialize(klass, method, block, line)
        @klass  = klass
        @method = method
        @block  = block
        @line   = line
      end

      def as_json(opts = nil)
        {
          :class => klass,
          :method => method,
          :block => block,
          :line => line
        }
      end

      def to_json(*args)
        as_json.to_json(*args)
      end
    end

    class Coverage
      attr_reader :percent, :covered, :total

      def initialize(percent, covered, total)
        @percent, @covered, @total = percent, covered, total
      end

      def as_json(opts = nil)
        {
          :percent => @percent,
          :covered => @covered,
          :total   => @total
        }
      end

      def to_json(*args)
        as_json.to_json(*args)
      end
    end

  end
end