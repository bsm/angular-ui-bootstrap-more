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
    invalid   : 'is invalid'

  @$get = => {messages: @messages}
  return

mod.directive 'bsInputErrors', ($interpolate, bsInputErrorsConfig) ->
  onLink = (scope, element, attrs, ctrls) ->
    # Move help blocks after element
    element.after(element[0].children[0])

    # Assign form & input
    scope.input = ctrls[0]
    scope.form  = ctrls[1]

    # Compile messages
    messages = angular.copy(bsInputErrorsConfig.messages)
    angular.extend messages, scope.$eval(attrs.bsInputErrors)

    # Assign/interpolate messages
    vals =
      min: attrs.min
      max: attrs.max
      minlength: attrs.minlength || attrs.ngMinlength
      maxlength: attrs.maxlength || attrs.ngMaxlength
    scope.messages = {}
    scope.messages[kind] = $interpolate(msg)(vals) for kind, msg of messages

    return

  {
    restrict: 'A'
    require:  ['ngModel', '^?form']
    link:     onLink
    scope:    {}
    templateUrl: 'template/ui-bootstrap-more/input-errors/input-errors.html'
  }
