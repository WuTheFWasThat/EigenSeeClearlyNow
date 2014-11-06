#= require lib/jquery-2.1.0.min.js
#= require lib/jquery.cookie.min.js

###
NOTE: order matters here
      typeface-0.15.js must be included before three.js
      helvetiker_regular.typeface.js must be included after three.js
      This is because three.js monkeypatches the typeface loader.
###

#= require lib/typeface-0.15.js
#= require lib/three.min.js
#= require lib/helvetiker_regular.typeface.js

#= require lib/underscore-min.js
#= require lib/bootstrap.min.js
#= require lib/MathJax/MathJax.js

#= require_tree utils

#= require layout
#= require index
#= require_tree pages
