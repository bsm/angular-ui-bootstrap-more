describe 'directive: bsSubmit', ->
  scope = element = null

  beforeEach module('ui.bootstrap.more.form-builder')
  beforeEach inject(($rootScope, $compile) ->
    element = angular.element """
      <form name="form" bs-form>
        <bs-submit></bs-submit>
      </form>
    """
    scope = $rootScope
    $compile(element)(scope)
    scope.$digest()
  )

  it 'should render', ->
    expect(element.html())
      .toContain("""<button class="btn btn-primary ng-binding" type="submit" ng-bind="label">Save</button>""")
    expect(element.html())
      .toContain("""<button class="btn btn-default" type="cancel" ng-click="onCancel()">Cancel</button>""")


