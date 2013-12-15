class SerbianSearchController

  scope = undefined

  constructor: ($scope, serbianService) ->
    scope = $scope
    scope.serbian_hints = []
    scope.serbian_word = {}
    scope.serbianService = serbianService
    scope.$watch 'serbian_text', debounce(@update, 500)
    scope.changeSerbian = (word) ->
      scope.serbian_hints = []
      scope.serbian_text = word
    scope.translateSerbian = ->
      if(scope.serbian_text?.length)
        scope.serbianService.translate(scope.serbian_text).then (results) =>
          scope.serbian_results = results
      else
        scope.serbian_results = []
    scope.$on 'translateSerbian' , (event, word) ->
      scope.serbian_text = word.word
      scope.translateSerbian()

  update: (value) ->
    scope.serbian_hints = []
    scope.$apply()
    if(value?.length)
      scope.serbianService.typing(scope.serbian_text).then (results) =>
        if(results.length != 0 and results[0]? and results[0].word.toLowerCase() != scope.serbian_text.toLowerCase())
          scope.serbian_hints = results
        else
          scope.serbian_hints = []



angular.module('app').controller 'SerbianSearchController', ['$scope', 'serbianService', SerbianSearchController]