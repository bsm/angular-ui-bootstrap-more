describe 'directive: bsSelect', ->
  beforeEach module('ui.bootstrap.more.form-builder')

  scope = element = null
  prepare = (html, rootScope, compile) ->
    element = angular.element(html)
    scope   = rootScope
    scope.names = ['Kate', 'Tom', 'Beth']
    compile(element)(scope)
    scope.$digest()

  describe 'simple', ->

    beforeEach inject(($rootScope, $compile) ->
      prepare """
        <form name="form" novalidate>
          <bs:select ng-model="model.name" ng-options="name for name in names">
            <option value="">Select ...</option>
          </bs:select>
        </form>
      """, $rootScope, $compile
    )

    it 'should wrap and render', ->
      expect(element.html().trim()).toEqual ""+
        """<div class="form-group">"""+
        """<label class="control-label ng-scope" for="form_model_name">Name</label>"""+
        """<select class="form-control ng-pristine ng-untouched ng-valid ng-scope" ng-model="model.name" ng-options="name for name in names" name="name" id="form_model_name" bs-input-errors="{}">"""+
        """<option value="" class="">Select ...</option>"""+
        """<option value="0" label="Kate">Kate</option>"""+
        """<option value="1" label="Tom">Tom</option>"""+
        """<option value="2" label="Beth">Beth</option>"""+
        """</select>"""+
        """</div>"""
    return

  return
