$(document).ready(->
  my_location = window.location.pathname
  render_contents_on_div = (contents, div, path= "") ->
    list = $('<ul>')
    div.append list
    for section in contents
      # console.log section
      child = $('<li>')
      childpath = path + "/" + section.name.replace(' ', '_')
      if section.sections
        child.append $('<div>').text section.name
        render_contents_on_div section.sections, child, childpath
      else
        if childpath == my_location
          childlink = $('<b>')
        else
          childlink = $('<a>').attr 'href', childpath
        childlink.text section.name
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
        {
          name: "commutativity"
        }
      ]
    }
    {
      name: "vector spaces"
      sections: [
        {
          name: "span game"
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
