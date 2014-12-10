(function() {
  var mod;

  mod = angular.module('ui.bootstrap.more.form-builder', []);

  mod.factory('bsInputAddonHook', function() {
    return function(element, position, content, icon) {
      var addon;
      if (icon) {
        content = angular.element("<i class=\"" + icon + "\" />");
      }
      addon = angular.element('<div class="input-group-addon"></div>').append(content);
      return element.wrap('<div class="input-group"></div>').parent()[position](addon);
    };
  });

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

  mod.directive('prefixIcon', ["bsInputAddonHook", function(bsInputAddonHook) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        return bsInputAddonHook(element, 'prepend', "", attrs.prefixIcon);
      }
    };
  }]);

  mod.directive('prefix', ["bsInputAddonHook", function(bsInputAddonHook) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        return bsInputAddonHook(element, 'prepend', attrs.prefix, null);
      }
    };
  }]);

  mod.directive('suffixIcon', ["bsInputAddonHook", function(bsInputAddonHook) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        return bsInputAddonHook(element, 'append', "", attrs.suffixIcon);
      }
    };
  }]);

  mod.directive('suffix', ["bsInputAddonHook", function(bsInputAddonHook) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        return bsInputAddonHook(element, 'append', attrs.suffix, null);
      }
    };
  }]);

  mod.directive('formGroup', ["$compile", function($compile) {
    var controller, postLink;
    controller = [
      '$scope', '$element', '$attrs', function(scope, element, attrs) {
        var errors, label;
        label = errors = void 0;
        this.controlLabel = function(caption, target) {
          if (attrs.nolabel != null) {
            return;
          }
          if (!label) {
            label = angular.element('<label class="control-label"></label>');
            label.text(attrs.label || caption);
            if (attrs.labelClass) {
              label.addClass(attrs.labelClass);
            }
            element.prepend(label);
          }
          if (target && label && !label["for"]) {
            label.attr('for', target);
          }
        };
        this.inputErrors = function(name) {
          if (attrs.noerrors != null) {
            return;
          }
          if (!errors) {
            errors = angular.element('<div bs-input-errors></div>');
            errors.attr('name', name);
            errors = $compile(errors)(scope);
            element.append(errors);
          }
        };
      }
    ];
    postLink = function(scope, element, attrs, ctrl) {
      element.addClass('form-group');
      if (attrs.label) {
        ctrl.controlLabel(attrs.label);
      }
    };
    return {
      restrict: 'AC',
      scope: true,
      controller: controller,
      link: postLink
    };
  }]);

  mod.directive('ngModel', function() {
    var postLink, titleize;
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
    postLink = function(scope, element, attrs, formGroup) {
      var model;
      model = attrs.ngModel || "";
      if (!attrs.name) {
        attrs.$set('name', model.split('.')[1]);
      }
      if (!attrs.id) {
        attrs.$set('id', "" + (model.replace('.', '_')));
      }
      if (!formGroup) {
        return;
      }
      if (!(attrs.type === 'radio' || attrs.type === 'checkbox')) {
        element.addClass('form-control');
      }
      formGroup.controlLabel(titleize(attrs.name), attrs.id);
      formGroup.inputErrors(attrs.name);
    };
    return {
      restrict: 'A',
      require: '^?formGroup',
      link: postLink
    };
  });

}).call(this);

angular.module("ui.bootstrap.more.form-builder").run(["$templateCache", function($templateCache) {$templateCache.put("template/ui-bootstrap-more/form-builder/submit.html","<div class=\"form-group\">\n  <button class=\"btn btn-primary\" type=\"submit\" ng-bind=\"label\"></button>\n  <button class=\"btn btn-default\" type=\"cancel\" ng-click=\"onCancel()\">Cancel</button>\n</div>\n");}]);