# Contributing to mrkdown

The following guidelines will help ensure a smooth contribution process.

## Community Expectations

Please be polite to each other, even in a disagreement. More details can be
found in the [mrkdown Code of Conduct](CODE_OF_CONDUCT.md).

## Creating Issues

When possible, use one of the GitHub issue templates. Try to include as much of
the information requested as possible. As much as I try, when certain
information is missing, it makes it much harder or even impossible to reproduce
any bugs or other issues you may be encountering.

## Creating Pull Requests

### Code Style

This repository uses the @realm/SwiftLint project as a pre-commit hook on my
machine. It would be appreciated if you would follow the same setup after you
clone the repository if you're interested in contributing to mrkdown by opening
a pull request. Instructions are available in
[SwiftLint's README](https://github.com/realm/SwiftLint#git-pre-commit-hook).
Please ensure that your work does not raise any errors or warnings when the
hook runs.

I like two-space indents using spaces, not tabs.

Additionally, as a personal preference, I'm not a fan of the default comments
that Xcode inserts when creating a file. Please remove those; the top-level
import (usually `Foundation` or `SwiftUI`) should be the first line.

After the top-level import, the next line should be a blank line, followed by
any other first-party (Apple) imports, sorted alphabetically. Then another
blank line. Next come any third-party library imports (again sorted
alphabetically).

#### A simple example

```swift
import Foundation

extension Bool {
  ...
}
```

#### A more complicated example

```swift
import SwiftUI

import Markdown

struct SampleView: View {
  ...
}
```

### Compatibility

The current deployment target for mrkdown is iOS 16.4. I'm willing to bump the
deployment target to iOS 16.7. I am not willing to bump it to iOS 17 at this
time. The primary motivation for this is maintaining iPhone 8 support. If it is
necessary to implement a compelling feature, I am open to changing this stance.
I do not consider avoiding the use of `#available` to get around a deprecated
function to be "compelling".

### Licensing

This is an open-source project. By contributing code, it will be licensed under
the terms of [the MIT license](LICENSE).
