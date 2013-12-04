Chapter 7: Production Deployment
==========================

# Running the Sample App

Before running the app, make sure you run the code generators (see below for
more info) like so:

```
dart -c bin/generator.dart
```

# Overview

When deploying your app in production you need to make sure that:

1. compiled ([dart2js][dart2js]) output is small
1. application performs as well in JavaScript as it does in Dart VM
1. application runs not only in Chrome, but other supported modern browsers

AngularDart and di heavily rely on [dart:mirrors][dart-mirrors-api] APIs.
Mirrors allow AngularDart to provide super fast developer friendly edit-refresh
cycle, without needing to run slow compilers and code generators.
However, mirrors come at a cost:

1. use of mirrors disables very important optimizations performed by
   [dart2js][dart2js] compiler, such as tree-shaking, which allows removal
   of unused code from the output, resulting in very large JavaScript file.
1. mirrors are much slower compared to static Dart code, which might not be
   an issue for smaller/medium applications, but in larger apps might become
   noticeable. Dart team is constantly working on improving performance of
   mirrors, so long-term it's not a problem, but in short-term it's something
   you might need to think about.

Here we will provide some tip on these subjects.

# Managing Compiled Code Size

## Minification

dart2js allows you to minify the resulting JavaScript, which:

* removes unnecessary whitespace
* shortens the class and field names

Minification can reduce your resulting JavaScript by 2-3x.

All you need to do, is to include ```--minify``` flag in dart2js command line.

```
dart2js web/main.dart --minify -o web/main.dart.js
```

## ```@MirrorsUsed```

To help manage the code size of applications that use mirrors, Dart provides
[```@MirrorsUsed```][mirrors-used] annotation using which you can tell dart2js
compiler which targets (classes, libraries, annotations, etc.) are being
reflected on. This way dart2js can skip all the unused stuff thus radically
reducing the output size.

```@MirrorsUsed``` is often hard to get right as it really depends on how/if
you use code generation (discussed later in "Optimizing Runtime Performance"
chapter). Assuming you do use code generation (as we do in this chapter) your
annotation could look something like this:

```
@MirrorsUsed(
    targets: const [
        'angular.core',
        'angular.core.dom',
        'angular.core.parser',
        'angular.routing',
        NodeTreeSanitizer
    ],
    metaTargets: const [
        NgInjectableService,
        NgComponent,
        NgDirective,
        NgController,
        NgFilter,
        NgAttr,
        NgOneWay,
        NgOneWayOneTime,
        NgTwoWay,
        NgCallback
    ],
    override: '*'
)
import 'dart:mirrors';
```

Here you are essentually telling dart2js that your application reflects on
```angular.core```, ```angular.core.dom```, ```angular.core.parser```, etc.
libraries, as well as on ```NodeTreeSanitizer``` class, and annotations
(metaTargets) like ```NgInjectableService```, ```NgComponent```,
```NgDirective```, etc.

### Debugging

If it happens that you have misconfigured ```@MirrorsUsed```, you will likely
be seeing errors like "Cannot find class for: Foo" or your
directives/components/controllers will be ignored when running in JavaScript.
Usually, the easiest fix is to just add that class (or the whole library)
to ```@MirrorsUsed.targets```.


# Optimizing Runtime Performance

Currently there are two code generators: di and AngularDart Parser generators.

## di Code Generator

di.dart Injector uses dart:mirrors APIs for retrieving types of constructor
parameters and invoking the constructor to create new instances. The generator
generates static code for creating new instances and resolving dependencies.

You can find an example of how to use the di generator in
```bin/generator.dart``` file.

## AngularDart Parser Generator

AngularDart Parser Generator extracts all expressions from your application
and then compiles them into Dart, so at runtime it doesn't have to parse those
expressions and while invoking the expressions it uses pre-generated code to
access fields and methods, so it doesn't have to use mirrors.

You can find an example of how to use the parser generator in
```bin/generator.dart``` file.

## Code Generators and Development Mode

You should not be using code generators during development, as they are slow
and can significanly degrade productivity. Instead, during development it's
better to use dynamic versions of di Injector and Parser and use generators
only for testing and production.

In ```lib/main.dart``` you can see ```initializer-prod.dart``` file being
imported, which has ```initializer-dev.dart``` counterpart. Switching between
those two file will allow you to switch between prod and dev modes. You will
need to run the generator script before using the prod mode.

It is highly recommended that you automate (via a script or a flag on the
server) the prod/dev mode switching to minimize the chance of dev mode being
released into production.

# Cross-browser Support

Angular components use [Shadow DOM][shadowdom101], but unfortunately it's not
natively supported in all modern browsers, so you would need to use a
[polyfill][shadow-dom-polyfill].

Make sure you include ```shadow_dom``` package in dependencies in pubspec.yaml.

```
dependencies:
  shadow_dom: any
```

And include the script tag:

```
<script src="packages/shadow_dom/shadow_dom.debug.js"></script>
```

or the debug version:

```
<script src="packages/shadow_dom/shadow_dom.debug.js"></script>
```

**NOTE:** using the polyfill has [some limitations][shadowdom-limitations],
so make sure you are aware of those limitations before you start using it.

[dart-mirrors-api]: https://api.dartlang.org/docs/channels/stable/latest/dart_mirrors.html
[shadowdom101]: http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom/
[shadowdom-limitations]: https://github.com/polymer/ShadowDOM#known-limitations
[shadow-dom-polyfill]: http://pub.dartlang.org/packages/shadow_dom
[dart2js]: https://www.dartlang.org/docs/dart-up-and-running/contents/ch04-tools-dart2js.html
[mirrors-used]: https://api.dartlang.org/docs/channels/stable/latest/dart_mirrors/MirrorsUsed.html