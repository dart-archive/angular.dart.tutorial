Chapter 7: Production Deployment
==========================

- [Running the Sample App](#running-the-sample-app)
- [Overview](#overview)
- [Managing Compiled Code Size](#managing-compiled-code-size)
	- [Minification](#minification)
	- [@MirrorsUsed](#mirrorsused)
		- [Debugging](#debugging)
- [Optimizing Runtime Performance](#optimizing-runtime-performance)
	- [di Code Generator](#di-code-generator)
		- [Discovering Instantiable Types](#discovering-instantiable-types)
	- [AngularDart Parser Generator](#angulardart-parser-generator)
	- [Code Generators and Development Mode](#code-generators-and-development-mode)
- [Cross-browser Support](#cross-browser-support)


# Running the Sample App

Before running the app, make sure you run the code generators (see below for
more info) like so:

```
dart -c bin/generator.dart
```

You can then run the app in Dart Editor:
Right-click **Chapter_07/web/index.html**, and choose **Run as JavaScript**.

After the app is compiled to JavaScript,
the app should appear in your default browser.
You can copy the app's URL into any other browser you'd like to test.


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

All you need to do is run `pub build`, which has minification turned on
by default.

```
cd your_app
pub build
```

## ```@MirrorsUsed```

To help manage the code size of applications that use mirrors, Dart provides a
[```@MirrorsUsed```][mirrors-used] annotation. This annotation tells the dart2js
compiler which targets (classes, libraries, annotations, etc.) are being
reflected on. This way dart2js can skip all the unused stuff thus radically
reducing the output size.

```@MirrorsUsed``` is often hard to get right as it really depends on how/if
you use code generation (discussed later in "Optimizing Runtime Performance"
chapter). Assuming you do use code generation (as we do in this chapter) and
are using angular >=0.9.5, your annotation could look like this:

```
@MirrorsUsed(
    override: '*'
)
import 'dart:mirrors';
```

If you classes are not annotated by `@Ng...` and are used in expressions,
you will need to add the classes (or their libraries) to your application's
`@MirrorsUsed` annotation.

(The @MirrorsUsed code for this app used to be much longer, but as of 0.9.5,
Angular has default definitions that
include the APIs you're likely to need.)

### Debugging

If it happens that you have misconfigured `@MirrorsUsed`, you will likely
be seeing errors like "Cannot find class for: Foo" or your
directives/components/controllers will be ignored when running in JavaScript.
Usually, the easiest fix is to just add that class (or the whole library)
to ```@MirrorsUsed.targets```.

It's much easier to debug `@MirrorsUsed` while working with unminified 
dart2js output, as you'll be able to see unminified class/field names and
be able to much easier identify what is missing.


# Optimizing Runtime Performance

Currently there are two code generators: di and AngularDart Parser generators.

## di Code Generator

di.dart Injector uses dart:mirrors APIs for retrieving types of constructor
parameters and invoking the constructor to create new instances. The generator
generates static code for creating new instances and resolving dependencies.

You can find an example of how to use the di generator in
```bin/generator.dart``` file.

### Discovering Instantiable Types

Ideally, types that are instantiated by the injector should be extracted from
the module definitions, however currently di modules are dynamically defined
and are mutable, making them very hard (impossible in some cases) to analyze
statically.

The generator has to rely on some guidance from the user to mark classes that
injector has to instantiate. There are two ways of doing this: @Injectables
or custom class annotation.

`@Injectables` is an annotation provided by the di package which can be
applied on a library definition with a list of types that the generator
should process.

```
@Injectables(const [
    MyService
])
library my_service_librarry;

import 'package:di/annotations.dart';

class MyService {
  // ...
}
```

`@Injectables` annotation should be mainly used with classes that are out of
your control (ex. you can't modify the source code -- third party library).
In all other cases it's preferable to use custom class annotation(s).

You can define your own custom class annotations

```
library injectable;

/**
 * An annotation specifying that the annotated class will be instantiated by
 * di Injector and type factory code generator should include it in its output.
 */
class InjectableService {
  const InjectableService();
}
```

and apply them on classes that you need to be instantiated by the injector.

```
@InjectableService()
class QueryService {
  // ...
}
```

You can then then configure generator to look for those annotations.

When configuring the generator with the custom annotation you need to pass
a fully qualified class name (including the library prefix). In case of the
above example the fully qualified name of Service annotation would be
`injectable.InjectableService`.

## AngularDart Parser Generator

AngularDart Parser Generator extracts all expressions from your application
and then compiles them into Dart, so at runtime it doesn't have to parse those
expressions and while invoking the expressions it uses pre-generated code to
access fields and methods, so it doesn't have to use mirrors.

There are many places in the application where expressions can be used:

1. HTML template attributes
1. mustaches {{ }} (technically a directive)
1. custom syntax directives like ng-repeat
1. component/directive attribute mappings
1. programmatic calls to Scope.$eval, Scope.$watch/$watchCollection,
   Parser.call, etc.

It's not always trivial to tell if element attribute in HTML template contains
an expression or just a string value.

Expression extractor has to:

1. find all component/directive definitions in the source code and extract
   their metadata (NgAnnotations, field attribute mapping annotations)
1. statically "compile" all the templates to identify all directives and
   extract all attributes and mustaches that contain expressions

Sometimes directives with attributes mapped with @ spec can subsequently call
`Scope.$eval` on the string value of the attribute. In those cases directive
can tell expression extractor that attribute value is used in this way via
`exportExpressionAttrs` property on `NgDirective`/`NgComponent` annotation. Ex:

```
@NgComponent(
  selector: 'foo'
  exportExpressionAttrs: 'bar'
)
class FooComponent implement NgAttachAware {
  @NgAttr('bar')
  String bar;
  Scope scope;

  FooComponent(Scope this.scope);

  attach() {
   scope.$watch(bar, _barChanged);
  }

  _barChanged(val) {}
}
```

Similarly, if directive programmatically evaluates an expression it can tell
expression extractor which expressions it evaluates:

```
@NgDirective(
  selector: 'foo'
  exportExpressions: '1 + 3'
)
class FooDirective {
  FooComponent(Scope scope) {
    _showResult(scope.$eval('1 + 2'));
  }
}
```

You can find an example of how to use the parser generator in
`bin/generator.dart` file.

## Code Generators and Development Mode

You should not be using code generators during development, as they are slow
and can significanly degrade productivity. Instead, during development it's
better to use dynamic versions of di Injector and Parser and use generators
only for testing and production.

In ```web/main.dart``` you can see ```initializer-prod.dart``` file being
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

Include the script tag before any other script tags:

```
<script src="packages/shadow_dom/shadow_dom.min.js"></script>
```

or the debug version:

```
<script src="packages/shadow_dom/shadow_dom.debug.js"></script>
```

**NOTE:** Using the polyfill has [some limitations][shadowdom-limitations],
so make sure you are aware of those limitations before you start using it.

[dart-mirrors-api]: https://api.dartlang.org/docs/channels/stable/latest/dart_mirrors.html
[shadowdom101]: http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom/
[shadowdom-limitations]: https://github.com/polymer/ShadowDOM#known-limitations
[shadow-dom-polyfill]: http://pub.dartlang.org/packages/shadow_dom
[dart2js]: https://www.dartlang.org/docs/dart-up-and-running/contents/ch04-tools-dart2js.html
[mirrors-used]: https://api.dartlang.org/docs/channels/stable/latest/dart_mirrors/MirrorsUsed.html
