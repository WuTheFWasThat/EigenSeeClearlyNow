$(document).ready(->
  render_contents_on_div = (contents, div) ->
    for section in contents
      console.log section
      childdiv = $('<li>').text section.name
      div.append(childdiv)
      if section.sections
        childlist= $('<ul>')
        render_contents_on_div section.sections, childlist
        childdiv.append childlist

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
