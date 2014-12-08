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
    var onLink;
    onLink = function(scope, element, attrs, ctrls) {
      var kind, messages, msg, vals;
      element.after(element[0].children[0]);
      scope.input = ctrls[0];
      scope.form = ctrls[1];
      messages = angular.copy(bsInputErrorsConfig.messages);
      angular.extend(messages, scope.$eval(attrs.bsInputErrors));
      vals = {
        min: attrs.min,
        max: attrs.max,
        minlength: attrs.minlength || attrs.ngMinlength,
        maxlength: attrs.maxlength || attrs.ngMaxlength
      };
      scope.messages = {};
      for (kind in messages) {
        msg = messages[kind];
        scope.messages[kind] = $interpolate(msg)(vals);
      }
    };
    return {
      restrict: 'A',
      require: ['ngModel', '^?form'],
      link: onLink,
      scope: {},
      templateUrl: 'template/ui-bootstrap-more/input-errors/input-errors.html'
    };
  }]);

}).call(this);

angular.module("ui.bootstrap.more.input-errors").run(["$templateCache", function($templateCache) {$templateCache.put("template/ui-bootstrap-more/input-errors/input-errors.html","<div class=\"input-errors\" ng-show=\"(form.$submitted || input.$dirty || input.$touched) && input.$invalid\">\n  <p ng-repeat=\"(kind, _) in input.$error\" ng-show=\"$first\" class=\"help-block\" ng-bind=\"messages[kind]\"></p>\n</div>\n");}]);