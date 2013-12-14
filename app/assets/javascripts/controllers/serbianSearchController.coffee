class Controller

  scope = undefined

  constructor: ($scope, serbianService) ->
    scope = $scope
    scope.serbian_hints = []
    scope.serbianService = serbianService
    scope.$watch 'serbian_text' , @update
    scope.$watch 'serbian_hints' , (value) ->
      if(value? and value.length == 1)
        scope.serbian_hints = []
    scope.changeSerbian = (word) ->
      scope.serbian_hints = []
      scope.serbian_text = word

  update: (value) ->
    scope.serbian_hints = []
    if(value?)
      scope.serbianService.typing(scope.serbian_text).then (results) =>
        scope.serbian_hints = results


angular.module('app').controller 'SerbianSearchController', ['$scope','serbianService', Controller]