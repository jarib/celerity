                <h2>Benchmarks</h2>
                <p>We've played a little with some early crude benchmarking. Three scenarios were benchmarked in Celerity and Watir.</p>
                <ul>
                    <li><a href="http://celerity.rubyforge.org/svn/trunk/benchmark/bm_2000_spans.rb">Scenario 1: Local HTML file with 2000 span elements </a></li>
                    <li><a href="http://celerity.rubyforge.org/svn/trunk/benchmark/bm_google_images.rb">Scenario 2: Looping a Google image search result</a></li>
                    <li><a href="http://celerity.rubyforge.org/svn/trunk/benchmark/bm_digg.rb">Scenario 3: Counting the number of "diggs" on digg.com's front page</a></li>
                </ul>
                
                <h2>Results: Overview</h2>
                <p>This table provides a quick overview. For more accurate information, see below.</p>
                <table>
                    <tr>
                        <th>Scenario</th>
                        <th>Watir (total)</th>
                        <th>Celerity (total)</th>
                        <th>Time reduction</th>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td>24.41 s</td>
                        <td>0.68 s</td>
                        <td>97.23 %</td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>276.06 s</td>
                        <td>116.72 s</td>
                        <td>57.72 %</td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>178.59 s</td>
                        <td>40.01 s</td>
                        <td>77.60 %</td>
                    </tr>
                </table>
                <h2>Results: Actual output from benchmark scripts</h2>
                <p></p>
<h3>Watir on Ruby: Scenario 1</h3>
<pre>
n = 20
                               user     system      total        real
Loop through all spans     0.344000   0.000000   0.344000 (  0.407000)
Last span by id (String)   3.359000   1.062000   4.421000 ( 12.031000)
Last span by id (Regexp)   3.297000   1.266000   4.563000 ( 11.969000)

total  : 24.4070000648499
average: 8.13566668828329

</pre>

<h3>Celerity on JRuby: Scenario 1</h3>
<pre>
n = 20
                               user     system      total        real
Loop through all spans     0.656000   0.000000   0.656000 (  0.652584)
Last span by id (String)   0.000000   0.000000   0.000000 (  0.002165)
Last span by id (Regexp)   0.031000   0.000000   0.031000 (  0.020777)

total  : 0.6755261421203613
average: 0.2251753807067871

</pre>

<h3>Watir on Ruby: Scenario 2</h3>
<pre>
n = 5
                                  user     system      total        real
Google image search results  41.109000  11.672000  52.781000 (276.062000)
total  : 276.06200003624
average: 276.06200003624

</pre>

<h3>Celerity on JRuby: Scenario 2</h3>
<pre>
n = 5
                                  user     system      total        real
Google image search results 116.703000   0.000000 116.703000 (116.715138)

total  : 116.71513795852661
average: 116.71513795852661

</pre>

<h3>Watir on Ruby: Scenario 3</h3>
<pre>
n = 5
                          user     system      total        real
Diggs on front page   6.406000   1.828000   8.234000 (178.594000)

total  : 178.593999862671
average: 178.593999862671

</pre>

<h3>Celerity on JRuby: Scenario 3</h3>
<pre>
n = 5
                           user     system      total        real
Diggs on front page   40.016000   0.000000  40.016000 ( 40.006166)

total  : 40.006165981292725
average: 40.006165981292725 

</pre>