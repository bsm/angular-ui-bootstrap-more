mod = angular.module 'ui.bootstrap.more.input-errors', []

mod.provider 'bsInputErrorsConfig', ->
  @messages =
    required  : 'is required'
    minlength : 'too short, minimum {{minlength}} characters'
    maxlength : 'too long, maximum {{maxlength}} characters'
    pattern   : 'has the wrong format'
    number    : 'is not a number'
    email     : 'is not a valid email address'
    url       : 'is not a valid URL'
    min       : 'must be at least {{min}}'
    max       : 'must not be over {{max}}'

  @$get = =>
    {messages: @messages}

  return

mod.directive 'bsInputErrors', ($interpolate, bsInputErrorsConfig) ->
  findParentGroup = (element) ->
    element = element.parent() while element.length && !element.hasClass('form-group')
    element if element.length
  postLink = (scope, element, attrs, form) ->
    # Assign input
    name = $interpolate(attrs.name || '', false)(scope)
    scope.input = form[name]
    scope.input.errorMessages = {}

    # Compile messages
    messages = angular.copy(bsInputErrorsConfig.messages)
    angular.extend messages, scope.$eval(attrs.messages) if attrs.messages

    # Assign/interpolate messages
    input  = element[0].parentNode?.querySelector("[name='#{name}']")
    input  = angular.element(input) if input?
    limits =
      min: attrs.min || input?.attr('min')
      max: attrs.max || input?.attr('max')
      minlength: attrs.minlength || input?.attr('minlength') || input?.attr('ng-minlength')
      maxlength: attrs.maxlength || input?.attr('maxlength') || input?.attr('ng-maxlength')

    scope.messages = {}
    scope.messages[kind] = $interpolate(msg)(limits) for kind, msg of messages

    # Assign callbacks
    touched = ->
      form && form[name] && (form.$submitted || form[name].$touched)
    scope.hasSuccess = ->
      touched() && form[name].$dirty && form[name].$valid
    scope.hasError = ->
      touched() && form[name].$invalid

    # Watch for changes, update form-group
    if formGroup = findParentGroup(element.parent())
      scope.$watch scope.hasError, (value) ->
        formGroup.toggleClass('has-error', value)
      scope.$watch scope.hasSuccess, (value) ->
        formGroup.toggleClass('has-success', value)
    return

  {
    restrict: 'AE'
    require:  '^form'
    link:     postLink
    scope:    {}
    templateUrl: 'template/ui-bootstrap-more/input-errors/input-errors.html'
  }
