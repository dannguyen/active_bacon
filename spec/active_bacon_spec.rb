require 'spec_helper'

describe "ActiveBacon" do
  before do 
    @net = SnodeNet.new
    @net.add_pairs 'a', 'b', 1
    @net.add_pairs 'b', 'c', 1
    @net.add_pairs 'c', 'd', 1
  end


  describe 'snodes work, sanity test' do 
    it 'should have node_names' do 
      expect(@net.node_names).to include 'a', 'b', 'c'
    end

    it 'should have proper costs' do 
      expect(@net.nodes['a'].cost_to_node('b')).to eq 1
    end
  end


  describe 'star' do 
    before(:each) do 
      @star = A::Star.new( 
        ->(node){ node.adjacent_nodes }, #adjacency
        ->(a, b){ a.cost_to_node(b) } # cost
      )

      @result = @star.find_path(@net.nodes['a'], @net.nodes['d'])
    end

    context 'results format' do 
      it 'should be a success' do 
        expect(@result).to be_success
      end

      it 'should have :path' do 
        expect(@result.path).to eq ['a', 'b', 'c', 'd']
      end

      it 'should have :cost' do 
        expect(@result.cost).to eq 3
      end

      it 'should return :visited' do 
        expect(@result.visited).to eq( {"a"=>0, "b"=>1, "c"=>2} )
      end
    end

    context 'failure' do 
      before do 
        @net.add_pairs 'x', 'y', 1
        @failure =  @star.find_path(@net.nodes['a'], @net.nodes['x'])
      end

      it 'should return a result failure when no path is found' do 
        expect(@failure).not_to be_success
      end

      it 'should still return a list of visited' do 
        expect(@failure.visited).to eq( {"a"=>0, "b"=>1, "c"=>2, "d"=>3} )
      end

    end
  end



end
