# Test of hoonlint utility

use 5.010;
use strict;
use warnings;

use Data::Dumper;
use English qw( -no_match_vars );

use Test::More tests => 311 * 3;

use Test::Differences;
use IPC::Cmd qw[run_forked];

sub slurp {
    my ($fileName) = @_;
    local $RS = undef;
    my $fh;
    open $fh, q{<}, $fileName or die "Cannot open $fileName";
    my $file = <$fh>;
    close $fh;
    return \$file;
}

my $fileList = <<'END_OF_LIST';
hoons/arvo/sur/gmail-message.hoon
hoons/arvo/sur/kyev.hoon
hoons/arvo/sur/plan/diff.hoon
hoons/arvo/sur/plan/acct.hoon
hoons/arvo/sur/static.hoon
hoons/arvo/sur/down.hoon
hoons/arvo/sur/sole.hoon
hoons/arvo/sur/gh.hoon
hoons/arvo/sur/tree-include.hoon
hoons/arvo/sur/recoverable-error.hoon
hoons/arvo/sur/twitter.hoon
hoons/arvo/sur/rfc.hoon
hoons/arvo/sur/markdown.hoon
hoons/arvo/sur/unicode-data.hoon
hoons/arvo/sur/hall.hoon
hoons/arvo/sur/gmail-label.hoon
hoons/arvo/sur/lens.hoon
hoons/arvo/tests/new-hoon/mp.hoon
hoons/arvo/tests/new-hoon/ls.hoon
hoons/arvo/tests/new-hoon/thr.hoon
hoons/arvo/tests/new-hoon/myb.hoon
hoons/arvo/tests/zuse/crypto/keccak.hoon
hoons/arvo/sys/zuse.hoon
hoons/arvo/sys/hoon.hoon
hoons/arvo/sys/arvo.hoon
hoons/arvo/sys/vane/behn.hoon
hoons/arvo/sys/vane/dill.hoon
hoons/arvo/sys/vane/ford.hoon
hoons/arvo/sys/vane/ames.hoon
hoons/arvo/sys/vane/gall.hoon
hoons/arvo/sys/vane/eyre.hoon
hoons/arvo/sys/vane/xmas.hoon
hoons/arvo/sys/vane/clay.hoon
hoons/arvo/sys/vane/jael.hoon
hoons/arvo/app/gmail.hoon
hoons/arvo/app/test.hoon
hoons/arvo/app/gmail/split.hoon
hoons/arvo/app/twit.hoon
hoons/arvo/app/fora.hoon
hoons/arvo/app/static.hoon
hoons/arvo/app/hood.hoon
hoons/arvo/app/dojo.hoon
hoons/arvo/app/time.hoon
hoons/arvo/app/gh.hoon
hoons/arvo/app/ask.hoon
hoons/arvo/app/pipe.hoon
hoons/arvo/app/talk.hoon
hoons/arvo/app/curl.hoon
hoons/arvo/app/github.hoon
hoons/arvo/app/hall.hoon
hoons/arvo/sec/com/digitalocean.hoon
hoons/arvo/sec/com/asana.hoon
hoons/arvo/sec/com/dropboxapi.hoon
hoons/arvo/sec/com/googleapis.hoon
hoons/arvo/sec/com/instagram.hoon
hoons/arvo/sec/com/twitter.hoon
hoons/arvo/sec/com/slack.hoon
hoons/arvo/sec/com/github.hoon
hoons/arvo/sec/com/facebook.hoon
hoons/arvo/lib/elem-to-react-json.hoon
hoons/arvo/lib/hep-to-cab.hoon
hoons/arvo/lib/old-phon.hoon
hoons/arvo/lib/interpolate.hoon
hoons/arvo/lib/http.hoon
hoons/arvo/lib/urb-split.hoon
hoons/arvo/lib/connector.hoon
hoons/arvo/lib/frontmatter.hoon
hoons/arvo/lib/old-zuse.hoon
hoons/arvo/lib/tester.hoon
hoons/arvo/lib/hall-json.hoon
hoons/arvo/lib/prey.hoon
hoons/arvo/lib/down-jet/rend.hoon
hoons/arvo/lib/down-jet/parse.hoon
hoons/arvo/lib/time-to-id.hoon
hoons/arvo/lib/httr-to-json.hoon
hoons/arvo/lib/sole.hoon
hoons/arvo/lib/cram.hoon
hoons/arvo/lib/map-to-json.hoon
hoons/arvo/lib/tree.hoon
hoons/arvo/lib/gh-parse.hoon
hoons/arvo/lib/oauth1.hoon
hoons/arvo/lib/pretty-file.hoon
hoons/arvo/lib/twitter.hoon
hoons/arvo/lib/down-jet.hoon
hoons/arvo/lib/oauth2.hoon
hoons/arvo/lib/basic-auth.hoon
hoons/arvo/lib/hall-legacy.hoon
hoons/arvo/lib/new-hoon.hoon
hoons/arvo/lib/show-dir.hoon
hoons/arvo/lib/hood/helm.hoon
hoons/arvo/lib/hood/drum.hoon
hoons/arvo/lib/hood/kiln.hoon
hoons/arvo/lib/hood/write.hoon
hoons/arvo/lib/hood/womb.hoon
hoons/arvo/lib/hall.hoon
hoons/arvo/mar/coffee.hoon
hoons/arvo/mar/urb.hoon
hoons/arvo/mar/mime.hoon
hoons/arvo/mar/quri.hoon
hoons/arvo/mar/plan-diff.hoon
hoons/arvo/mar/noun.hoon
hoons/arvo/mar/gmail/req.hoon
hoons/arvo/mar/rss-xml.hoon
hoons/arvo/mar/tree/json.hoon
hoons/arvo/mar/tree/index.hoon
hoons/arvo/mar/tree/include.hoon
hoons/arvo/mar/tree/hymn.hoon
hoons/arvo/mar/tree/elem.hoon
hoons/arvo/mar/tree/comments.hoon
hoons/arvo/mar/ships.hoon
hoons/arvo/mar/purl.hoon
hoons/arvo/mar/hoon.hoon
hoons/arvo/mar/lens/command.hoon
hoons/arvo/mar/lens/json.hoon
hoons/arvo/mar/helm-hi.hoon
hoons/arvo/mar/write/wipe.hoon
hoons/arvo/mar/write/plan-info.hoon
hoons/arvo/mar/write/paste.hoon
hoons/arvo/mar/write/tree.hoon
hoons/arvo/mar/plan.hoon
hoons/arvo/mar/gh/list-issues.hoon
hoons/arvo/mar/gh/commit.hoon
hoons/arvo/mar/gh/issue-comment.hoon
hoons/arvo/mar/gh/issues.hoon
hoons/arvo/mar/gh/poke.hoon
hoons/arvo/mar/gh/issue.hoon
hoons/arvo/mar/gh/repository.hoon
hoons/arvo/mar/json.hoon
hoons/arvo/mar/email.hoon
hoons/arvo/mar/womb/part.hoon
hoons/arvo/mar/womb/invite.hoon
hoons/arvo/mar/womb/claim.hoon
hoons/arvo/mar/womb/bonus.hoon
hoons/arvo/mar/womb/do-claim.hoon
hoons/arvo/mar/womb/ticket-info.hoon
hoons/arvo/mar/womb/balance.hoon
hoons/arvo/mar/womb/replay-log.hoon
hoons/arvo/mar/womb/stat-all.hoon
hoons/arvo/mar/womb/do-ticket.hoon
hoons/arvo/mar/womb/recycle.hoon
hoons/arvo/mar/dill/belt.hoon
hoons/arvo/mar/dill/blit.hoon
hoons/arvo/mar/down.hoon
hoons/arvo/mar/httr.hoon
hoons/arvo/mar/tang.hoon
hoons/arvo/mar/atom.hoon
hoons/arvo/mar/path.hoon
hoons/arvo/mar/snip.hoon
hoons/arvo/mar/urbit.hoon
hoons/arvo/mar/md.hoon
hoons/arvo/mar/twit/cred.hoon
hoons/arvo/mar/twit/feed.hoon
hoons/arvo/mar/twit/post.hoon
hoons/arvo/mar/twit/usel.hoon
hoons/arvo/mar/twit/req.hoon
hoons/arvo/mar/css.hoon
hoons/arvo/mar/hymn.hoon
hoons/arvo/mar/ask-mail.hoon
hoons/arvo/mar/xml.hoon
hoons/arvo/mar/recoverable-error.hoon
hoons/arvo/mar/jam.hoon
hoons/arvo/mar/txt-diff.hoon
hoons/arvo/mar/umd.hoon
hoons/arvo/mar/elem.hoon
hoons/arvo/mar/sole/action.hoon
hoons/arvo/mar/sole/effect.hoon
hoons/arvo/mar/js.hoon
hoons/arvo/mar/markdown.hoon
hoons/arvo/mar/front.hoon
hoons/arvo/mar/fora/post.hoon
hoons/arvo/mar/fora/comment.hoon
hoons/arvo/mar/will.hoon
hoons/arvo/mar/jam-crub.hoon
hoons/arvo/mar/html.hoon
hoons/arvo/mar/txt.hoon
hoons/arvo/mar/hall/action.hoon
hoons/arvo/mar/hall/rumor.hoon
hoons/arvo/mar/hall/telegrams.hoon
hoons/arvo/mar/hall/speeches.hoon
hoons/arvo/mar/hall/command.hoon
hoons/arvo/mar/hall/prize.hoon
hoons/arvo/mar/unicode-data.hoon
hoons/arvo/mar/drum-put.hoon
hoons/arvo/mar/static/action.hoon
hoons/arvo/web/unmark/test.hoon
hoons/arvo/web/unmark/all.hoon
hoons/arvo/web/listen.hoon
hoons/arvo/web/404.hoon
hoons/arvo/web/pack/js/tree-urb.hoon
hoons/arvo/web/pack/css/codemirror-fonts-bootstrap-tree.hoon
hoons/arvo/web/dojo.hoon
hoons/arvo/web/talk.hoon
hoons/arvo/web/womb.hoon
hoons/arvo/ren/urb.hoon
hoons/arvo/ren/rss-xml.hoon
hoons/arvo/ren/tree/body.hoon
hoons/arvo/ren/tree/json.hoon
hoons/arvo/ren/tree/index.hoon
hoons/arvo/ren/tree/include.hoon
hoons/arvo/ren/tree/elem.hoon
hoons/arvo/ren/tree/head.hoon
hoons/arvo/ren/tree/combine.hoon
hoons/arvo/ren/tree/comments.hoon
hoons/arvo/ren/urb/tree.hoon
hoons/arvo/ren/css.hoon
hoons/arvo/ren/test-tree.hoon
hoons/arvo/ren/run.hoon
hoons/arvo/ren/js.hoon
hoons/arvo/gen/pipe/cancel.hoon
hoons/arvo/gen/pipe/connect.hoon
hoons/arvo/gen/pipe/list.hoon
hoons/arvo/gen/glass.hoon
hoons/arvo/gen/test.hoon
hoons/arvo/gen/gmail/list.hoon
hoons/arvo/gen/gmail/send.hoon
hoons/arvo/gen/hello.hoon
hoons/arvo/gen/al.hoon
hoons/arvo/gen/solid.hoon
hoons/arvo/gen/ticket.hoon
hoons/arvo/gen/ivory.hoon
hoons/arvo/gen/moon.hoon
hoons/arvo/gen/womb/balances.hoon
hoons/arvo/gen/womb/balance.hoon
hoons/arvo/gen/womb/stats.hoon
hoons/arvo/gen/womb/shop.hoon
hoons/arvo/gen/metal.hoon
hoons/arvo/gen/musk.hoon
hoons/arvo/gen/serving.hoon
hoons/arvo/gen/ls.hoon
hoons/arvo/gen/twit/as.hoon
hoons/arvo/gen/twit/feed.hoon
hoons/arvo/gen/help.hoon
hoons/arvo/gen/ask/admins.hoon
hoons/arvo/gen/brass.hoon
hoons/arvo/gen/tree.hoon
hoons/arvo/gen/capitalize.hoon
hoons/arvo/gen/bug.hoon
hoons/arvo/gen/code.hoon
hoons/arvo/gen/curl-hiss.hoon
hoons/arvo/gen/cat.hoon
hoons/arvo/gen/curl/url.hoon
hoons/arvo/gen/curl.hoon
hoons/arvo/gen/hood/sync.hoon
hoons/arvo/gen/hood/replay-womb-log.hoon
hoons/arvo/gen/hood/mv.hoon
hoons/arvo/gen/hood/unlink.hoon
hoons/arvo/gen/hood/rekey.hoon
hoons/arvo/gen/hood/commit.hoon
hoons/arvo/gen/hood/reset.hoon
hoons/arvo/gen/hood/cp.hoon
hoons/arvo/gen/hood/obey.hoon
hoons/arvo/gen/hood/label.hoon
hoons/arvo/gen/hood/cancel.hoon
hoons/arvo/gen/hood/begin.hoon
hoons/arvo/gen/hood/manage-old-key.hoon
hoons/arvo/gen/hood/invite.hoon
hoons/arvo/gen/hood/tlon/init-stream.hoon
hoons/arvo/gen/hood/tlon/add-fora.hoon
hoons/arvo/gen/hood/tlon/add-stream.hoon
hoons/arvo/gen/hood/ping.hoon
hoons/arvo/gen/hood/claim.hoon
hoons/arvo/gen/hood/hi.hoon
hoons/arvo/gen/hood/serve.hoon
hoons/arvo/gen/hood/deset.hoon
hoons/arvo/gen/hood/reload.hoon
hoons/arvo/gen/hood/init-oauth2.hoon
hoons/arvo/gen/hood/rm.hoon
hoons/arvo/gen/hood/manage.hoon
hoons/arvo/gen/hood/autoload.hoon
hoons/arvo/gen/hood/schedule.hoon
hoons/arvo/gen/hood/reload-desk.hoon
hoons/arvo/gen/hood/bonus.hoon
hoons/arvo/gen/hood/unmount.hoon
hoons/arvo/gen/hood/release-ships.hoon
hoons/arvo/gen/hood/exit.hoon
hoons/arvo/gen/hood/merge.hoon
hoons/arvo/gen/hood/rf.hoon
hoons/arvo/gen/hood/report.hoon
hoons/arvo/gen/hood/verb.hoon
hoons/arvo/gen/hood/mount.hoon
hoons/arvo/gen/hood/breload.hoon
hoons/arvo/gen/hood/syncs.hoon
hoons/arvo/gen/hood/public.hoon
hoons/arvo/gen/hood/private.hoon
hoons/arvo/gen/hood/nuke.hoon
hoons/arvo/gen/hood/mass.hoon
hoons/arvo/gen/hood/overload.hoon
hoons/arvo/gen/hood/reinvite.hoon
hoons/arvo/gen/hood/ask.hoon
hoons/arvo/gen/hood/start.hoon
hoons/arvo/gen/hood/transfer.hoon
hoons/arvo/gen/hood/load.hoon
hoons/arvo/gen/hood/track.hoon
hoons/arvo/gen/hood/save.hoon
hoons/arvo/gen/hood/rc.hoon
hoons/arvo/gen/hood/init-oauth2/google.hoon
hoons/arvo/gen/hood/wipe-ford.hoon
hoons/arvo/gen/hood/init-oauth1.hoon
hoons/arvo/gen/hood/init-auth-basic.hoon
hoons/arvo/gen/hood/unsync.hoon
hoons/arvo/gen/hood/reboot.hoon
hoons/arvo/gen/hood/release.hoon
hoons/arvo/gen/hood/link.hoon
hoons/arvo/gen/pope.hoon
hoons/arvo/gen/deco.hoon
hoons/arvo/gen/hall/log.hoon
hoons/arvo/gen/hall/load-legacy.hoon
hoons/arvo/gen/hall/load.hoon
hoons/arvo/gen/hall/save.hoon
hoons/arvo/gen/hall/unlog.hoon
hoons/arvo/gen/static/build.hoon
END_OF_LIST

local $Data::Dumper::Deepcopy    = 1;
local $Data::Dumper::Terse    = 1;

my @Iflags = map { '-I' . $_ } @INC;

FILE: for my $fileName (split "\n", $fileList) {
    my $origName = $fileName;
    chomp $fileName;

    my $cmd = [ $^X, @Iflags, 'hoonlint',
    '--sup=suppressions/aberration.suppressions',
    $fileName ];

    my @stdout       = ();
    my $gatherStdout = sub {
        push @stdout, @_;
    };

    my @stderr       = ();
    my $gatherStderr = sub {
        push @stderr, @_;
    };

    my $result = run_forked(
        $cmd,
        {
            child_stdin    => '',
            stdout_handler => $gatherStdout,
            stderr_handler => $gatherStderr,
            discard_output => 1,
        }
    );

    my $exitCode = $result->{'exit_code'};
    Test::More::ok( $exitCode eq 0, "exit code for $fileName is $exitCode" );

    my $errMsg = $result->{'err_msg'};
    Test::More::diag($errMsg) if $errMsg;

    my $stderr = join q{}, @stderr;
    Test::More::diag($stderr) if $stderr;
    Test::More::ok( $stderr eq q{}, "STDERR for $fileName" );

    my $stdout = join q{}, @stdout;
    Test::More::diag($stdout) if $stdout;
    Test::More::ok( $stdout eq q{}, "STDOUT for $fileName" );
  }

# vim: expandtab shiftwidth=4:
