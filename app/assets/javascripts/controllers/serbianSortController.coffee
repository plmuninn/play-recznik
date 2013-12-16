class SerbianSortController

  scope = undefined
  rootScope = undefined

  constructor: ($scope, serbianService,$rootScope) ->
    scope = $scope
    rootScope = $rootScope
    scope.serbian_search = {
      page: 0,
      pages: 0,
      results: []
    }
    scope.serbian_girdSize = 10
    scope.serbianService = serbianService
    scope.$watch 'serbian_sort', debounce(@search, 500)
    $rootScope.$on 'ADDED_TRANSLATION',(event, word) ->
      @search('')

  search: (value) ->
    if(value != "page")
      scope.serbian_search.page = 0
    scope.serbianService.filter(scope.serbian_sort, scope.serbian_search.page, scope.serbian_girdSize).then (results) =>
      scope.serbian_search = results

  changeGridSize: (value) ->
    scope.serbian_girdSize = value
    @search('')

  nextPage: ->
    scope.serbian_search.page = scope.serbian_search.page + 1
    @search('page')

  prevPage: ->
    scope.serbian_search.page = scope.serbian_search.page - 1
    @search('page')

  translateWord: (word) ->
    rootScope.$emit('TRANSLATE_SERBIAN', word)

  getClass : (size) ->
    if(size == scope.serbian_girdSize)
      "disabled"
    else
      ""

  save:(word) ->
  remove:(id) ->

angular.module('app').controller 'SerbianSortController', ['$scope', 'serbianService', '$rootScope', SerbianSortController]