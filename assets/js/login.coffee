$ ->
 $.ajax
    type: "POST"
    url: "/session/create"
    data:
      userid: 100001088919966
      name:   "Takumi Baba"
    success: (data)->
      window.alert data
      location.href = "/"