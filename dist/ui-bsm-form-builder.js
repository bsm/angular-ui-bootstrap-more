(function() {
  var mod;

  mod = angular.module('ui.bootstrap.more.form-builder', []);

  mod.provider('bsFormBuilderConfig', function() {
    this.templates = {
      formGroup: '<div class="form-group"></div>',
      inputGroup: '<div class="input-group"></div>',
      inputAddon: '<div class="input-group-addon"></div>',
      label: '<label class="control-label"></label>',
      input: '<input class="form-control" />',
      select: '<select class="form-control"></select>'
    };
    this.$get = (function(_this) {
      return function() {
        return {
          templates: _this.templates
        };
      };
    })(this);
  });

  mod.factory('bsFormBuilder', ["$compile", "bsFormBuilderConfig", function($compile, bsFormBuilderConfig) {
    var makeInputGroup, titleize;
    titleize = function(name) {
      var word, words;
      words = (function() {
        var _i, _len, _ref, _results;
        _ref = name.replace(/([A-Z])/g, ' $1').split(' ');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          word = _ref[_i];
          _results.push(word.charAt(0).toUpperCase() + word.slice(1).toLowerCase());
        }
        return _results;
      })();
      return words.join(' ');
    };
    makeInputGroup = function(content, icon) {
      var addon, group;
      if (icon != null) {
        content = "<i class=\"" + icon + "\" />";
      }
      addon = angular.element(bsFormBuilderConfig.templates.inputAddon);
      addon.append(angular.element(content));
      group = angular.element(bsFormBuilderConfig.templates.inputGroup);
      group.append(addon);
      return group;
    };
    return function(scope, element, input, attrs, formCtrl) {
      var attr, group, label, name, wrap, _i, _len, _ref;
      name = attrs.ngModel.split('.')[1];
      attrs.$set('name', attrs.name || name);
      attrs.$set('id', attrs.id || ("" + formCtrl.$name + "_" + (attrs.ngModel.replace('.', '_'))));
      attrs.$set('bsInputErrors', attrs.messages || '{}');
      group = input;
      wrap = angular.element(bsFormBuilderConfig.templates.formGroup);
      if (attrs.nolabel == null) {
        label = angular.element(bsFormBuilderConfig.templates.label);
        label.attr('for', attrs.id);
        label.html(attrs.label || titleize(name));
      }
      if ((attrs.prefix != null) || (attrs.prefixIcon != null)) {
        group = makeInputGroup(attrs.prefix, attrs.prefixIcon);
        group.append(input);
      } else if ((attrs.suffix != null) || (attrs.suffixIcon != null)) {
        group = makeInputGroup(attrs.suffix, attrs.suffixIcon);
        group.prepend(input);
      }
      attrs.$set('messages', null);
      attrs.$set('class', null);
      attrs.$set('label', null);
      _ref = element[0].attributes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attr = _ref[_i];
        input.attr(attr.name, attr.value || ' ');
      }
      scope.$watch(function() {
        var field;
        field = formCtrl[name];
        return (field != null) && field.$invalid && (formCtrl.$submitted || field.$touched || field.$dirty);
      }, function(invalid) {
        return wrap.toggleClass('has-error', invalid);
      });
      element.after(wrap);
      element.remove();
      if (label != null) {
        wrap.append(label);
      }
      wrap.append(group);
      $compile(wrap.contents())(scope);
      return name;
    };
  }]);

  mod.directive('bsSubmit', ["$window", function($window) {
    var onLink;
    onLink = function(scope, element, attrs) {
      attrs.label || (attrs.label = 'Save');
      scope.onCancel = function() {
        return $window.history.back();
      };
    };
    return {
      restrict: 'AE',
      require: '^form',
      link: onLink,
      scope: {
        label: '@'
      },
      templateUrl: 'template/ui-bootstrap-more/form-builder/submit.html'
    };
  }]);

  mod.directive('bsInput', ["bsFormBuilderConfig", "bsFormBuilder", function(bsFormBuilderConfig, bsFormBuilder) {
    return {
      restrict: 'AE',
      require: '^form',
      link: {
        pre: function(scope, element, attrs, ctrl) {
          var input;
          attrs.type || attrs.$set('type', 'text');
          scope = scope.$new();
          input = angular.element(bsFormBuilderConfig.templates.input);
          bsFormBuilder(scope, element, input, attrs, ctrl);
        }
      }
    };
  }]);

  mod.directive('bsSelect', ["bsFormBuilderConfig", "bsFormBuilder", function(bsFormBuilderConfig, bsFormBuilder) {
    return {
      restrict: 'AE',
      require: '^form',
      link: {
        pre: function(scope, element, attrs, ctrl) {
          var input;
          scope = scope.$new();
          input = angular.element(bsFormBuilderConfig.templates.select);
          input.append(element.contents());
          bsFormBuilder(scope, element, input, attrs, ctrl);
        }
      }
    };
  }]);

  mod.directive('bsFormGroup', ["$compile", function($compile) {
    var controller, inputAddon, postLink, preLink, titleize;
    titleize = function(name) {
      var word, words;
      words = (function() {
        var _i, _len, _ref, _results;
        _ref = name.replace(/([A-Z])/g, ' $1').split(' ');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          word = _ref[_i];
          _results.push(word.charAt(0).toUpperCase() + word.slice(1).toLowerCase());
        }
        return _results;
      })();
      return words.join(' ');
    };
    inputAddon = function(content, icon) {
      if (icon != null) {
        content = "<i class=\"" + icon + "\" />";
      }
      return angular.element('<div class="input-group-addon"></div>').append(angular.element(content));
    };
    controller = [
      '$element', '$scope', '$attrs', function($element, $scope, $attrs) {
        var formGroup, isTouched;
        this.form = this.input = void 0;
        formGroup = function() {
          var node;
          node = $element.parent();
          while (node.length && !node.hasClass('form-group')) {
            node = node.parent();
          }
          return node;
        };
        isTouched = (function(_this) {
          return function() {
            return _this.form && _this.input && (_this.form.$submitted || _this.input.$touched);
          };
        })(this);
        $scope.hasSuccess = (function(_this) {
          return function() {
            return isTouched() && _this.input.$dirty && _this.input.$valid;
          };
        })(this);
        $scope.hasError = (function(_this) {
          return function() {
            return isTouched() && _this.input.$invalid;
          };
        })(this);
        $scope.$watch($scope.hasError, (function(_this) {
          return function(value) {
            formGroup().toggleClass('has-error', value);
          };
        })(this));
        $scope.$watch($scope.hasSuccess, (function(_this) {
          return function(value) {
            formGroup().toggleClass('has-success', value);
          };
        })(this));
      }
    ];
    preLink = function(scope, element, attrs, ctrls) {
      var ctrl, form, model;
      form = ctrls[0];
      ctrl = ctrls[1];
      model = attrs.ngModel || "";
      if (!attrs.name) {
        attrs.$set('name', model.split('.')[1]);
      }
      if (!attrs.id) {
        attrs.$set('id', "" + form.$name + "_" + (model.replace('.', '_')));
      }
      ctrl.form = form;
      ctrl.input = form[attrs.name];
    };
    postLink = function(scope, element, attrs, ctrls) {
      var errors, form, group, label, options, wrap;
      form = ctrls[0];
      options = scope.$eval(attrs.bsFormGroup) || {};
      element.addClass('form-control');
      element.wrap('<div class="form-group"></div>');
      wrap = element.parent();
      if (options.wrapClass) {
        wrap.addClass(options.wrapClass);
      }
      if (options.prefix || options.prefixIcon || options.suffix || options.suffixIcon) {
        element.wrap(angular.element('<div class="input-group"></div>'));
        group = element.parent();
        if (options.prefix || options.prefixIcon) {
          group.prepend(inputAddon(options.prefix, options.prefixIcon));
        }
        if (options.suffix || options.suffixIcon) {
          group.append(inputAddon(options.suffix, options.suffixIcon));
        }
      }
      if (!options.nolabel) {
        label = angular.element('<label class="control-label"></label>');
        label.text(options.label || titleize(attrs.name));
        label.attr('for', attrs.id);
        if (options.labelClass) {
          label.addClass(options.labelClass);
        }
        wrap.prepend(label);
      }
      if (!options.noerrors) {
        errors = angular.element('<div class="control-errors" bs-input-errors ng-show="hasError()"></div>');
        errors.attr('name', attrs.name);
        errors = $compile(errors)(scope);
        wrap.append(errors);
      }
    };
    return {
      restrict: 'A',
      require: ['^form', 'bsFormGroup'],
      controller: controller,
      scope: true,
      link: {
        pre: preLink,
        post: postLink
      }
    };
  }]);

}).call(this);

angular.module("ui.bootstrap.more.form-builder").run(["$templateCache", function($templateCache) {$templateCache.put("template/ui-bootstrap-more/form-builder/submit.html","<div class=\"form-group\">\n  <button class=\"btn btn-primary\" type=\"submit\" ng-bind=\"label\"></button>\n  <button class=\"btn btn-default\" type=\"cancel\" ng-click=\"onCancel()\">Cancel</button>\n</div>\n");}]);