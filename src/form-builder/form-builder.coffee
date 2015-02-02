mod = angular.module 'ui.bootstrap.more.form-builder', []

mod.factory 'bsInputAddonHook', ->
  (element, position, content, icon) ->
    content = angular.element("<i class=\"#{icon}\" />") if icon
    addon   = angular.element('<div class="input-group-addon"></div>').append(content)
    element.wrap('<div class="input-group"></div>').parent()[position](addon)

mod.directive 'bsForm', ->
  {
    restrict:   'AC'
    require:    'form'
    link: (scope, element, attrs) ->
      attrs.$set 'novalidate', ''
      return
    controller: ->
      return
  }

mod.directive 'bsSubmit', ($window) ->
  postLink = (scope, element, attrs) ->
    attrs.label ||= 'Save'
    scope.onCancel = ->
      $window.history.back()
    return

  {
    restrict: 'AE'
    require:  '^bsForm'
    link:     postLink
    scope:
      label: '@'
    templateUrl: 'template/ui-bootstrap-more/form-builder/submit.html'
  }

mod.directive 'prefixIcon', (bsInputAddonHook) ->
  {
    restrict:  'A'
    require:   ['^?formGroup', 'ngModel']
    link:      (scope, element, attrs, ctrls) ->
      bsInputAddonHook(element, 'prepend', "", attrs.prefixIcon) if ctrls[0]
      return
  }

mod.directive 'prefix', (bsInputAddonHook) ->
  {
    restrict: 'A'
    require:   ['^?formGroup', 'ngModel']
    link:     (scope, element, attrs, ctrls) ->
      bsInputAddonHook(element, 'prepend', attrs.prefix, null) if ctrls[0]
      return
  }

mod.directive 'suffixIcon', (bsInputAddonHook) ->
  {
    restrict:  'A'
    require:   ['^?formGroup', 'ngModel']
    link:      (scope, element, attrs, ctrls) ->
      bsInputAddonHook(element, 'append', "", attrs.suffixIcon) if ctrls[0]
      return
  }

mod.directive 'suffix', (bsInputAddonHook) ->
  {
    restrict: 'A'
    require:   ['^?formGroup', 'ngModel']
    link:     (scope, element, attrs, ctrls) ->
      bsInputAddonHook(element, 'append', attrs.suffix, null) if ctrls[0]
      return
  }

mod.directive 'formGroup', ($compile) ->

  controller = ['$scope', '$element', '$attrs', (scope, element, attrs) ->
    label = errors = undefined

    # Insert control label
    @$$bsFormGroupControlLabel = (caption, target) ->
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
    @$$bsFormControlInputErrors = (name) ->
      return if attrs.noerrors?

      unless errors
        errors = angular.element('<div bs-input-errors></div>')
        errors.attr('name', name)
        errors.attr('messages', attrs.errors) if attrs.errors?
        errors = $compile(errors)(scope)
        element.append(errors)
      return

    return
  ]

  postLink = (scope, element, attrs, ctrl) ->
    element.addClass('form-group')
    ctrl.$$bsFormGroupControlLabel(attrs.label) if attrs.label
    return

  {
    restrict:   'AC'
    controller: controller
    link:       postLink
  }


mod.directive 'ngModel', ->

  titleize = (name) ->
    words = for word in name.replace(/([A-Z])/g, ' $1').split(' ')
      word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
    words.join(' ')

  preLink = (scope, element, attrs, ctrls) ->
    # Make this input a form-control
    unless !ctrls[1] || attrs.nocontrol? || attrs.type == 'radio' || attrs.type == 'checkbox'
      element.addClass('form-control')

    # Stop here if not wrapped in a bs-form
    return unless ctrls[0]

    # Automatically set name and ID
    model = attrs.ngModel || ""
    path  = model.split('.')
    attrs.$set 'name', path[1..].join('_') unless attrs.name
    attrs.$set 'id',   path.join('_')      unless attrs.id

    # Stop here if not wrapped in form-group (or no name)
    return unless ctrls[1] && attrs.name

    # Update label and set errors
    ctrls[1].$$bsFormGroupControlLabel(titleize(path[path.length-1] || ""), attrs.id)
    ctrls[1].$$bsFormControlInputErrors(attrs.name)

    return

  {
    restrict:  'A'
    require:   ['^?bsForm', '^?formGroup']
    link:
      pre: preLink
  }
