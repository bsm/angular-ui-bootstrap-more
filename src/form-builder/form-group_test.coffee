describe 'directive: formGroup', ->
  beforeEach module('ui.bootstrap.more.form-builder')

  element = null
  prepare = (html) ->
    inject ($rootScope, $compile) ->
      element = angular.element(html)
      $compile(element)($rootScope)
      $rootScope.$digest()

  describe 'minimal', ->
    beforeEach ->
      prepare """
        <form name="form"><div class="form-group"></div></form>
      """

    it 'should wrap and render', ->
      expect(element.html().trim()).toEqual """<div class="form-group"></div>"""

  describe 'with label', ->
    beforeEach ->
      prepare """
        <form name="form"><div class="form-group" label="Title" label-class="control-title"></div></form>
      """

    it 'should wrap and render', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group" label="Title" label-class="control-title">"""+
        """<label class="control-label control-title">Title</label>"""+
        """</div>"""
