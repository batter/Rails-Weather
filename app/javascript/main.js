var skycons = new Skycons({
	'monochrome': true,
	'colors': { 'main': '#444' }
});

function addSkyConById(id, icon) {
  skycons.add(id, Skycons[icon.toUpperCase()]);
}

function addSkyConsByClass(className) {
  let elements = document.getElementsByClassName(className);

  Array.prototype.map.call(elements, (element) => {
    skycons.add(element, Skycons[element.dataset.icon.toUpperCase()]);
  });
}

