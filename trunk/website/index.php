<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
    <head>
        <title>Celerity</title>
        <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />
        <link rel="stylesheet" type="text/css" media="screen" href="css/screen.css" />
    </head>
    <body>
    	<div id="container">
            <div id="header">
                <h1><a href=".">Celerity</a></h1>
                <div id="tagline">
                    { French célérité > Latin celeritas > Latin celer, fast, swift. <br />
                    Rapidity of motion; quickness; swiftness. }
                </div>
                <div id="leftSlice"></div>
                <div id="rightSlice"></div>
            </div>
            <div id="nav">
                <ul>
                    <li><a accesskey="h" title="Front page" href="." hreflang="en">Home</a></li>
                    <li><a accesskey="p" title="Celerity at Rubyforge" href="http://rubyforge.org/projects/celerity/" hreflang="en">Rubyforge project</a></li>
                    <li><a accesskey="d" title="Download Celerity" href="http://rubyforge.org/frs/?group_id=6198" hreflang="en">Download</a></li>
                    <li><a accesskey="f" title="Discuss Celerity" href="http://rubyforge.org/forum/?group_id=6198" hreflang="en">Forum</a></li>
                    <li><a accesskey="m" title="Stay up-to-date" href="http://rubyforge.org/mail/?group_id=6198" hreflang="en">Mailing lists</a></li>
                    <li><a accesskey="s" title="We've proved the infinite monkey theorem" href="http://celerity.rubyforge.org/svn/" hreflang="en">Browse source</a></li>
                    <li><a accesskey="b" title="Report and browse bugs" href="http://rubyforge.org/tracker/?atid=24033&amp;group_id=6198&amp;func=browse" hreflang="en">Bug tracker</a></li>
                    <li><a accesskey="e" title="Request and browse new features" href="http://rubyforge.org/tracker/?atid=24036&amp;group_id=6198&amp;func=browse" hreflang="en">Feature tracker</a></li>
                    <li><a accesskey="n" title="Benchmarks" href="?page=benchmarks" hreflang="en">Benchmarks</a></li>
                </ul>
            </div>
            <div id="content">
                <?php
                    $file = 'pages/'.$_GET['page'].'.php';
                    if (file_exists($file)) {
                        include($file);
                    }
                    else {
                        include('pages/home.php');
                    }
                ?>
            </div>
        </div>
        <div id="footer">
            <p>
                <span class="w3cbutton">
                    <a href="http://validator.w3.org/check?uri=referer" title="Valid XHTML 1.0 Strict" hreflang="en">
                            <span class="w3c">W3C</span>
                            <span class="spec">XHTML 1.0</span>
                    </a>
                </span>
                &nbsp;
                <span class="w3cbutton">
                    <a href="http://jigsaw.w3.org/css-validator/check/referer" title="Valid CSS" hreflang="en">
                            <span class="w3c">W3C</span>
                            <span class="spec">CSS</span>
                    </a>
                </span>
                &nbsp;
                <span class="w3cbutton">
                    <a href="http://www.w3.org/WAI/WCAG1AAA-Conformance" title="Conforming with the highest level (AAA) of the Web Content Accessibility Guidelines 1.0" hreflang="en">
                            <span class="w3c">W3C</span>
                            <span class="spec">WAI&#8209;<span class="red">AAA</span>&nbsp;WCAG&nbsp;1.0</span>
                    </a>
                </span>
            </p>
            <address>
                <a href="mailto:tinius.alexander@lystadonline.no">T. Alexander Lystad</a>, 13th May 2008
            </address>
        </div>
    </body>
</html>