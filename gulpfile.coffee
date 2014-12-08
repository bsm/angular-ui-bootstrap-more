fs     = require 'fs'
del    = require 'del'
path   = require 'path'
gulp   = require 'gulp'
gulpif = require 'gulp-if'
gutil  = require 'gulp-util'
rename = require 'gulp-rename'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
merge  = require 'merge-stream'
karma  = require 'gulp-karma'

coffeelint    = require 'gulp-coffeelint'
ngAnnotate    = require 'gulp-ng-annotate'
templateCache = require 'gulp-angular-templatecache'
srcRoot       = './src'

gulp.task 'default', ['dist']

## DIST

gulp.task 'dist:clean', (cb) ->
  del ['./dist'], cb

gulp.task 'dist', ['dist:clean'], ->
  names = fs.readdirSync(srcRoot).filter (file) ->
    fs.statSync(path.join(srcRoot, file)).isDirectory()
  tasks = for name in names
    cacheOpts =
      root: 'template/ui-bootstrap-more'
      module: "ui.bootstrap.more.#{name}"
    gulp.src [
      "#{srcRoot}/#{name}*/**"
      "!#{srcRoot}/**/*_test.*"
    ]
      .pipe gulpif(/[.]coffee$/, coffeelint())
      .pipe gulpif(/[.]coffee$/, coffeelint.reporter().on('error', gutil.log))
      .pipe gulpif(/[.]coffee$/, coffee())
      .pipe gulpif(/[.]html$/, templateCache(cacheOpts))
      .pipe concat("ui-bsm-#{name}.js")
      .pipe ngAnnotate()
      .pipe gulp.dest('./dist')
      .pipe uglify()
      .pipe rename(suffix: '.min')

  merge(tasks)

## TEST

gulp.task 'test:clean', (cb) ->
  del ['./test'], cb

gulp.task 'test:prepare', ['test:clean'], ->
  gulp.src [
    "#{srcRoot}/**/*_test.*"
  ]
    .pipe coffee()
    .pipe gulp.dest('./test')

gulp.task 'test', ['dist', 'test:prepare'], ->
  gulp.src [
    './node_modules/angular/angular.js'
    './node_modules/angular-mocks/angular-mocks.js'
    './dist/**/*.js'
    './src/**/*_test.coffee'
  ]
    .pipe karma(configFile: 'karma.conf.js', action: 'run')

## WATCH

gulp.task 'watch', ['dist'], ->
  gulp.watch [
    "#{srcRoot}/**"
    "!#{srcRoot}/**/*_test.*"
  ], ['dist']
