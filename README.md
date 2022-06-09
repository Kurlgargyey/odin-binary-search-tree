# odin-binary-search-tree

This is a ruby implementation of a binary search tree structure I made for the The Odin Project online curriculum.

## Challenges
I had the most trouble still with wrapping my head around recursive solutions. In the end, I ended up implementing a lot of methods iteratively, even though they would have been better implemented using recursion. All my traversal methods use iteration, because I couldn't really understand an easy way to keep the ledger of seen nodes between the different method calls.

Another thing I had issues getting right was the #delete method. It took me a while to understand that I could return the worked on node itself at the end and then use the method recursively without it deleting the wrong nodes.