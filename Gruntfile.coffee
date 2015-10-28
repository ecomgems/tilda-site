# Generated on <%= (new Date).toISOString().split('T')[0] %> using <%= pkg.name %> <%= pkg.version %>
'use strict'

module.exports = (grunt) ->
  localConfig = {}
  try
    localConfig = require('./server/config/local.env')
  catch e
    localConfig = {}

  # Load grunt tasks automatically, when needed
  require('jit-grunt') grunt,
    express: 'grunt-express-server'
    useminPrepare: 'grunt-usemin'
    ngtemplates: 'grunt-angular-templates'
    cdnify: 'grunt-google-cdn'
    protractor: 'grunt-protractor-runner'
    injector: 'grunt-asset-injector'
    buildcontrol: 'grunt-build-control'

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt') grunt

  # Define the configuration for all the tasks
  grunt.initConfig

    # Project settings
    pkg: grunt.file.readJSON 'package.json'
    yeoman:
      # configurable paths
      dist: 'dist'

    express:
      options:
        port: process.env.HTTP_PORT or 8080

      dev:
        options:
          script: '.server/app.js'
          debug: true

      prod:
        options:
          script: 'dist/server/app.js'

    open:
      server:
        url: 'http://localhost:<%= express.options.port %>'

    watch:
      coffeeNode:
        files: ['server/**/*.{coffee,litcoffee,coffee.md}']
        tasks: ['newer:coffee']

      mochaTest:
        files: ['.server/**/*.spec.js']
        tasks: ['env:test', 'mochaTest']

      gruntfile:
        files: ['Gruntfile.coffee']

      express:
        files: ['.server/**/*.{js,json}']
        tasks: ['express:dev', 'wait']
        options:
          livereload: true
          nospawn: true #Without this option specified express won't be reloaded

    coffeelint:
      app: [
        'server/**/*.coffee'
        'client/**/*.coffee'
      ]
      options:
        max_line_length:
          level: 'ignore'

    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: '<%= yeoman.client %>/.jshintrc'
        reporter: require 'jshint-stylish'

      server:
        options:
          jshintrc: 'server/.jshintrc'

        src: [
          'server/**/*.js'
          '!server/**/*.spec.js'
        ]

      serverTest:
        options:
          jshintrc: 'server/.jshintrc-spec'

        src: ['server/**/*.spec.js']

      all: [
        '<%= yeoman.client %>/{app,components}/**/*.js'
        '!<%= yeoman.client %>/{app,components}/**/*.spec.js'
        '!<%= yeoman.client %>/{app,components}/**/*.mock.js'
      ]

      test:
        src: [
          '<%= yeoman.client %>/{app,components}/**/*.spec.js'
          '<%= yeoman.client %>/{app,components}/**/*.mock.js'
        ]

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            '.tmp'
            '.server'
            '<%= yeoman.dist %>/*'
            '!<%= yeoman.dist %>/.git*'
            '!<%= yeoman.dist %>/.openshift'
            '!<%= yeoman.dist %>/Procfile'
          ]
        ]

      server: [
        '.tmp'
        '.server'
      ]

    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ['last 1 version']

      dist:
        files: [
          expand: true
          cwd: '.tmp/'
          src: '{,*/}*.css'
          dest: '.tmp/'
        ]

    # Debugging with node inspector
    'node-inspector':
      custom:
        options:
          'web-host': 'localhost'

    # Use nodemon to run server in debug mode with an initial breakpoint
    nodemon:
      debug:
        script: '.server/app.js'
        options:
          nodeArgs: ['--debug-brk']
          env:
            PORT: process.env.PORT or 9000

          callback: (nodemon) ->
            nodemon.on 'log', (event) ->
              console.log event.colour

            # opens browser on initial server start
            nodemon.on 'config:update', ->
              setTimeout ->
                require('open') 'http://localhost:8080/debug?port=5858'
              , 500

    # Automatically inject Bower components into the app
    wiredep:
      target:
        src: '<%= yeoman.client %>/index.html'
        ignorePath: '<%= yeoman.client %>/'
        exclude: [
          /bootstrap-sass-official/
          /bootstrap.js/
          '/json3/'
          '/es5-shim/'

          /bootstrap.css/
          /font-awesome.css/

        ]

    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            '<%= yeoman.dist %>/public/{,*/}*.js'
            '<%= yeoman.dist %>/public/{,*/}*.css'
            '<%= yeoman.dist %>/public/assets/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
            '<%= yeoman.dist %>/public/assets/fonts/*'
          ]

    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: ['<%= yeoman.client %>/index.html']
      options:
        dest: '<%= yeoman.dist %>/public'

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: ['<%= yeoman.dist %>/public/{,*/}*.html']
      css: ['<%= yeoman.dist %>/public/{,*/}*.css']
      js: ['<%= yeoman.dist %>/public/{,*/}*.js']
      options:
        assetsDirs: [
          '<%= yeoman.dist %>/public'
          '<%= yeoman.dist %>/public/assets/images'
        ]

        # This is so we update image references in our ng-templates
        patterns:
          js: [
            [/(assets\/images\/.*?\.(?:gif|jpeg|jpg|png|webp|svg))/g
             'Update the JS to reference our revved images']
          ]

    # The following *-min tasks produce minified files in the dist folder
    imagemin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.client %>/assets/images'
          src: '{,*/}*.{png,jpg,jpeg,gif}'
          dest: '<%= yeoman.dist %>/public/assets/images'
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.client %>/assets/images'
          src: '{,*/}*.svg'
          dest: '<%= yeoman.dist %>/public/assets/images'
        ]

    # Allow the use of non-minsafe AngularJS files. Automatically makes it
    # minsafe compatible so Uglify does not destroy the ng references
    ngAnnotate:
      dist:
        files: [
          expand: true
          cwd: '.tmp/concat'
          src: '*/**.js'
          dest: '.tmp/concat'
        ]

    # Package all the html partials into a single javascript payload
    ngtemplates:
      options:
        # This should be the name of your apps angular module
        module: 'tildaSiteApp'
        htmlmin:
          collapseBooleanAttributes: true
          collapseWhitespace: true
          removeAttributeQuotes: true
          removeEmptyAttributes: true
          removeRedundantAttributes: true
          removeScriptTypeAttributes: true
          removeStyleLinkTypeAttributes: true

        usemin: 'app/app.js'

      main:
        cwd: '<%= yeoman.client %>'
        src: ['{app,components}/**/*.html']
        dest: '.tmp/templates.js'

      tmp:
        cwd: '.tmp'
        src: ['{app,components}/**/*.html']
        dest: '.tmp/tmp-templates.js'

    # Replace Google CDN references
    cdnify:
      dist:
        html: ['<%= yeoman.dist %>/public/*.html']

    # Copies remaining files to places other tasks can use
    copy:
      node:
        files: [
          expand: true
          cwd: 'server'
          dest: '.server'
          src: [
            'views/**/*'
          ]
        ]

      dist:
        files: [
          expand: true
          cwd: '.server'
          dest: '<%= yeoman.dist %>/server'
          src: ['**/*']
        ,
          expand: true
          dest: '<%= yeoman.dist %>'
          src: ['package.json']
        ]

      styles:
        expand: true
        cwd: '<%= yeoman.client %>'
        dest: '.tmp/'
        src: ['{app,components}/**/*.css']

    buildcontrol:
      options:
        dir: 'dist'
        commit: true
        push: true
        connectCommits: false
        message: 'Built %sourceName% from commit %sourceCommit% on branch %sourceBranch%'

      heroku:
        options:
          remote: 'heroku'
          branch: 'master'

      openshift:
        options:
          remote: 'openshift'
          branch: 'master'

    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        'coffee'
        'copy:node'
      ]
      test: [
        'coffee'
      ],
      debug:
        tasks: [
          'nodemon'
          'node-inspector'
        ]
        options:
          logConcurrentOutput: true

      dist: [
        'coffee'
      ]

    # Test settings
    karma:
      unit:
        configFile: 'karma.conf.js'
        singleRun: true

    mochaTest:
      options:
        reporter: 'spec'
        require: 'coffee-script/register'

      src: ['server/**/*.spec.coffee']

    protractor:
      options:
        configFile: 'protractor.conf.js'

      chrome:
        options:
          args:
            browser: 'chrome'

    env:
      test:
        NODE_ENV: 'test'

      prod:
        NODE_ENV: 'production'

      all: localConfig

    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ''

      server:
        files: [
          expand: true
          cwd: 'server'
          src: [
            '**/*.coffee'
          ]
          dest: '.server'
          ext: '.js'
          extDot: 'last'
        ]

    injector:
      options: {}

      # Inject application script files into index.html (doesn't include bower)
      scripts:
        options:
          transform: (filePath) ->
            filePath = filePath.replace '/client/', ''
            filePath = filePath.replace '/.tmp/', ''
            '<script src="' + filePath + '"></script>'

          starttag: '<!-- injector:js -->'
          endtag: '<!-- endinjector -->'

        files:
          '<%= yeoman.client %>/index.html': [[
                                                '{.tmp,<%= yeoman.client %>}/{app,components}/**/*.js'
                                                '!{.tmp,<%= yeoman.client %>}/app/app.js'
                                                '!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.spec.js'
                                                '!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.mock.js'
                                              ]]

      # Inject component css into index.html
      css:
        options:
          transform: (filePath) ->
            filePath = filePath.replace '/client/', ''
            filePath = filePath.replace '/.tmp/', ''
            '<link rel="stylesheet" href="' + filePath + '">'

          starttag: '<!-- injector:css -->'
          endtag: '<!-- endinjector -->'

        files:
          '<%= yeoman.client %>/index.html': [
            '<%= yeoman.client %>/{app,components}/**/*.css'
          ]

  # Used for delaying livereload until after server has restarted
  grunt.registerTask 'wait', ->
    grunt.log.ok 'Waiting for server reload...'
    done = @async()
    setTimeout ->
      grunt.log.writeln 'Done waiting!'
      done()
    , 1500

  grunt.registerTask 'express-keepalive', 'Keep grunt running', ->
    @async()

  grunt.registerTask 'serve', (target) ->

    grunt.task.run [
      'env:all'
    ]

    if target is 'dist'
      return grunt.task.run [
        'build'
        'env:prod'
        'express:prod'
        'wait'
        'express-keepalive'
      ]

    if target is 'debug'
      return grunt.task.run [
        'clean:server'
        'concurrent:server'
        'concurrent:debug'
      ]

    grunt.task.run [
      'clean:server'
      'concurrent:server'
      'express:dev'
      'wait'
      'watch'
    ]

  grunt.registerTask 'server', ->
    grunt.log.warn 'The `server` task has been deprecated. Use `grunt serve` to start a server.'
    grunt.task.run ['serve']

  grunt.registerTask 'test', (target) ->
    if target is 'server'
      return grunt.task.run [
        'env:all'
        'env:test'
        'mochaTest'
      ]

    else if target is 'client'
      return grunt.task.run [
        'clean:server'
      ]

    else if target is 'e2e'
      return grunt.task.run [
        'clean:server'
        'express:dev'
      ]

    else
      return grunt.task.run [
        'test:server'
      ]

  grunt.registerTask 'build', [
    'clean:dist'
    'concurrent:dist'
    'copy:node'
    'copy:dist'
  ]

  grunt.registerTask('default', [
    'newer:coffeelint'
    'test'
    'build'
  ])
