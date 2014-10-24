$(document).ready(->
  render_contents_on_div = (contents, div, path= "") ->
    for section in contents
      # console.log section
      childdiv = $('<li>')
      childlink = $('<a>').text section.name
      childdiv.append childlink
      childpath= path+ "/" + section.name
      if section.sections
        childlist= $('<ul>')
        render_contents_on_div section.sections, childlist, childpath
        childdiv.append childlist
      else
        childlink.attr 'href', childpath
      div.append(childdiv)

  table_of_contents = [
    {
      name: "vectors"
      sections: [
        {
          name: "intro"
        }
        {
          name: "addition"
        }
      ]
    }
    {
      name: "matrices"
      sections: [name: "intro"]
    }
  ]

  render_contents_on_div table_of_contents, $('#table_of_contents')

)
