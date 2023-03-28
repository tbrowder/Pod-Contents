[![Actions Status](https://github.com/tbrowder/Pod-Contents/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/Pod-Contents/actions) [![Actions Status](https://github.com/tbrowder/Pod-Contents/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/Pod-Contents/actions) [![Actions Status](https://github.com/tbrowder/Pod-Contents/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/Pod-Contents/actions)

NAME
====

Pod::Contents - a [Raku](https://www.raku-lang.ir/en) module for getting Pod contents as a list or string.

DESCRIPTION
===========

Pod::Contents is a [Raku](https://www.raku-lang.ir/en) module for getting the Pod contents as a list of strings or string. Pod formatters can get inlined, pod contents can be indented (with custom level) and joined with a custom string and titles can be included for table headers and defn terms.

SYNOPSIS
========

```raku
use Pod::Contents:auth<zef:CIAvash>;

=NAME My App

=DESCRIPTION An B<app> that does U<stuff>

=begin pod
=head1 A heading

=item An B<item>
=begin item2
Another C<item>

=begin table
hcell00 | hcell01
=================
cell11  | cell12
cell21  | cell22
=end table

     my $app;
     say 'some code';

=end item2

=end pod

put $=pod.&join-pod-contents-of: 'NAME';
=output My App␤

put $=pod.&get-first-pod('NAME').&join-pod-contents;
=output My App␤

put $=pod[0].&join-pod-contents;
=output My App␤

put $=pod[0].&get-pod-contents.join("\n\n");
=output My App␤

put $=pod.&join-pod-contents-of: 'DESCRIPTION';
=output An app that does stuff␤

put $=pod.&join-pod-contents-of: 'DESCRIPTION', :!inline-formatters;
=output An ␤␤app␤␤ that does ␤␤stuff␤

put $=pod.&join-pod-contents-of: 'DESCRIPTION', "\n", :!inline-formatters;
=output An ␤app␤ that does ␤stuff␤

put $=pod.&get-pod-contents-of('DESCRIPTION', :!inline-formatters).raku;
=output ("An ", "app", " that does ", "stuff")␤

put $=pod.&get-first-pod('pod').&join-pod-contents-of: Pod::Heading;
=output A heading␤

put $=pod.&join-pod-contents-of: Pod::Item, :recurse;
=output An item␤

put $=pod.&get-pod-contents-of(Pod::Block::Table, :recurse).raku;
=output (("cell11", "cell12"), ("cell21", "cell22"))␤

put $=pod.&get-pod-contents-of(Pod::Block::Table, :recurse, :include-title).raku;
=output (("hcell00", "hcell01"), ("cell11", "cell12"), ("cell21", "cell22"))␤

put $=pod.&join-pod-contents-of: Pod::Block::Table, :recurse;
=output cell11 cell12␤cell21 cell22␤

put $=pod.&join-pod-contents-of: Pod::Block::Table, :recurse, :include-title;
=output hcell00 hcell01␤cell11 cell12␤cell21 cell22␤

put $=pod.&join-pod-contents-of: Pod::Block::Code, :recurse;
=output my $app;␤say 'some code'␤

put $=pod.&join-pod-contents-of: Pod::Block::Code, :indent-content, :recurse;
=output     my $app;␤    say 'some code'␤

put $=pod.&get-first-pod('pod').contents.grep(Pod::Item)[1].&join-pod-contents(:indent-content);
=output     Another item␤␤   cell11 cell12␤cell21 cell22␤␤        my $app;␤        say 'some code'␤

put $=pod.&get-first-pod('pod').&get-pods(Pod::Item)[1].&join-pod-contents(:indent-content, :indent-level(2));
=output   Another item␤␤ cell11 cell12␤cell21 cell22␤␤      my $app;␤      say 'some code'␤

put $=pod.&get-pods(Pod::Item, :recurse)[1].&join-pod-contents(:indent-content, :indent-level(2));
=output   Another item␤␤ cell11 cell12␤cell21 cell22␤␤      my $app;␤      say 'some code'␤
```

INSTALLATION
============

You need to have [Raku](https://www.raku-lang.ir/en) and [zef](https://github.com/ugexe/zef), then run:

```console
zef install --/test Pod::Contents:auth<zef:CIAvash>
```

or if you have cloned the repo:

```console
zef install .
```

TESTING
=======

```console
prove -ve 'raku -I.' --ext rakutest
```

SUBS
====



### sub get-pod-contents-of

```raku
sub get-pod-contents-of(
    $pod where { ... },
    $thing where { ... },
    Bool :$recurse,
    |c
) returns List:D
```

Returns a list of pod contents. Can recursively find pod with C<:recurse>. Can indent pod contents with C<:indent-content>. Can include pod titles with C<:include-title>. Can disable inlining pod formatters with C<:!inline-formatters>. Can put same level items next to each other with C<:adjacent-items>.

### sub join-pod-contents-of

```raku
sub join-pod-contents-of(
    $pod where { ... },
    $thing where { ... },
    Bool :$recurse,
    |c
) returns Str:D
```

Joins pod contents of the requested Pod with the passed string or 2 newlines. Can recursively find pod with C<:recurse>. Can indent pod contents with C<:indent-content>. Can include pod titles with C<:include-title>. Can disable inlining pod formatters with C<:!inline-formatters>. Can put same level items next to each other with C<:adjacent-items>.

### sub get-first-pod

```raku
sub get-first-pod(
    $pod where { ... },
    $thing where { ... },
    Bool :$recurse
) returns Pod::Contents::POD
```

Finds the first Pod using the passed C<pod> or C<name>, does so recursively if C<:recurse> is passed.

### sub get-pods

```raku
sub get-pods(
    $pod where { ... },
    $thing where { ... },
    Bool :$recurse
) returns List:D
```

Finds all Pods using the passed C<pod> or C<name>, does so recursively if C<:recurse> is passed

### sub join-pod-contents

```raku
sub join-pod-contents(
    $pod where { ... },
    $with = "\n\n",
    |c
) returns Str:D
```

Joins pod contents of the requested Pod type with the passed string or 2 newlines. Can indent pod contents with C<:indent-content>. Can include pod titles with C<:include-title>. Can disable inlining pod formatters with C<:!inline-formatters>. Can put same level items next to each other with C<:adjacent-items>.

### sub get-pod-contents

```raku
sub get-pod-contents(
    |
) returns Mu
```

Recursively gets the Pod contents of a Pod block as a list of (list of) strings. Can indent pod contents with C<:indent-content>. Can include pod titles with C<:include-title>. Can disable inlining pod formatters with C<:!inline-formatters>. Can put same level items next to each other with C<:adjacent-items>.

### sub check-pod

```raku
sub check-pod(
    $pod where { ... },
    $pod-type where { ... }
) returns Bool
```

Returns C<True> if C<pod> matches C<pod-type>

### sub indent-content

```raku
sub indent-content(
    Str:D $string,
    Int:D $indent-level where { ... } = 4
) returns Str:D
```

Indents C<string> by C<indent-level>

REPOSITORY
==========

[https://codeberg.org/CIAvash/Pod-Contents/](https://codeberg.org/CIAvash/Pod-Contents/)

BUG
===

[https://codeberg.org/CIAvash/Pod-Contents/issues](https://codeberg.org/CIAvash/Pod-Contents/issues)

AUTHOR
======

Siavash Askari Nasr - [https://siavash.askari-nasr.com](https://siavash.askari-nasr.com)

COPYRIGHT
=========

Copyright © 2021 Siavash Askari Nasr

LICENSE
=======

This file is part of Pod::Contents.

Pod::Contents is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Pod::Contents is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with Pod::Contents. If not, see <http://www.gnu.org/licenses/>.

