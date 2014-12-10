mod = angular.module 'ui.bootstrap.more.form-builder', []

mod.factory 'bsInputAddonHook', ->
  (element, position, content, icon) ->
    content = angular.element("<i class=\"#{icon}\" />") if icon
    addon   = angular.element('<div class="input-group-addon"></div>').append(content)
    element.wrap('<div class="input-group"></div>').parent()[position](addon)

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

mod.directive 'prefixIcon', (bsInputAddonHook) ->
  {
    restrict:  'A'
    require:   'ngModel'
    link:      (scope, element, attrs) ->
      bsInputAddonHook(element, 'prepend', "", attrs.prefixIcon)
  }

mod.directive 'prefix', (bsInputAddonHook) ->
  {
    restrict: 'A'
    require:   'ngModel'
    link:     (scope, element, attrs) -> bsInputAddonHook(element, 'prepend', attrs.prefix, null)
  }

mod.directive 'suffixIcon', (bsInputAddonHook) ->
  {
    restrict:  'A'
    require:   'ngModel'
    link:      (scope, element, attrs) -> bsInputAddonHook(element, 'append', "", attrs.suffixIcon)
  }

mod.directive 'suffix', (bsInputAddonHook) ->
  {
    restrict: 'A'
    require:  'ngModel'
    link:     (scope, element, attrs) -> bsInputAddonHook(element, 'append', attrs.suffix, null)
  }

mod.directive 'formGroup', ($compile) ->

  controller = ['$scope', '$element', '$attrs', (scope, element, attrs) ->
    label = errors = undefined

    # Insert control label
    @controlLabel = (caption, target) ->
      return if attrs.nolabel?

      unless label
        label = angular.element('<label class="control-label"></label>')
        label.text(attrs.label || caption)
        label.addClass(attrs.labelClass) if attrs.labelClass
        element.prepend(label)

      if target && label && !label.for
        label.attr('for', target)
      return

    # Insert input errors
    @inputErrors = (name) ->
      return if attrs.noerrors?

      unless errors
        errors = angular.element('<div bs-input-errors></div>')
        errors.attr('name', name)
        errors = $compile(errors)(scope)
        element.append(errors)
      return

    return
  ]

  postLink = (scope, element, attrs, ctrl) ->
    element.addClass('form-group')
    ctrl.controlLabel(attrs.label) if attrs.label
    return

  {
    restrict:   'AC'
    scope:      true
    controller: controller
    link:       postLink
  }


mod.directive 'ngModel', ->

  titleize = (name) ->
    words = for word in name.replace(/([A-Z])/g, ' $1').split(' ')
      word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
    words.join(' ')

  postLink = (scope, element, attrs, formGroup) ->

    # Automatically set name and ID
    model = attrs.ngModel || ""
    attrs.$set 'name', model.split('.')[1] unless attrs.name
    attrs.$set 'id',   "#{model.replace('.', '_')}" unless attrs.id

    # Stop here if not wrapped in a bs:form-group
    return unless formGroup

    # Make this input a form-control
    unless attrs.nocontrol? || attrs.type == 'radio' || attrs.type == 'checkbox'
      element.addClass('form-control')

    # Update label and set errors
    formGroup.controlLabel(titleize(attrs.name), attrs.id)
    formGroup.inputErrors(attrs.name)

    return

  {
    restrict:  'A'
    require:   '^?formGroup'
    link:      postLink
  }
