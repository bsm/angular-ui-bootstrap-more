describe 'directive: bsForm', ->
  beforeEach module('ui.bootstrap.more.form-builder')

  element = null
  prepare = (html) ->
    inject ($rootScope, $compile) ->
      element = angular.element(html)
      $compile(element)($rootScope)
      $rootScope.$digest()

  describe 'not wrapped', ->
    beforeEach ->
      prepare """
        <div><form bs-form></form></div>
      """

    it 'should extend tag with novalidate', ->
      expect(element.html().trim()).toEqual ""+
        """<form bs-form="" class="ng-pristine ng-valid" novalidate=""></form>"""
