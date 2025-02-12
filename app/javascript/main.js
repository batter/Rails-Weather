var skycons = new Skycons({
	'monochrome': true,
	'color': '#444'
});

function addSkyConById(id, icon) {
  skycons.add(id, Skycons[icon.toUpperCase()]);

  skycons.play();
}

function addSkyConsByClass(className) {
  let elements = document.getElementsByClassName(className);

  Array.prototype.map.call(elements, (element) => {
    skycons.add(element, Skycons[element.dataset.icon.toUpperCase()]);
  });

  skycons.play();
}

