$(document).ready(function() {
  var my_location, render_contents_on_div, table_of_contents;
  my_location = window.location.pathname;
  render_contents_on_div = function(contents, div, path) {
    var child, childlink, childpath, i, len, list, results, section;
    if (path == null) {
      path = "";
    }
    list = $('<ul>');
    div.append(list);
    results = [];
    for (i = 0, len = contents.length; i < len; i++) {
      section = contents[i];
      child = $('<li>');
      childpath = path + "/" + section.name.replace(' ', '_');
      if (section.sections) {
        child.append($('<div>').text(section.name));
        render_contents_on_div(section.sections, child, childpath);
      } else {
        if (childpath === my_location) {
          childlink = $('<b>');
        } else {
          childlink = $('<a>').attr('href', childpath);
        }
        childlink.text(section.name);
        child.append(childlink);
      }
      results.push(list.append(child));
    }
    return results;
  };
  table_of_contents = [
    {
      name: "vectors",
      sections: [
        {
          name: "intro"
        }, {
          name: "addition"
        }, {
          name: "commutativity"
        }
      ]
    }, {
      name: "vector spaces",
      sections: [
        {
          name: "span game"
        }
      ]
    }, {
      name: "matrices",
      sections: [
        {
          name: "intro"
        }
      ]
    }
  ];
  return render_contents_on_div(table_of_contents, $('#table_of_contents'));
});