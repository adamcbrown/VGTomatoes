//Changes score for review
$('#score_bar').change(function(){
    var val = $(this).val();
    var text="?";
    switch(val){
      case "0": text="Horrible"; break;
      case "1": text="Bad"; break;
      case "2": text="OK"; break;
      case "3": text="Good"; break;
      case "4": text="Great"; break;
      case "5": text="Amazing"; break;
    }
    document.getElementById('score_text').innerHTML=text;
});

//NEVER allow html tags - As of now not begin called
$("#actual_review").keypress(function(){
  alert('hi');
  $(this).innerHTML=$(this).innerHTML.replace('<', '');
}