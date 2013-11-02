# inspired by:
# http://rubyquiz.com/quiz98.html

# require 'algorithms'
# include Containers

require 'hashie'

module ActiveBacon
  module A
    class Star

      def initialize(adjacency_func, cost_func)
        @adjacency = adjacency_func
        @cost = cost_func
#        no use for distance function yet
#        @distance = distance_func
      end

      def find_path(start, goal)

        result = Hashie::Mash.new(:success? => false)

        visited = {}
       
        pqueue = PriorityQueue.new
        pqueue << [1,  [start,[], 0]]

        until result.success? || pqueue.empty?
          # e.g. start, [], 0
          spot, path_so_far, cost_so_far = pqueue.next

          # if already been there, then skip
          next if visited[spot]

          # [] + start
          new_path = path_so_far + [spot]

          # if goal == spot, return the result
          if goal == spot 
            result.path = new_path 
            result[:success?] = true
            result[:cost] = cost_so_far
          else
            # continue
            visited[spot] = cost_so_far

            @adjacency.call(spot).each do |new_spot|
              # if already been there, skip it
              next if visited[new_spot]
              this_cost = @cost.call(spot, new_spot)

              if this_cost 
                new_cost = cost_so_far + this_cost
                # add to queue
                pqueue << [ new_cost, [new_spot, new_path, new_cost]]
              end
            end
          end
        end # while

        result[:visited] = visited

        return result # success? is false
      end

      class PriorityQueue
        def initialize
          @list = []
        end

        def add(priority, item)
          @list << [priority, @list.length, item]
          @list.sort!
        end

        def <<(pitem)
          add(*pitem)
        end

        def next
          @list.shift[2]
        end

        def empty?
          @list.empty?
        end
      end


    # module Star
    end
  end
end