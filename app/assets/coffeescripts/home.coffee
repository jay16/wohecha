#encoding: utf-8
$ ->
  # detect the change
  $("input#subscribe").bind "change keyup input", ->
    if !$(this).val().trim()
      $("input[type='submit']").removeAttr("disabled")
    else
      $("input[type='submit']").attr("disabled","disabled") 

