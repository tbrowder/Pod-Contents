use v6.d;

=NAME Pod::ContentsKebab - a L<Raku|https://www.raku-lang.ir/en> module for getting Pod contents as a list or string.

=begin para
NOTE: This module is an exact copy of \@CIAvash's fine Raku module Pod::Contents. See
the new 'Changes' file for details, but the two things changed were: (1) making the
module structure use module App::Mi6 and (2) changing indentifier names to 'kebab-case'
from 'snake-case'.
=end para

=DESCRIPTION Pod::ContentsKebab is a L<Raku|https://www.raku-lang.ir/en> module for getting the Pod contents as a
list of strings or string.
Pod formatters can get inlined, pod contents can be indented (with custom level) and joined with a
custom string and titles can be included for table headers and defn terms.

=begin SYNOPSIS

=begin code :lang<raku>

use Pod::ContentsKebab:auth<zef:CIAvash>;

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

=end code

=end SYNOPSIS

=begin INSTALLATION

You need to have L<Raku|https://www.raku-lang.ir/en> and L<zef|https://github.com/ugexe/zef>,
then run:

=begin code :lang<console>

zef install --/test Pod::ContentsKebab:auth<zef:CIAvash>

=end code

or if you have cloned the repo:

=begin code :lang<console>

zef install .

=end code

=end INSTALLATION

=begin TESTING

=begin code :lang<console>

prove -ve 'raku -I.' --ext rakutest

=end code

=end TESTING

unit module Pod::ContentsKebab:auth($?DISTRIBUTION.meta<auth>):ver($?DISTRIBUTION.meta<version>);

subset SomePod       where Pod::Block | Pod::Heading     | Pod::FormattingCode;
subset IndentablePod where Pod::Item  | Pod::Block::Code | Pod::Defn;
subset POD           where SomePod    | IndentablePod;
subset StrOrPod      where Str:D      | POD;
subset ArrayOfPod of List where .all ~~ POD;
subset PodOrArrayOfPod where POD | ArrayOfPod;

=SUBS

#| Returns a list of pod contents.
#| Can recursively find pod with C<:recurse>.
#| Can indent pod contents with C<:indent-content>.
#| Can include pod titles with C<:include-title>.
#| Can disable inlining pod formatters with C<:!inline-formatters>.
#| Can put same level items next to each other with C<:adjacent-items>.
sub get-pod-contents-of (PodOrArrayOfPod $pod, StrOrPod $thing, Bool :$recurse, |c --> List:D) is export {
    get-pod-contents $_, |c given get-first-pod $pod, $thing, :$recurse;
}

#| Joins pod contents of the requested Pod with the passed string or 2 newlines.
#| Can recursively find pod with C<:recurse>.
#| Can indent pod contents with C<:indent-content>.
#| Can include pod titles with C<:include-title>.
#| Can disable inlining pod formatters with C<:!inline-formatters>.
#| Can put same level items next to each other with C<:adjacent-items>.
sub join-pod-contents-of (PodOrArrayOfPod $pod, StrOrPod $thing, Bool :$recurse, |c --> Str:D) is export {
    join-pod-contents $_, |c given get-first-pod $pod, $thing, :$recurse;
}

#| Finds the first Pod using the passed C<pod> or C<name>, does so recursively if C<:recurse> is passed.
proto get-first-pod (PodOrArrayOfPod $pod, StrOrPod $thing, Bool :$recurse --> POD) is export {*}

multi get-first-pod (@pod, $pod-type, :$recurse = False --> POD) {
    if $recurse {
        @pod.map: -> POD $pod {
            if check-pod $pod, $pod-type {
                $pod;
            } elsif $pod.contents ~~ ArrayOfPod {
                $_ with samewith $pod.contents, $pod-type, :recurse;
            }
        } andthen .head;
    } else {
        @pod.first: &check-pod.assuming: *, $pod-type;
    }
}

multi get-first-pod (POD $pod, POD $pod-type, :$recurse = False --> POD) {
    samewith $pod.contents, $pod-type, :$recurse;
}

#| Finds all Pods using the passed C<pod> or C<name>, does so recursively if C<:recurse> is passed
proto get-pods (PodOrArrayOfPod $pod, StrOrPod $thing, Bool :$recurse --> List:D) is export {*}

multi get-pods (@pods, $pod-type, :$recurse = False) {
    if $recurse {
        @pods.map: -> POD $pod {
            if check-pod $pod, $pod-type {
                $pod;
            } elsif $pod.contents ~~ ArrayOfPod {
                $_ with |samewith $pod.contents, $pod-type, :recurse;
            }
        } andthen .grep(&so).List;
    } else {
        @pods.grep: &check-pod.assuming: *, $pod-type andthen .List;
    }
}

multi get-pods (POD $pod, $pod-type, :$recurse = False) {
    samewith $pod.contents, $pod-type, :$recurse;
}

#| Joins pod contents of the requested Pod type with the passed string or 2 newlines.
#| Can indent pod contents with C<:indent-content>.
#| Can include pod titles with C<:include-title>.
#| Can disable inlining pod formatters with C<:!inline-formatters>.
#| Can put same level items next to each other with C<:adjacent-items>.
sub join-pod-contents (PodOrArrayOfPod $pod, $with = "\n\n", |c --> Str:D) is export {
    if get-pod-contents $pod, |c -> @contents {
        join $with, do given @contents {
            if $_ ~~ List:D && .elems > 1 && .all ~~ List:D { .join: "\n" }
            else {
                .map: {
                    when List:D { .join: "\n" }
                    default     { $_ }
                };
            }
        }
    } else {
        '';
    }
}

#| Recursively gets the Pod contents of a Pod block as a list of (list of) strings.
#| Can indent pod contents with C<:indent-content>.
#| Can include pod titles with C<:include-title>.
#| Can disable inlining pod formatters with C<:!inline-formatters>.
#| Can put same level items next to each other with C<:adjacent-items>.
proto get-pod-contents (|) is export {*};

multi get-pod-contents (IndentablePod:D $pod,
                        |c (Bool:D :$indent-content       = False,
                            UInt:D :$indent-level is copy = 4,
                            Bool:D :$include-title        = False,
                            |)
                        --> List:D) {
    my @contents = samewith $pod.contents, |c;

    if $indent-content {
        $indent-level ×= .level - 1 when Pod::Item given $pod;

        @contents.=map: *.join("\n").&indent-content: $indent-level;
    }

    if $include-title && $pod ~~ Pod::Defn {
        @contents.unshift: (samewith($pod.term, |c), @contents.shift);
    }

    @contents.List;
}

multi get-pod-contents (SomePod:D $pod, |c (Bool:D :$include-title = False, |) --> List:D) {
    given $pod {
        when Pod::Block::Table:D {
            my List:D $contents       = .contents;
            my List:D $table-contents = $include-title ?? (.headers || Empty, |$contents) !! $contents;

            $table-contents.map({ .map({ samewith $_, |c }).List }).List;
        }
        default {
            samewith .contents, |c;
        }
    }
}

multi get-pod-contents (@pod-contents,
                        |c (Bool:D :$inline-formatters = True, Bool:D :$adjacent-items = False, |)
                        --> List:D) {
    my @contents;

    loop (my $i = 0; $i < @pod-contents; $i++) {
        if $inline-formatters and @pod-contents[$i] ~~ Pod::FormattingCode:D {
            # First observation of pod formatter
            # If the pod content before first pod formatter is a string, consider it the first index,
            # otherwise first index is the pod formatter
            my UInt:D $first-index = $i > 0 && @contents[$i - 1] ~~ Str:D ?? $i - 1 !! $i;

            while @pod-contents[$i] ~~ Pod::FormattingCode:D | Str:D {
                my Str:D $string = samewith(@pod-contents[$i], |c).join;

                # Append string to the first content
                @contents[$first-index] ~= $string;

                $i++;
            }
        } elsif $adjacent-items and @pod-contents[$i] ~~ Pod::Item:D {
            my @item-contents;

            while @pod-contents[$i] ~~ Pod::Item:D {
                @item-contents.append: samewith @pod-contents[$i], |c;

                $i++;
            }

            @contents.push: @item-contents.List;
        } else {
            given @pod-contents[$i] {
                when List:D | Pod::Block::Table:D {
                    @contents.push: samewith($_, |c).List;
                }
                default {
                    @contents.append: samewith($_, |c);
                }
            }
        }
    }

    @contents.List;
}

multi get-pod-contents (Str:D $content, | --> Str:D) {
    $content;
}

#| Returns C<True> if C<pod> matches C<pod-type>
sub check-pod (POD $pod, StrOrPod $pod-type --> Bool:D) is export(:helpers) {
    $pod | $pod.?name ~~ $pod-type;
}

#| Indents C<string> by C<indent-level>
sub indent-content (Str:D $string, UInt:D $indent-level = 4 --> Str:D) is export(:helpers) {
    $string.lines.map(' ' x $indent-level ~ *).join: "\n";
}

=REPOSITORY L<https://codeberg.org/CIAvash/Pod-ContentsKebab/>

=BUG L<https://codeberg.org/CIAvash/Pod-ContentsKebab/issues>

=AUTHOR Siavash Askari Nasr - L<https://siavash.askari-nasr.com>

=COPYRIGHT Copyright © 2021 Siavash Askari Nasr

=begin LICENSE
This file is part of Pod::ContentsKebab.

Pod::ContentsKebab is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Pod::ContentsKebab is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Pod::ContentsKebab.  If not, see <http://www.gnu.org/licenses/>.
=end LICENSE
