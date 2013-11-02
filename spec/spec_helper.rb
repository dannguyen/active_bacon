# Configure Rails Envinronment

require 'rspec'
require 'pry'
require 'active_bacon'

include ActiveBacon

RSpec.configure do |config|

  config.filter_run_excluding skip: true 
  config.run_all_when_everything_filtered = true
  config.filter_run :focus => true

  config.mock_with :rspec

   # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.before(:each) do
#    DatabaseCleaner.start
  end

  config.after(:each) do
#    DatabaseCleaner.clean
  end
end





class Snode < String
  def initialize(*str)
    @nodes = {}
    super
  end


  def attach_to(node, nodecost)
    @nodes[node] = nodecost
  end

  def cost_to_node(node)
    @nodes[node]
  end

  def adjacent_nodes
    @nodes.keys
  end

  def eql?(n)
    self.to_s == n.to_s
  end
end


class SnodeNet
  attr_reader :nodes
  def initialize
    @nodes = {} 
  end

  def add_pairs(n1, n2, cost)
    @a = @nodes.fetch(n1){ @nodes[n1] = Snode.new(n1) }
    @b = @nodes.fetch(n2){ @nodes[n2] = Snode.new(n2) }

    @a.attach_to(@b, cost)
    @b.attach_to(@a, cost)
  end

  def node_names
    @nodes.keys
  end
end

