module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files:      [],
    exclude:    [],
    preprocessors: {
      '**/*.coffee': 'coffee'
    },
    coffeePreprocessor: {
      options: { sourceMap: true }
    },
    reporters: ['progress'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['PhantomJS'],
    singleRun: false
  });
};
