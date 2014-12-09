mod = angular.module 'ui.bootstrap.more.form-builder', []

# Submit directive
mod.directive 'bsSubmit', ($window) ->
  onLink = (scope, element, attrs) ->
    attrs.label ||= 'Save'
    scope.onCancel = ->
      $window.history.back()
    return

  {
    restrict: 'AE'
    require:  '^form'
    link:     onLink
    scope:
      label: '@'
    templateUrl: 'template/ui-bootstrap-more/form-builder/submit.html'
  }

mod.directive 'bsFormGroup', ($compile) ->
  titleize = (name) ->
    words = for word in name.replace(/([A-Z])/g, ' $1').split(' ')
      word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
    words.join(' ')

  inputAddon = (content, icon) ->
    content = "<i class=\"#{icon}\" />" if icon?
    angular.element('<div class="input-group-addon"></div>')
      .append(angular.element(content))

  controller = ['$element', '$scope', '$attrs', ($element, $scope, $attrs) ->
    @form = @input = undefined

    formGroup = ->
      node = $element.parent()
      node = node.parent() while node.length && !node.hasClass('form-group')
      node
    isTouched = =>
      @form && @input && (@form.$submitted || @input.$touched)
    $scope.hasSuccess = =>
      isTouched() && @input.$dirty && @input.$valid
    $scope.hasError = =>
      isTouched() && @input.$invalid

    $scope.$watch $scope.hasError, (value) ->
      formGroup().toggleClass('has-error', value)
      return
    $scope.$watch $scope.hasSuccess, (value) ->
      formGroup().toggleClass('has-success', value)
      return

    return
  ]

  preLink = (scope, element, attrs, ctrls) ->
    form  = ctrls[0]
    ctrl  = ctrls[1]
    model = attrs.ngModel || ""

    attrs.$set 'name', model.split('.')[1] unless attrs.name
    attrs.$set 'id',   "#{form.$name}_#{model.replace('.', '_')}" unless attrs.id

    ctrl.form  = form
    ctrl.input = form[attrs.name]

    return

  postLink = (scope, element, attrs, ctrls) ->
    form    = ctrls[0]
    options = scope.$eval(attrs.bsFormGroup) || {}

    element.addClass('form-control')
    element.wrap('<div class="form-group"></div>')

    wrap  = element.parent()
    wrap.addClass(options.wrapClass) if options.wrapClass

    if options.prefix || options.prefixIcon || options.suffix || options.suffixIcon
      element.wrap(angular.element('<div class="input-group"></div>'))
      group = element.parent()
      if options.prefix || options.prefixIcon
        group.prepend inputAddon(options.prefix, options.prefixIcon)
      if options.suffix || options.suffixIcon
        group.append inputAddon(options.suffix, options.suffixIcon)

    unless options.nolabel
      label = angular.element('<label class="control-label"></label>')
      label.text(options.label || titleize(attrs.name))
      label.attr('for', attrs.id)
      label.addClass(options.labelClass) if options.labelClass
      wrap.prepend(label)

    unless options.noerrors
      errors = angular.element('<div class="control-errors" bs-input-errors ng-show="hasError()"></div>')
      errors.attr('name', attrs.name)
      errors = $compile(errors)(scope)
      wrap.append(errors)

    return

  {
    restrict:   'A'
    require:    ['^form', 'bsFormGroup']
    controller: controller
    scope:      true
    link:
      pre: preLink
      post: postLink
  }
