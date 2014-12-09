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
        <input type="name" ng-model="model.name" name="name" required minlength="3" ng-maxlength="30" pattern="^[a-z]+$" />
        <div bs-input-errors messages="{pattern: 'lowercase only'}" name="name"></div>

        <input type="email" ng-model="model.email" name="email" required />
        <bs-input-errors messages="{required: 'not set'}" name="email"></bs-input-errors>

        <div class="form-group">
          <input type="number" ng-model="model.number" name="number" min="100" max="200" />
          <div bs-input-errors name="number"></div>
        </div>
      </form>
    """
    scope = $rootScope
    scope.model =
      name: "username"
      email: "me@home.com"
      number: 150

    $compile(element)(scope)
    scope.$digest()
  )

  select = (q) ->
    el = element[0].querySelector(q)
    angular.element(el)
  errorsOn = (name) ->
    select("[name='#{name}'] p.help-block")

  it 'should render', ->
    expect(element.children().length).toEqual(5)

  it 'should validate required', ->
    scope.form.name.$setViewValue('')
    expect(errorsOn('name').length).toEqual(1)
    expect(errorsOn('email').length).toEqual(0)
    expect(errorsOn('number').length).toEqual(0)
    expect(errorsOn('name').text()).toEqual('is required')

  it 'should validate minlength', ->
    scope.form.name.$setViewValue('ab')
    expect(errorsOn('name').length).toEqual(1)
    expect(errorsOn('email').length).toEqual(0)
    expect(errorsOn('number').length).toEqual(0)
    expect(errorsOn('name').text()).toEqual('too short, minimum 3 characters')

  it 'should validate maxlength', ->
    scope.form.name.$setViewValue('abcdefghijabcdefghijabcdefghijabcdefghij')
    expect(errorsOn('name').length).toEqual(1)
    expect(errorsOn('email').length).toEqual(0)
    expect(errorsOn('number').length).toEqual(0)
    expect(errorsOn('name').text()).toEqual('too long, maximum 30 characters')

  it 'should validate pattern', ->
    scope.form.name.$setViewValue('ABCD')
    expect(errorsOn('name').length).toEqual(1)
    expect(errorsOn('email').length).toEqual(0)
    expect(errorsOn('number').length).toEqual(0)
    expect(errorsOn('name').text()).toEqual('lowercase only')

  it 'should validate emails', ->
    scope.form.email.$setViewValue('BADEMAIL')
    expect(errorsOn('name').length).toEqual(0)
    expect(errorsOn('email').length).toEqual(1)
    expect(errorsOn('number').length).toEqual(0)
    expect(errorsOn('email').text()).toEqual('is not a valid email address')

  it 'should validate numbers', ->
    scope.form.number.$setViewValue('NOTNUM')
    expect(errorsOn('name').length).toEqual(0)
    expect(errorsOn('email').length).toEqual(0)
    expect(errorsOn('number').length).toEqual(1)
    expect(errorsOn('number').text()).toEqual('is not a number')

    scope.form.number.$setViewValue('90')
    expect(errorsOn('number').text()).toEqual('must be at least 100')

    scope.form.number.$setViewValue('210')
    expect(errorsOn('number').text()).toEqual('must not be over 200')

    scope.form.number.$setViewValue('150')
    expect(errorsOn('number').length).toEqual(0)

  it 'should toggle has-success/error', ->
    classes = -> select('.form-group')[0].getAttribute('class')
    expect(classes()).toBe("form-group")

    scope.$apply ->
      scope.form.number.$setViewValue('50')
      scope.form.number.$setTouched()
    expect(classes()).toBe("form-group has-error")

    scope.$apply ->
      scope.form.number.$setViewValue('120')
      scope.form.number.$setTouched()
    expect(classes()).toBe("form-group has-success")

    scope.$apply ->
      scope.form.number.$setViewValue('150')
      scope.form.number.$setPristine()
    expect(classes()).toBe("form-group")
