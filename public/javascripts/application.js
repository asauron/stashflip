function openGoogleDirections(dest_address) {
 
  var my_addr = document.getElementById('input_address').value;
  var general_url = 'http://maps.google.com/maps?saddr='+my_addr +'&daddr=' + dest_address;
  window.open(general_url, 'Beatmap => Google Maps Directions', 'width=1000, height=500, toolbar=yes, location=yes, directories=yes, status=yes, menubar=yes, scrollbars=yes, copyhistory=yes, resizable=yes');

/*   alert('Hello');*/
}
