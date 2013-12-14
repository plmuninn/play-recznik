class Controller

  scope = undefined

  constructor: ($scope, polishService) ->
    scope = $scope
    scope.polish_hints = []
    scope.polishService = polishService
    scope.$watch 'polish_text' , @update
    scope.$watch 'polish_hints' , (value) ->
      if(value? and value.length == 1)
        scope.polish_hints = []
    scope.changePolish = (word) ->
      scope.polish_text = word
      scope.polish_hints = []

  update: (value) ->
    scope.polish_hints = []
    if(value?)
      scope.polishService.typing(scope.polish_text).then (results) =>
        scope.polish_hints = results


angular.module('app').controller 'PolishSearchController', ['$scope','polishService', Controller]