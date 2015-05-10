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