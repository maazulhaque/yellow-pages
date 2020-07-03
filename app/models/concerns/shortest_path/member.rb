module ShortestPath
  module Member
    extend ActiveSupport::Concern

    def shortest_path(member)
      @shortest_paths = {self: nil}
      @queue = [self]
      @visited = Set.new
      @current_member = nil

      while @queue.present? do
        @current_member = @queue.shift
        break if @current_member == member
        @visited.add(@current_member)
        friends = @current_member.friends
        return 'outside of your network' unless friends.present?
        friends.each do |friend|
          if !@visited.include?(friend)
            @shortest_paths[friend] = @current_member
            @queue.push(friend)
          end
        end
      end
      generate_path

    end

    protected

    def generate_path
      return 'outside of your network' unless @current_member

      path = [@current_member.name]
      @current_member = @shortest_paths[@current_member]
      while @current_member do
        path.push('->' + @current_member.name)
        next_member = @shortest_paths[@current_member]
        @current_member = next_member
      end
      path.join
    end
  end
end
