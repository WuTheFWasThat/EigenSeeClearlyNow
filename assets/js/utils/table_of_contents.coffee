$(document).ready(->
  render_contents_on_div = (contents, div, path= "") ->
    list = $('<ul>')
    div.append list
    for section in contents
      # console.log section
      child = $('<li>')
      childpath= path + "/" + section.name
      if section.sections
        child.append $('<div>').text section.name
        render_contents_on_div section.sections, child, childpath
      else
        childlink = $('<a>').text section.name
        childlink.attr 'href', childpath
        child.append childlink
      list.append(child)

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
    #{
    #  name: "matrices"
    #  sections: [name: "intro"]
    #}
  ]

  render_contents_on_div table_of_contents, $('#table_of_contents')

)
