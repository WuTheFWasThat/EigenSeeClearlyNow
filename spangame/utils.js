var cancelEvent, renderLatex, vec2latex;

cancelEvent = function(e) {
  e.stopPropagation();
  e.preventDefault();
  return false;
};

String.prototype.format = function() {
  var i, newStr;
  newStr = this;
  i = 0;
  while (/%s/.test(newStr)) {
    newStr = newStr.replace('%s', arguments[i++]);
  }
  return newStr;
};

Number.randInt = function(min, max) {
  return Math.floor(min + Math.random() * (max - min + 1));
};

vec2latex = function(vector) {
  return '\\left(\\begin{array}{c}' + vector.x + '\\\\' + vector.y + '\\\\' + vector.z + '\\end{array}\\right)';
};

renderLatex = function(div, latex) {
  div.text(latex);
  return MathJax.Hub.Queue(['Typeset', MathJax.Hub, div[0]]);
};