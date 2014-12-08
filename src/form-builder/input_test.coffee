describe 'directive: bsInput', ->
  beforeEach module('ui.bootstrap.more.form-builder')

  scope = element = null
  prepare = (html, rootScope, compile) ->
    element = angular.element(html)
    scope   = rootScope
    compile(element)(scope)
    scope.$digest()

  describe 'minimal', ->

    beforeEach inject(($rootScope, $compile) ->
      prepare """
        <form name="form" novalidate>
          <bs:input ng-model="model.name"></bs:input>
        </form>
      """, $rootScope, $compile
    )

    it 'should wrap and render', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group">"""+
        """<label class="control-label ng-scope" for="form_model_name">Name</label>"""+
        """<input class="form-control ng-pristine ng-untouched ng-valid ng-scope" ng-model="model.name" type="text" name="name" id="form_model_name" bs-input-errors="{}">"""+
        """</div>"""

    return

  describe 'prefix', ->

    beforeEach inject(($rootScope, $compile) ->
      prepare """
        <form name="form" novalidate>
          <bs:input type="number" ng-model="model.rate" prefix-icon="fa fa-dollar"></bs:input>
        </form>
      """, $rootScope, $compile
    )

    it 'should wrap and render', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group">"""+
        """<label class="control-label ng-scope" for="form_model_rate">Rate</label>"""+
        """<div class="input-group ng-scope">"""+
        """<div class="input-group-addon"><i class="fa fa-dollar"></i></div>"""+
        """<input class="form-control ng-pristine ng-untouched ng-valid" type="number" ng-model="model.rate" prefix-icon="fa fa-dollar" name="rate" id="form_model_rate" bs-input-errors="{}">"""+
        """</div>"""+
        """</div>"""

    return

  describe 'customised', ->

    beforeEach inject(($rootScope, $compile) ->
      prepare """
        <form name="form" novalidate>
          <bs:input
            id="customId"
            type="text" name="username" pattern="^[a-z]+$" ng-model="model.name"
            label="Prefered name"
            required ng-minlength="3" ng-maxlength="30"
            messages="{pattern: 'must only contain lowercase characters'}"></bs:input>
        </form>
      """, $rootScope, $compile
    )

    it 'should wrap and render', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group">"""+
        """<label class="control-label ng-scope" for="customId">Prefered name</label>"""+
        """<input class="form-control ng-pristine ng-untouched ng-scope ng-invalid ng-invalid-required ng-valid-pattern ng-valid-minlength ng-valid-maxlength" id="customId" type="text" name="username" pattern="^[a-z]+$" ng-model="model.name" required="required" ng-minlength="3" ng-maxlength="30" bs-input-errors="{pattern: 'must only contain lowercase characters'}">"""+
        """</div>"""

    return

  describe 'validation', ->
    beforeEach module('ui.bootstrap.more.input-errors')

    beforeEach inject(($rootScope, $compile) ->
      prepare """
        <form name="form" novalidate>
          <bs:input ng-model="model.name" pattern="^a$"></bs:input>
        </form>
      """, $rootScope, $compile
    )

    it 'should render errors', ->
      expect(element.html()).toContain """<div class="form-group">"""
      scope.form.name.$setViewValue('b')
      expect(element.html()).toContain """<div class="form-group has-error">"""
      expect(element.html()).toContain """has the wrong format"""
    return

  return
