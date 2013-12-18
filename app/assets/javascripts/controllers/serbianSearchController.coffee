class SerbianSearchController

  scope = undefined
  self = undefined
  searched = undefined

  constructor: ($scope, serbianService, $rootScope, addService,polishService) ->
    self = @
    scope = $scope
    scope.serbian_hints = []
    scope.serbian_results = []
    scope.serbian_word = {}
    scope.serbianService = serbianService
    scope.addService = addService
    scope.polishService = polishService
    scope.$watch 'serbian_text', debounce(@update, 500)
    scope.changeSerbian = (word) ->
      scope.serbian_hints = []
      scope.serbian_text = word
    scope.translateSerbian = ->
      if(scope.serbian_text?.length)
        scope.serbianService.translate(scope.serbian_text).then (results) =>
          scope.serbian_results = results.list
          searched = results.word
      else
        scope.serbian_results = []
    $rootScope.$on 'TRANSLATE_SERBIAN', (event, word) ->
      scope.serbian_text = word.word
      scope.translateSerbian()
      $('html, body').animate({scrollTop: 0}, 500)
    $rootScope.$on 'ADDED_TRANSLATION', (event, word) ->
      if(scope.serbian_text?.length and scope.serbian_text.toLowerCase()== word.serbian.word.toLowerCase())
        if(!self.wordExists(word.polish))
          scope.serbian_results.push word.polish
    $rootScope.$on 'EDITED_SERBIAN_TRANSLATION', (event, word) ->
      if(searched? and searched.id == word.id)
        scope.serbian_text = word.word
        searched = word
    $rootScope.$on 'REMOVED_SERBIAN_TRANSLATION', (event, word) ->
      if(searched? and searched.id == word.id)
        scope.serbian_text = ""
        scope.serbian_hints = []
        scope.serbian_results = []
    $rootScope.$on 'EDITED_POLISH_TRANSLATION', (event, word) ->
      result = self.findById(word.id, scope.serbian_results)
      if(result?)
        result.word = word.word
    $rootScope.$on 'REMOVED_POLISH_TRANSLATION', (event, word) ->
      result = self.findById(word.id, scope.serbian_results)
      if(result?)
        result.active = false

  wordExists: (word) ->
    for w in scope.serbian_results
      if(w.id == word.id)
        return true
    false

  findById: (id, list) ->
    for w in list
      if(w.id == id)
        return w
    null

  update: (value) ->
    scope.serbian_hints = []
    scope.$apply()
    if(value?.length)
      scope.serbianService.typing(scope.serbian_text).then (results) =>
        if(results.length != 0 and results[0]? and results[0].word.toLowerCase() != scope.serbian_text.toLowerCase())
          scope.serbian_hints = results
        else
          scope.serbian_hints = []

  save: (word) ->
    scope.polishService.edit(word)
    word.edit = false

  remove: (word) ->
    bootbox.confirm "Ta zmiana jest nieodwracalna. Kontynuować?", (result)->
      if(result)
        scope.polishService.remove(word.id)

  addElement: ->
    if(@element?.length and searched)
      scope.addService.addTranslation(@element, searched.word)
      @add = false
      @element = ""


angular.module('app').controller 'SerbianSearchController',
  ['$scope', 'serbianService', '$rootScope', 'addService','polishService', SerbianSearchController]