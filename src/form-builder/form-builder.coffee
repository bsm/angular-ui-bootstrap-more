mod = angular.module 'ui.bootstrap.more.form-builder', []

mod.provider 'bsFormBuilderConfig', ->
  @templates =
    formGroup  : '<div class="form-group"></div>'
    inputGroup : '<div class="input-group"></div>'
    inputAddon : '<div class="input-group-addon"></div>'
    label      : '<label class="control-label"></label>'
    input      : '<input class="form-control" />'
    select     : '<select class="form-control"></select>'

  @$get = =>
    {templates: @templates}
  return

mod.factory 'bsFormBuilder', ($compile, bsFormBuilderConfig) ->
  titleize = (name) ->
    words = for word in name.replace(/([A-Z])/g, ' $1').split(' ')
      word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
    words.join(' ')
  makeInputGroup = (content, icon) ->
    content = "<i class=\"#{icon}\" />" if icon?
    addon = angular.element(bsFormBuilderConfig.templates.inputAddon)
    addon.append angular.element(content)
    group = angular.element(bsFormBuilderConfig.templates.inputGroup)
    group.append addon
    group

  (scope, element, input, attrs, formCtrl) ->
    name = attrs.ngModel.split('.')[1]
    attrs.$set 'name', attrs.name || name
    attrs.$set 'id', attrs.id || "#{formCtrl.$name}_#{attrs.ngModel.replace('.', '_')}"
    attrs.$set 'bsInputErrors', attrs.messages || '{}'

    # Build elements
    group = input
    wrap  = angular.element(bsFormBuilderConfig.templates.formGroup)
    unless attrs.nolabel?
      label = angular.element(bsFormBuilderConfig.templates.label)
      label.attr 'for', attrs.id
      label.html attrs.label || titleize(name)
    if attrs.prefix? || attrs.prefixIcon?
      group = makeInputGroup(attrs.prefix, attrs.prefixIcon)
      group.append(input)
    else if attrs.suffix? || attrs.suffixIcon?
      group = makeInputGroup(attrs.suffix, attrs.suffixIcon)
      group.prepend(input)

    # Unset helper attributes
    attrs.$set 'messages', null
    attrs.$set 'class', null
    attrs.$set 'label', null

    # Copy input attributes
    for attr in element[0].attributes
      input.attr(attr.name, attr.value || ' ')

    # Watch field for signs of invalidness
    scope.$watch ->
      field = formCtrl[name]
      field? && field.$invalid && (formCtrl.$submitted || field.$touched || field.$dirty)
    , (invalid) ->
      wrap.toggleClass('has-error', invalid)

    # Assemble containers & compile
    element.after(wrap)
    element.remove()
    wrap.append(label) if label?
    wrap.append(group)
    $compile(wrap.contents())(scope)

    name

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

# Input directive
mod.directive 'bsInput', (bsFormBuilderConfig, bsFormBuilder) ->
  {
    restrict: 'AE'
    require:  '^form'
    link:
      pre: (scope, element, attrs, ctrl) ->
        attrs.type || attrs.$set 'type', 'text'
        scope = scope.$new()
        input = angular.element(bsFormBuilderConfig.templates.input)
        bsFormBuilder(scope, element, input, attrs, ctrl)
        return
  }

# Select directive
mod.directive 'bsSelect', (bsFormBuilderConfig, bsFormBuilder) ->
  {
    restrict: 'AE'
    require:  '^form'
    link:
      pre: (scope, element, attrs, ctrl) ->
        scope = scope.$new()
        input = angular.element(bsFormBuilderConfig.templates.select)
        input.append(element.contents())
        bsFormBuilder(scope, element, input, attrs, ctrl)
        return
  }
