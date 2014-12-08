describe 'provider: bsInputErrorsConfig', ->
  subject = null

  beforeEach module('ui.bootstrap.more.input-errors')
  beforeEach inject((bsInputErrorsConfig) ->
    subject = bsInputErrorsConfig
  )

  it 'should have config', ->
    expect(subject.messages).toBeDefined()
    expect(Object.keys(subject.messages).length).toEqual(10)

describe 'directive: bsInputErrors', ->
  scope = element = null

  beforeEach module('ui.bootstrap.more.input-errors')
  beforeEach inject(($rootScope, $compile) ->
    element = angular.element """
      <form name="form">
        <input type="name" ng-model="model.name" name="name" required minlength="3" ng-maxlength="30" pattern="^[a-z]+$" bs-input-errors="{pattern: \'lowercase only\'}" />
        <input type="email" ng-model="model.email" name="email" required bs-input-errors="{required: \'need one\'}" />
        <input type="number" ng-model="model.number" name="number" min="100" max="200" bs-input-errors />
      </form>
    """
    scope = $rootScope
    scope.model =
      name: "username"
      email: "me@home.com"

    $compile(element)(scope)
    scope.$digest()
  )

  it 'should render', ->
    expect(element[0].children.length).toEqual(6)

  it 'should validate required', ->
    scope.form.name.$setViewValue('')
    expect(element[0].children[1].children.length).toEqual(1)
    expect(element[0].children[3].children.length).toEqual(0)
    expect(element[0].children[5].children.length).toEqual(0)
    expect(element[0].children[1].innerHTML).toContain('is required')

  it 'should validate minlength', ->
    scope.form.name.$setViewValue('ab')
    expect(element[0].children[1].children.length).toEqual(1)
    expect(element[0].children[3].children.length).toEqual(0)
    expect(element[0].children[5].children.length).toEqual(0)
    expect(element[0].children[1].innerHTML).toContain('too short, minimum 3 characters')

  it 'should validate maxlength', ->
    scope.form.name.$setViewValue('abcdefghijabcdefghijabcdefghijabcdefghij')
    expect(element[0].children[1].children.length).toEqual(1)
    expect(element[0].children[3].children.length).toEqual(0)
    expect(element[0].children[5].children.length).toEqual(0)
    expect(element[0].children[1].innerHTML).toContain('too long, maximum 30 characters')

  it 'should validate pattern', ->
    scope.form.name.$setViewValue('ABCD')
    expect(element[0].children[1].children.length).toEqual(1)
    expect(element[0].children[3].children.length).toEqual(0)
    expect(element[0].children[5].children.length).toEqual(0)
    expect(element[0].children[1].innerHTML).toContain('lowercase only')

  it 'should validate emails', ->
    scope.form.email.$setViewValue('BADEMAIL')
    expect(element[0].children[1].children.length).toEqual(0)
    expect(element[0].children[3].children.length).toEqual(1)
    expect(element[0].children[5].children.length).toEqual(0)
    expect(element[0].children[3].innerHTML).toContain('is not a valid email address')

  it 'should validate numbers', ->
    scope.form.number.$setViewValue('NOTNUM')
    expect(element[0].children[1].children.length).toEqual(0)
    expect(element[0].children[3].children.length).toEqual(0)
    expect(element[0].children[5].children.length).toEqual(1)
    expect(element[0].children[5].innerHTML).toContain('not a number')

    scope.form.number.$setViewValue('90')
    expect(element[0].children[5].children.length).toEqual(1)
    expect(element[0].children[5].innerHTML).toContain('must be at least 100')

    scope.form.number.$setViewValue('210')
    expect(element[0].children[5].children.length).toEqual(1)
    expect(element[0].children[5].innerHTML).toContain('must not be over 200')

    scope.form.number.$setViewValue('150')
    expect(element[0].children[5].children.length).toEqual(0)
