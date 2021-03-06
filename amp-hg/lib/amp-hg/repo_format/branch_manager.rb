##
# Licensing history: originally directly ported from mercurial's source in
# mid-Summer 2009. As a derivative work, the copyright is inherited from Mercurial's
# GPLv2 license.
#
# 4/10/2010: Rewritten from scratch, using just example branchheads.cache
# files in the amp repo, generated by Amp tools. As such all copyright goes to
# Michael J. Edgar for all the code contained herein.
#
##################################################################
#                  Licensing Information                         #
#                                                                #
#  The following code is licensed, as standalone code, under     #
#  the Ruby License, unless otherwise directed within the code.  #
#                                                                #
#  For information on the license of this code when distributed  #
#  with and used in conjunction with the other modules in the    #
#  Amp project, please see the root-level LICENSE file.          #
#                                                                #
#  © Michael J. Edgar and Ari Brown, 2009-2010                   #
#                                                                #
##################################################################

module Amp
  module Mercurial
    module RepositoryFormat
      ##
      # = BranchManager
      # Michael Scott for Amp.
      #
      # More seriously, this class handles reading/writing to the branch cache
      # and figuring out what the head revisions are for each branch and such.
      module BranchManager
        # Going to need easy access to NULL_REV and NULL_ID
        include Amp::Mercurial::RevlogSupport::Node
        
        DEFAULT_PARAMS = {:start => 0, :closed => false}
        
        ##
        # Accesses specific branch head data from the repository. All arguments
        # are optional.
        #
        # @param [Hash] opts the options for the branch head loading
        # @option opts [Boolean] :branch (self[nil].branch) The branch to look up
        # @option opts [Fixnum] :start (0) the revision to start frmo
        # @option opts [Boolean] :closed (false) return closed branches if true
        # @return [Array<String>] a list of node-ids that are the heads of branches
        def branch_heads(opts = {})
          opts = DEFAULT_PARAMS.merge(opts)
          branch = opts[:branch] || default_branch_name
          
          all_heads = quickly_load_branch_heads(opts[:start])[branch]
          all_heads.reverse!
          
          if !opts[:closed]
            # if a branch is closed, then the head changeset's extra field has "extra" => 1
            all_heads.reject! {|node| self[node].extra["close"]}
          end
          
          return all_heads
        end
        
        ##
        # Returns a dict where branch names map to a list of heads of
        # the branch, open heads come before closed
        #
        # @return [Hash{String => String}] a hash, keyed by branch name. Each
        #   key goes to the head of that branch
        def branch_tags
          quickly_load_branch_heads.inject({}) do |hash, (branch, list)|
            # Now we need to try to get an open head, but we'll take a closed
            # one if we have to.
            
            tipmost = list.reverse.find do |node|
              !self[node].extra["close"]
            end
            tipmost ||= list.last
            hash[branch] = tipmost
            hash
          end
        end
        
        private
        
        ##
        # Returns whether the cache is valid or not. Will return false if
        # there is no cache, as well.
        #
        # @return [Hash{String => Array<String>}] a mapping of branch names to a list
        #   of heads of the branch with the same name
        def cache_valid?
          unless cached_heads
            read_results = read_branch_cache
            @cached_heads, @cached_tip_id = read_results[:heads], read_results[:tip_id]
          end
          return self["tip"].node_id == @cached_tip_id
        end
        
        ##
        # Returns the cached heads.
        def cached_heads
          @cached_heads ||= nil
        end
        
        ##
        # Caches the given mapping of branch names to lists of branch heads to file and in memory.
        #
        # @param [Hash{String => Array<String>}] mapping a mapping of branch names to a list
        #   of heads of the branch with the same name
        def cache(mapping)
          write_branch_heads!(mapping)
          @cached_heads = mapping
          @cached_tip_id = self["tip"].node_id
          return mapping
        end
        
        ##
        # Loads all the branch heads, and is where caching logic goes.
        #
        # @return [Hash{String => Array<String>}] a mapping of branch names to a list
        #   of heads of the branch with the same name
        def quickly_load_branch_heads(start = 0)
          if cache_valid?
            return cached_heads
          else
            return cache(scan_for_branch_heads(start, self.size - 1))
          end
        end
        
        ##
        # Does a full scan of each repository node to find the heads of each branch.
        #
        # @param [Fixnum] from (0) the beginning node from which to search.
        # @param [Fixnum] to (self.size - 1) the last node to look at in the search
        # @return [Hash{String => Array<String>}] a mapping of branch names to a list
        #   of heads of the branch with the same name
        def scan_for_branch_heads(from = 0, to = self.size - 1)
          puts "scanning"
          result = ArrayHash.new
          from.upto(to) do |idx|
            changeset = self[idx]
            branch = changeset.branch
            
            # This node might be a head of its branch
            result[branch] << changeset.node_id
            
            # The node's parents are definitely not heads. Remove them.
            changeset.parents.each do |parent|
              result[branch].delete parent.node_id
            end
          end
          result
        end
        memoize_method :scan_for_branch_heads
        
        ##
        # Reads all the branch heads, as well as the cached tip node and revision number.
        # The results are returned as a hash.
        #
        # @return [Hash{Symbol => Object}] the results of reading in the data. The resulting
        #   hash is keyed as follows:
        #
        #   :heads => [Hash{String => Array<String>}] a mapping of branch names to lists of
        #       branch node IDs
        #   :tip_id => [String] the string node ID of the tip revision when this cache was
        #       stored
        #   :tip_num => [Fixnum] the number of the tip revision when this cache was stored
        def read_branch_cache
          # first, get the lines
          begin
            lines = @hg_opener.read("branchheads.cache").split("\n")
          rescue SystemCallError
            return {:heads => nil, :tip_id => NULL_ID, :tip_num => NULL_REV}
          end
          
          tip_id, tip_num = lines.first.split(" ", 2)
          tip_num = tip_num.to_i
          tip_id = tip_id.unhexlify
          
          heads = ArrayHash.new
          lines[1..-1].each do |line|
            next if line.empty?
            node, branch = line.split(" ", 2)
            heads[branch] << node.unhexlify
          end
          return {:heads => heads, :tip_id => tip_id, :tip_num => tip_num}
        end
        
        ##
        # Writes out *all* the branch heads.  This means we need to have a list for each
        # branch with all its heads, even if there's just one.
        #
        # @param [Hash{String => Array<String>}] mapping a mapping of branch names to the
        #   list of heads for that branch. Heads should be provided as node IDs in binary
        #   form.
        def write_branch_heads!(mapping)
          @hg_opener.open("branchheads.cache","w") do |out|
            out.puts "#{self["tip"].node_id.hexlify} #{self.size - 1}"
            mapping.each do |branch, list|
              list.each { |node| out.puts "#{node.hexlify} #{branch}" }
            end
          end
        end
      end
    end
  end
end