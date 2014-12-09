(function() {
  var mod;

  mod = angular.module('ui.bootstrap.more.input-errors', []);

  mod.provider('bsInputErrorsConfig', function() {
    this.messages = {
      required: 'is required',
      minlength: 'too short, minimum {{minlength}} characters',
      maxlength: 'too long, maximum {{maxlength}} characters',
      pattern: 'has the wrong format',
      number: 'is not a number',
      email: 'is not a valid email address',
      url: 'is not a valid URL',
      min: 'must be at least {{min}}',
      max: 'must not be over {{max}}',
      invalid: 'is invalid'
    };
    this.$get = (function(_this) {
      return function() {
        return {
          messages: _this.messages
        };
      };
    })(this);
  });

  mod.directive('bsInputErrors', ["$interpolate", "bsInputErrorsConfig", function($interpolate, bsInputErrorsConfig) {
    var postLink;
    postLink = function(scope, element, attrs, form) {
      var input, kind, messages, msg, name, vals, _ref;
      name = $interpolate(attrs.name || '', false)(scope);
      scope.input = form[name];
      messages = angular.copy(bsInputErrorsConfig.messages);
      if (attrs.messages) {
        angular.extend(messages, scope.$eval(attrs.messages));
      }
      input = (_ref = element[0].parentNode) != null ? _ref.querySelector("[name='" + name + "']") : void 0;
      if (input != null) {
        input = angular.element(input);
      }
      vals = {
        min: attrs.min || (input != null ? input.attr('min') : void 0),
        max: attrs.max || (input != null ? input.attr('max') : void 0),
        minlength: attrs.minlength || (input != null ? input.attr('minlength') : void 0) || (input != null ? input.attr('ng-minlength') : void 0),
        maxlength: attrs.maxlength || (input != null ? input.attr('maxlength') : void 0) || (input != null ? input.attr('ng-maxlength') : void 0)
      };
      scope.messages = {};
      for (kind in messages) {
        msg = messages[kind];
        scope.messages[kind] = $interpolate(msg)(vals);
      }
    };
    return {
      restrict: 'AE',
      require: '^form',
      link: postLink,
      scope: {},
      templateUrl: 'template/ui-bootstrap-more/input-errors/input-errors.html'
    };
  }]);

}).call(this);

angular.module("ui.bootstrap.more.input-errors").run(["$templateCache", function($templateCache) {$templateCache.put("template/ui-bootstrap-more/input-errors/input-errors.html","<p ng-repeat=\"(kind, _) in input.$error\" ng-show=\"$first\" class=\"help-block\" ng-bind=\"messages[kind]\"></p>\n");}]);