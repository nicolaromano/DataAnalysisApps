// Blurs an element
// @param el the element id
// @param size the blur size in pixels
function blurElement(el, size)
  {
  $("#"+el).css("filter", "blur("+size+"px)");
  }
  
// Shows/hide an element
// @param el the element id
// @param show whether to show (true) or hide (false) the element
function showElement(el, show)
  {
  var vis = "visible";
  if (!show)
    vis = "hidden";
    
  $("#"+el).css("visibility", vis);
  }  
  
// Checks whether answers are correct

function checkAnswers()
  {
  // Find question ids
  var qids = $.map($("[id^=question_]"), function(n, i)
                                                 {
                                                 ids = n.id.split("_");
                                                 return ids[2];  
                                                 });
  // Find question type                                               
  var qtype = $.map($("[id^=question_]"), function(n, i)
                                                 {
                                                 ids = n.id.split("_");
                                                 return ids[1];  
                                                 });
  
  allcorrect = true;
  
  for (var i=0; i<qids.length; i++)
    {
    if (qtype[i] == "mcq")
      {
      // Get checked checkboxes
      var checked = $("[id^=answers_"+qids[i]+"ans_]:checked");
      // Split ids and return answer number
      var selans = $.map(checked, function(x, n){return(x.id.split("ans_")[1])});
      // Compare to correct answer
      var ca = $("#ca_"+qids[i]).val();

      if (selans == ca)
        {
        $($("#question_mcq_"+qids[i]).children()[0]).prepend("<i class='fa fa-check'></i> ");
        $($("#question_mcq_"+qids[i]).children()[0]).css("color", "green");
        }
      else
        {
        $($("#question_mcq_"+qids[i]).children()[0]).prepend("<i class='fa fa-times-circle'></i> ");
        $($("#question_mcq_"+qids[i]).children()[0]).css("color", "red");
        allcorrect = false;
        }
      }
    else if (qtype[i] == "mcqs")
      {
      // The selected answer
      var selans = $("[name^=answers_2]:checked").val();
      // The correct answer
      var ca = $("#ca_"+qids[i]).val();
      
      if (selans == ca)
        {
        $($("#question_mcqs_"+qids[i]).children()[0]).prepend("<i class='fa fa-check'></i> ");
        $($("#question_mcqs_"+qids[i]).children()[0]).css("color", "green");
        }
      else
        {
        $($("#question_mcqs_"+qids[i]).children()[0]).prepend("<i class='fa fa-times-circle'></i> ");
        $($("#question_mcqs_"+qids[i]).children()[0]).css("color", "red");
        allcorrect = false;
        }
      }
    }
    
  $("#submitAnswers").addClass("shinyjs-hide");
  
  if (allcorrect === true)
    {
    $("#gotoNextPage").removeClass("shinyjs-hide");
    $("#retry").addClass("shinyjs-hide");
    }
  else
    {
    $("#gotoNextPage").addClass("shinyjs-hide");
    $("#retry").removeClass("shinyjs-hide");
    $("#retry").click(function(){location.reload();});
    }
  }