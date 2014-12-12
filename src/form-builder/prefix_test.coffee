describe 'directive: prefix', ->
  scope = element = null

  beforeEach module('ui.bootstrap.more.form-builder')
  beforeEach inject(($rootScope, $compile) ->
    element = angular.element """
      <form bs-form><div class="form-group" nolabel noerrors><input type="text" ng-model="item.price" prefix="£" /></div></form>
    """
    scope = $rootScope
    $compile(element)(scope)
    scope.$digest()
  )

  it 'should render', ->
    expect(element.html()).toEqual ""+
      """<div class="form-group ng-scope" nolabel="" noerrors="">"""+
      """<div class="input-group">"""+
      """<div class="input-group-addon">£</div>"""+
      """<input type="text" ng-model="item.price" prefix="£" class="ng-pristine ng-untouched ng-valid form-control" name="price" id="item_price">"""+
      """</div>"""+
      """</div>"""

describe 'directive: prefix-icon', ->
  scope = element = null

  beforeEach module('ui.bootstrap.more.form-builder')
  beforeEach inject(($rootScope, $compile) ->
    element = angular.element """
      <form bs-form><div class="form-group" nolabel noerrors><input type="text" ng-model="item.price" prefix-icon="fa fa-dollar" /></div></form>
    """
    scope = $rootScope
    $compile(element)(scope)
    scope.$digest()
  )

  it 'should render', ->
    expect(element.html()).toEqual ""+
      """<div class="form-group ng-scope" nolabel="" noerrors="">"""+
      """<div class="input-group">"""+
      """<div class="input-group-addon"><i class="fa fa-dollar"></i></div>"""+
      """<input type="text" ng-model="item.price" prefix-icon="fa fa-dollar" class="ng-pristine ng-untouched ng-valid form-control" name="price" id="item_price">"""+
      """</div>"""+
      """</div>"""
