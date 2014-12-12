describe 'directive: suffix', ->
  scope = element = null

  beforeEach module('ui.bootstrap.more.form-builder')
  beforeEach inject(($rootScope, $compile) ->
    element = angular.element """
      <form bs-form><div class="form-group" nolabel noerrors><input type="text" ng-model="item.price" suffix="£" /></div></form>
    """
    scope = $rootScope
    $compile(element)(scope)
    scope.$digest()
  )

  it 'should render', ->
    expect(element.html()).toEqual ""+
      """<div class="form-group" nolabel="" noerrors="">"""+
      """<div class="input-group">"""+
      """<input type="text" ng-model="item.price" suffix="£" class="ng-pristine ng-untouched ng-valid form-control" name="price" id="item_price">"""+
      """<div class="input-group-addon">£</div>"""+
      """</div>"""+
      """</div>"""

describe 'directive: suffix-icon', ->
  scope = element = null

  beforeEach module('ui.bootstrap.more.form-builder')
  beforeEach inject(($rootScope, $compile) ->
    element = angular.element """
      <form bs-form><div class="form-group" nolabel noerrors><input type="text" ng-model="item.price" suffix-icon="fa fa-dollar" /></div></form>
    """
    scope = $rootScope
    $compile(element)(scope)
    scope.$digest()
  )

  it 'should render', ->
    expect(element.html()).toEqual ""+
      """<div class="form-group" nolabel="" noerrors="">"""+
      """<div class="input-group">"""+
      """<input type="text" ng-model="item.price" suffix-icon="fa fa-dollar" class="ng-pristine ng-untouched ng-valid form-control" name="price" id="item_price">"""+
      """<div class="input-group-addon"><i class="fa fa-dollar"></i></div>"""+
      """</div>"""+
      """</div>"""
