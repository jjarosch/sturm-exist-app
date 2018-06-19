xquery version "3.0";

(:~
 : Letters from the STURM-Archive I
 : A Digital Edition
 :
 : Edited and developed by Marjam Mahmoodzada, Thomas Kollatz and Torsten Schrade
 : Academy of Sciences and Literature | Mainz
 :
 : XQuery controller for serving static HTML content out of an eXist webapp.
 :
 : @author Torsten Schrade
 : @email <Torsten.Schrade@adwmainz.de>
 : @version 1.0.0 
 : @licence MIT
:)

import module namespace sturm_resolver = 'https://sturm-edition.de/sturm_resolver' at '../xql/utilities/resolver.xqm';

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;
declare variable $fileIndex := string-join(doc('/db/apps/sturm-edition/temp/processed.xml')//processed/text());

(: forward to index.html on app root :)
if ($exist:resource eq '' and $exist:path eq '/') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
        <forward url="{concat($exist:controller, '/index.html')}">
            <set-header name="Accept-Encoding" value="gzip"/>
            <set-header name="Content-Type" value="text/html"/>
        </forward>
    </dispatch>
else if (contains($exist:path, 'id/')) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{sturm_resolver:resolveUri()}"/>
    </dispatch>
(: forward to api.xql on REST entry point :)
else if (contains($exist:path, 'api/v1')) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, '/api.xql')}"/>
    </dispatch>
(: just a directory is given (like '/foobar/'), $exist:resource is empty; throw 404 :)
else if ($exist:resource eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
        <set-header name="Status-Code" value="404" />
        <forward url="{concat($exist:controller, '/404.html')}"/>
    </dispatch>
(: just a file without .html ending is given (like '/foobar'); throw 404 :)
else if (not(ends-with($exist:resource, '.html')) and contains($fileIndex, $exist:resource)) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
        <set-header name="Status-Code" value="404" />
        <forward url="{concat($exist:controller, '/404.html')}"/>
    </dispatch>
(: in list of known html files; throw 404 if just a /.html file ending is given :)
else if ($exist:resource ne '.html' and contains($fileIndex, $exist:resource)) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
        <set-header name="Accept-Encoding" value="gzip"/>
        <set-header name="Content-Type" value="text/html"/>
    </dispatch>
(: css, js, png, jpg and pdf are allowed (but only if not just the file ending is given) :)
else if (
        $exist:resource ne '.css' and ends-with($exist:resource, ".css") or 
        $exist:resource ne '.js' and ends-with($exist:resource, ".js") or
        $exist:resource ne '.png' and ends-with($exist:resource, ".png") or
        $exist:resource ne '.jpg' and ends-with($exist:resource, ".jpg") or
        $exist:resource ne '.pdf' and ends-with($exist:resource, ".pdf") or
        $exist:resource ne '.eot' and ends-with($exist:resource, ".eot") or
        $exist:resource ne '.ttf' and ends-with($exist:resource, ".ttf") or
        $exist:resource ne '.woff' and ends-with($exist:resource, ".woff") or
        $exist:resource ne '.woff2' and ends-with($exist:resource, ".woff2") or
        $exist:resource ne '.xml' and ends-with($exist:resource, ".xml") or
        $exist:resource ne '.txt' and ends-with($exist:resource, ".txt")
    ) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
(: anything else throws 404 :)
else
    (: everything else throws 404 :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
        <set-header name="Status-Code" value="404" />
        <forward url="{concat($exist:controller, '/404.html')}"/>
    </dispatch>
