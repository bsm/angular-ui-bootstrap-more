describe 'directive: ngModel', ->
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
        <form><input ng-model="movie.title"></form>
      """

    it 'should extend tag with name and ID', ->
      expect(element.html().trim())
        .toEqual """<input ng-model="movie.title" class="ng-pristine ng-untouched ng-valid">"""

  describe 'wrapped in bs-form', ->
    beforeEach ->
      prepare """
        <form bs-form><input ng-model="movie.title"></form>
      """

    it 'should extend tag with name and ID', ->
      expect(element.html().trim())
        .toEqual """<input ng-model="movie.title" class="ng-pristine ng-untouched ng-valid" name="title" id="movie_title">"""

  describe 'custom name & id', ->
    beforeEach ->
      prepare """
        <form bs-form><input ng-model="movie.title" name="mytitle" id="myid"></form>
      """

    it 'should not override', ->
      expect(element.html().trim())
        .toEqual """<input ng-model="movie.title" name="mytitle" id="myid" class="ng-pristine ng-untouched ng-valid">"""

  describe 'nested within form-group', ->
    beforeEach ->
      prepare """
        <form bs-form><div class="form-group"><input ng-model="movie.title"></div></form>
      """

    it 'should expand form-group', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group">"""+
        """<label class="control-label" for="movie_title">Title</label>"""+
        """<input ng-model="movie.title" class="ng-pristine ng-untouched ng-valid form-control" name="title" id="movie_title">"""+
        """<div bs-input-errors="" name="title" class="ng-scope"></div>"""+
        """</div>"""

  describe 'nested within form-group but not bs-form', ->
    beforeEach ->
      prepare """
        <form><div class="form-group"><input ng-model="movie.title"></div></form>
      """

    it 'should expand form-group', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group">"""+
        """<input ng-model="movie.title" class="ng-pristine ng-untouched ng-valid form-control">"""+
        """</div>"""

  describe 'nested within form-group with nolabel/noerrors', ->
    beforeEach ->
      prepare """
        <form bs-form><div class="form-group" nolabel noerrors><input ng-model="movie.title"></div></form>
      """

    it 'should skip label and errors', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group" nolabel="" noerrors="">"""+
        """<input ng-model="movie.title" class="ng-pristine ng-untouched ng-valid form-control" name="title" id="movie_title">"""+
        """</div>"""

  describe 'nested within form-group with custom label and ID', ->
    beforeEach ->
      prepare """
        <form bs-form><div class="form-group" label="Custom" noerrors><input ng-model="movie.title" id="myid"></div></form>
      """

    it 'should keep cusomisations', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group" label="Custom" noerrors="">"""+
        """<label class="control-label" for="myid">Custom</label>"""+
        """<input ng-model="movie.title" id="myid" class="ng-pristine ng-untouched ng-valid form-control" name="title">"""+
        """</div>"""

  describe 'radio/checkbox inputs', ->
    beforeEach ->
      prepare """
        <form bs-form><div class="form-group" nolabel noerrors><input type="radio" ng-model="movie.rating"></div></form>
      """

    it 'should not apply form-control class', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group" nolabel="" noerrors="">"""+
        """<input type="radio" ng-model="movie.rating" class="ng-pristine ng-untouched ng-valid" name="rating" id="movie_rating">"""+
        """</div>"""
